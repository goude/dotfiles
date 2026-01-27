// --- user-tweakable settings ---
float warp = 0.10;        // CRT curvature
float scan = 0.8;        // scanline darkness

float brightness = 1.0;  // 1.0 = neutral
float contrast   = 1.0;  // 1.0 = neutral

float glowStrength = 0.25; // 0.0 = off
float glowRadius   = 2.0;  // pixels (keep small, 1–2)

// --------------------------------

vec3 applyBrightnessContrast(vec3 c, float b, float k)
{
    // contrast around mid-grey, then brightness
    c = (c - 0.5) * k + 0.5;
    return c * b;
}

vec3 sampleGlow(vec2 uv)
{
    // simple 5-tap cross blur (cheap, stable)
    vec2 px = glowRadius / iResolution.xy;

    vec3 g  = texture(iChannel0, uv).rgb * 0.4;
    g += texture(iChannel0, uv + vec2(px.x, 0.0)).rgb * 0.15;
    g += texture(iChannel0, uv - vec2(px.x, 0.0)).rgb * 0.15;
    g += texture(iChannel0, uv + vec2(0.0, px.y)).rgb * 0.15;
    g += texture(iChannel0, uv - vec2(0.0, px.y)).rgb * 0.15;

    return g;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // normalized coords
    vec2 uv = fragCoord / iResolution.xy;

    // squared distance from center
    vec2 dc = abs(0.5 - uv);
    dc *= dc;

    // CRT warp
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;

    // scanlines
    float applyScan = abs(sin(fragCoord.y) * 0.25 * scan);

    // base color
    vec3 color = texture(iChannel0, uv).rgb;
    color = mix(color, vec3(0.0), applyScan);

    // glow (pre-BC so it blooms highlights naturally)
    vec3 glow = sampleGlow(uv);
    color += glow * glowStrength;

    // brightness / contrast
    color = applyBrightnessContrast(color, brightness, contrast);

    fragColor = vec4(color, 1.0);
}
