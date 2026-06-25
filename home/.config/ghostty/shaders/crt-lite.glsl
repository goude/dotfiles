// crt-lite.glsl — lightweight single-pass CRT for weak GPUs (e.g. laszlo, the
// Pi 500 / VideoCore VII). Keeps the feel of the heavy crt-cursor + crt-monitor
// stack — discrete scanlines, a cursor trail, and a slight glow — in ONE pass.
//
// Everything is tunable for optimization. To claw back frame time, flip a
// feature's ENABLE_* to 0 (the whole block is compiled out), or lower its cost
// knob. Rough cost order, most expensive first: GLOW (4 texture taps), CURSOR
// (sharp SDF trail; cross-products + a fixed 4-corner loop, no texture taps),
// SCANLINES (cheap math, ~free). The costly bits of the heavy stack — the
// 100-iteration moving-scanline loop and 3-tap chromatic convergence — stay out.

// ---- feature toggles (1 = on, 0 = compiled out) ----
#define ENABLE_GLOW      1
#define ENABLE_CURSOR    1
#define ENABLE_SCANLINES 1

// ---- scanlines (discrete dark rows) ----
const float SCAN_DARKNESS = 0.30;  // 0 = none, 1 = black gaps
const float SCAN_DENSITY  = 0.50;  // rows per pixel; 0.5 = a dark line every 2px

// ---- glow (cheap 4-tap diagonal bloom) ----
const float GLOW_STRENGTH = 0.22;  // how much blurred light to add back
const float GLOW_RADIUS   = 1.5;   // tap offset in pixels; bigger = softer/blurrier

// ---- cursor trail (sharp rectangle head + triangle wedge, like crt-cursor) ----
const float CURSOR_GLOW     = 0.60; // trail brightness
const float CURSOR_FADE     = 6.0;  // higher = trail vanishes faster
const float CURSOR_EDGE     = 0.010;// glow falloff outside the shape (uv units); smaller = crisper
const float CURSOR_DURATION = 0.30; // seconds for the wedge to collapse into the block
const float TRAIL_MIN_DIST  = 0.20; // below this travel, draw just the block (no wedge)

const float EPS = 1e-6;
const float PI  = 3.14159265;

// 4 diagonal taps averaged — a poor-man's box blur, ~1/3 the cost of the
// heavy shader's 5-tap cross plus it skips the per-frame pulsation trig.
vec3 sampleGlow(vec2 uv) {
    vec2 px = GLOW_RADIUS / iResolution.xy;
    vec3 g  = texture(iChannel0, uv + vec2( px.x,  px.y)).rgb;
    g      += texture(iChannel0, uv + vec2(-px.x,  px.y)).rgb;
    g      += texture(iChannel0, uv + vec2( px.x, -px.y)).rgb;
    g      += texture(iChannel0, uv + vec2(-px.x, -px.y)).rgb;
    return g * 0.25;
}

// --- sharp cursor SDFs, ported from crt-cursor.glsl (straight edges, no caps) ---
float min_(float a, float b, float c) { return min(a, min(b, c)); }
float max_(float a, float b, float c) { return max(a, max(b, c)); }

float sdRectangle(vec2 p, vec2 topLeft, vec2 size) {
    vec2 center = topLeft + vec2(size.x, -size.y) * 0.5;
    vec2 d = abs(p - center) - size * 0.5;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float sdSeg(vec2 p, vec2 a) {
    vec2 c = a * clamp(dot(p, a) / (dot(a, a) + EPS), 0.0, 1.0) - p;
    return sqrt(dot(c, c));
}

float sdTriangle(vec2 p, vec2 a, vec2 b, vec2 c) {
    a -= p; b -= p; c -= p;
    vec3 t = cross(vec3(a.x, b.x, c.x), vec3(a.y, b.y, c.y));
    vec2 m = vec2(min_(t.x, t.y, t.z), max_(t.x, t.y, t.z));
    float s = -1.0 + 2.0 * step(m.x, 0.0) * step(0.0, m.y);
    return s * min_(sdSeg(a, a - b), sdSeg(b, b - c), sdSeg(c, c - a));
}

// rectangle at the cursor, plus a triangle wedge fanning back to the previous
// position; `t` morphs the wedge into the rectangle as the move settles.
float sdTrail(vec2 p, vec2 currPos, vec2 currSize, vec2 prevPos, vec2 prevSize, float t) {
    vec2 w = vec2(currSize.x, 0.0), h = vec2(0.0, -currSize.y);
    vec2 tl = currPos, tr = tl + w, bl = tl + h, br = bl + w;
    vec2 currC = (tl + br) * 0.5;
    vec2 prevC = prevPos + vec2(prevSize.x, -prevSize.y) * 0.5;

    float rectDist = max(sdRectangle(p, currPos, currSize), 0.0);
    if (distance(currC, prevC) < TRAIL_MIN_DIST) return rectDist;

    // pick the two cursor corners spanning the widest angle from prevC — the
    // outer edges of the wedge. Fixed 4-iteration loop; cheap.
    vec2 corners[4] = vec2[4](tl, tr, br, bl);
    vec2 dir = normalize(currC - prevC), triB = tl, triC = tl;
    float lo = 1.0 / EPS, hi = -lo;
    for (int i = 0; i < 4; ++i) {
        vec2 dlt = corners[i] - prevC;
        float rel = atan(dir.x * dlt.y - dir.y * dlt.x, dot(dir, dlt));
        if (rel < lo) { lo = rel; triB = corners[i]; }
        if (rel > hi) { hi = rel; triC = corners[i]; }
    }
    float triDist = max(sdTriangle(p, prevC, triB, triC), 0.0);
    return min(rectDist, mix(triDist, rectDist, t));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec3 color = texture(iChannel0, uv).rgb;

#if ENABLE_GLOW
    color += sampleGlow(uv) * GLOW_STRENGTH;
#endif

#if ENABLE_SCANLINES
    // cos(PI*y) hits ±1 on integer rows, so 0.5-0.5cos alternates 0/1 per row:
    // crisp discrete scanlines rather than a soft sine ripple.
    float scanMask = SCAN_DARKNESS * (0.5 - 0.5 * cos(fragCoord.y * 2.0 * PI * SCAN_DENSITY));
    color = mix(color, vec3(0.0), scanMask);
#endif

#if ENABLE_CURSOR
    // xy = top-left, zw = (width, height), all in pixels → uv.
    vec2 currPos  = iCurrentCursor.xy  / iResolution.xy;
    vec2 currSize = iCurrentCursor.zw  / iResolution.xy;
    vec2 prevPos  = iPreviousCursor.xy / iResolution.xy;
    vec2 prevSize = iPreviousCursor.zw / iResolution.xy;

    float elapsed = iTime - iTimeCursorChange;
    float t       = clamp(elapsed / CURSOR_DURATION, 0.0, 1.0);
    float tShape  = 1.0 - pow(1.0 - t, 3.0);          // wedge → block ease
    float tVisible = exp(-elapsed * CURSOR_FADE);      // fade the whole thing out

    float d    = sdTrail(uv, currPos, currSize, prevPos, prevSize, tShape);
    float glow = smoothstep(CURSOR_EDGE, 0.0, d);      // 1 inside the sharp shape, crisp falloff
    color += iCurrentCursorColor.rgb * glow * tVisible * CURSOR_GLOW;
#endif

    fragColor = vec4(color, 1.0);
}
