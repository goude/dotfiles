// --- feature toggles (true = enabled, false = skipped) ---
const bool ENABLE_WARP = true;
const bool ENABLE_STATIC_SCANLINES = true;
const bool ENABLE_GLOW = true;
const bool ENABLE_MOVING_SCANLINE = true;
const bool ENABLE_VIGNETTE = true;
const bool ENABLE_CONVERGENCE = true;
const bool ENABLE_SCANLINE_ENERGY = true;

// --- user-tweakable settings ---
const float warp = 0.10;           // CRT curvature

const float scan = 0.5;            // static scanline darkness
const float scanEnergyVar = 0.15;  // scanline intensity variation (beam energy)

const float blackLevel = 0.03;     // black crush: remap [0,1] → [0, 1-blackLevel] then clamp
const float blackGamma = 1.0;      // gamma curve: >1.0 = darker darks, 1.0 = linear

const float glowStrength = 0.5;
const float glowRadius   = 2.0;
const float glowPulseSpeed = 0.1;  // pulsation speed (Hz-ish), 0 = static
const float glowPulseDepth = 0.2; // pulsation depth: 0 = none, 1 = full off/on

const float scanDuration = 2.5;
const float scanWidth = 0.02;
const float afterglowLength = 0.15;
const float scanIntensity = 0.3;
const float minInterval = 299.0;
const float maxInterval = 300.0;

const float vignetteStrength = 0.3;
const float vignetteSoftness = 0.4;

const float convergenceAmount = 0.8;
const float convergenceDrift = 0.05;
// --------------------------------

vec3 sampleGlow(vec2 uv)
{
    vec2 px = glowRadius / iResolution.xy;
    vec3 g  = texture(iChannel0, uv).rgb * 0.4;
    g += texture(iChannel0, uv + vec2(px.x, 0.0)).rgb * 0.15;
    g += texture(iChannel0, uv - vec2(px.x, 0.0)).rgb * 0.15;
    g += texture(iChannel0, uv + vec2(0.0, px.y)).rgb * 0.15;
    g += texture(iChannel0, uv - vec2(0.0, px.y)).rgb * 0.15;
    return g;
}

float hash(float n)
{
    return fract(sin(n * 91.3458) * 47453.5453);
}

float movingScanline(float y, float time)
{
    float cycleStart = 0.0;
    float cycleIndex = 0.0;

    // first cycle: scanline runs immediately
    if (time <= scanDuration) {
        float scanPos = time / scanDuration;
        float dist = y - scanPos;
        float line = smoothstep(scanWidth, 0.0, abs(dist));
        float glow = smoothstep(afterglowLength, 0.0, -dist) * step(dist, 0.0);
        return line + glow * 0.5;
    }

    cycleStart = scanDuration;

    for (int i = 0; i < 100; i++) {
        float interval = mix(minInterval, maxInterval, hash(cycleIndex));
        if (cycleStart + interval > time) return 0.0;
        cycleStart += interval;

        if (time <= cycleStart + scanDuration) {
            float scanPos = (time - cycleStart) / scanDuration;
            float dist = y - scanPos;
            float line = smoothstep(scanWidth, 0.0, abs(dist));
            float glow = smoothstep(afterglowLength, 0.0, -dist) * step(dist, 0.0);
            return line + glow * 0.5;
        }

        cycleStart += scanDuration;
        cycleIndex += 1.0;
    }

    return 0.0;
}

float vignette(vec2 uv)
{
    vec2 center = uv - 0.5;
    float dist = length(center);
    float vig = smoothstep(0.5, 0.5 - vignetteSoftness, dist);
    return mix(1.0, vig, vignetteStrength);
}

vec3 sampleConvergence(vec2 uv, float time)
{
    vec2 px = 1.0 / iResolution.xy;
    float t = time * convergenceDrift;

    vec2 rOffset = vec2(
        sin(t * 1.1) * 0.6 + sin(t * 2.3) * 0.4,
        cos(t * 1.3 + 1.0) * 0.6 + cos(t * 1.9) * 0.4
    ) * convergenceAmount * px;

    vec2 bOffset = vec2(
        sin(t * 1.4 + 2.0) * 0.6 + sin(t * 2.1) * 0.4,
        cos(t * 1.2 + 3.0) * 0.6 + cos(t * 2.5) * 0.4
    ) * convergenceAmount * px;

    return vec3(
        texture(iChannel0, uv + rOffset).r,
        texture(iChannel0, uv).g,
        texture(iChannel0, uv + bOffset).b
    );
}

float scanlineEnergy(vec2 fragCoord, float time)
{
    float y = fragCoord.y;
    float energy = 1.0
        + sin(y * 0.01 + time * 0.5) * scanEnergyVar * 0.5
        + sin(y * 0.037 + time * 0.23) * scanEnergyVar * 0.3
        + sin(y * 0.071 + time * 0.11) * scanEnergyVar * 0.2;
    return clamp(energy, 1.0 - scanEnergyVar, 1.0 + scanEnergyVar);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;

    // CRT warp
    if (ENABLE_WARP) {
        vec2 dc = abs(0.5 - uv);
        dc *= dc;
        uv.x -= 0.5; uv.x *= 1.0 + (dc.y * (0.3 * warp)); uv.x += 0.5;
        uv.y -= 0.5; uv.y *= 1.0 + (dc.x * (0.4 * warp)); uv.y += 0.5;
    }

    // sample
    vec3 color = ENABLE_CONVERGENCE
        ? sampleConvergence(uv, iTime)
        : texture(iChannel0, uv).rgb;

    // static scanlines with energy variation
    if (ENABLE_STATIC_SCANLINES) {
        float scanMask = abs(sin(fragCoord.y * 0.5) * 0.25 * scan);
        if (ENABLE_SCANLINE_ENERGY) {
            scanMask *= scanlineEnergy(fragCoord, iTime);
        }
        color = mix(color, vec3(0.0), scanMask);
    }

    // glow with pulsation
    if (ENABLE_GLOW) {
        float pulse = 1.0 - glowPulseDepth * (0.5 + 0.5 * sin(iTime * glowPulseSpeed * 6.2832));
        color += sampleGlow(uv) * glowStrength * pulse;
    }

    // moving scanline
    if (ENABLE_MOVING_SCANLINE) {
        color += color * movingScanline(uv.y, iTime) * scanIntensity;
    }

    // vignette
    if (ENABLE_VIGNETTE) {
        color *= vignette(uv);
    }

    // black crush: gamma then floor subtract
    color = pow(max(color, 0.0), vec3(blackGamma));
    color = max(color - blackLevel, 0.0) / (1.0 - blackLevel);

    fragColor = vec4(color, 1.0);
}
