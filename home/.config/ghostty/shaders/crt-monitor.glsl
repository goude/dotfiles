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

const float brightness = 1.0;
const float contrast   = 1.0;

const float glowStrength = 0.25;
const float glowRadius   = 2.0;

const float scanDuration = 2.5;
const float scanWidth = 0.02;
const float afterglowLength = 0.15;
const float scanIntensity = 0.3;
const float minInterval = 45.0;
const float maxInterval = 75.0;

const float vignetteStrength = 0.3;  // 0 = none, 1 = strong darkening at edges
const float vignetteSoftness = 0.4;  // how gradual the falloff is

const float convergenceAmount = 0.8;   // max pixel offset for RGB
const float convergenceDrift = 0.05;   // speed of slow drift (0 = static)
// --------------------------------

vec3 applyBrightnessContrast(vec3 c, float b, float k)
{
    c = (c - 0.5) * k + 0.5;
    return c * b;
}

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
    // first scan starts immediately (cycle 0 has no wait)
    float cycleStart = 0.0;
    float cycleIndex = 0.0;
    
    // first cycle: scanline runs immediately
    if (time <= scanDuration) {
        float scanPos = time / scanDuration;
        float screenY = 1.0 - y;
        float dist = screenY - scanPos;
        float line = smoothstep(scanWidth, 0.0, abs(dist));
        float glow = smoothstep(afterglowLength, 0.0, -dist) * step(dist, 0.0);
        return line + glow * 0.5;
    }
    
    // after first scan, start counting intervals
    cycleStart = scanDuration;
    
    for (int i = 0; i < 100; i++) {
        float interval = mix(minInterval, maxInterval, hash(cycleIndex));
        if (cycleStart + interval > time) {
            // we're in the waiting period
            return 0.0;
        }
        cycleStart += interval;
        
        // check if we're in the scan portion
        if (time <= cycleStart + scanDuration) {
            float timeInScan = time - cycleStart;
            float scanPos = timeInScan / scanDuration;
            float screenY = 1.0 - y;
            float dist = screenY - scanPos;
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
    
    // slow drifting offsets for each channel
    float t = time * convergenceDrift;
    vec2 rOffset = vec2(
        sin(t * 1.1 + 0.0) * 0.6 + sin(t * 2.3) * 0.4,
        cos(t * 1.3 + 1.0) * 0.6 + cos(t * 1.9) * 0.4
    ) * convergenceAmount * px;
    
    vec2 gOffset = vec2(0.0); // green stays centered (reference)
    
    vec2 bOffset = vec2(
        sin(t * 1.4 + 2.0) * 0.6 + sin(t * 2.1) * 0.4,
        cos(t * 1.2 + 3.0) * 0.6 + cos(t * 2.5) * 0.4
    ) * convergenceAmount * px;
    
    vec3 color;
    color.r = texture(iChannel0, uv + rOffset).r;
    color.g = texture(iChannel0, uv + gOffset).g;
    color.b = texture(iChannel0, uv + bOffset).b;
    
    return color;
}

float scanlineEnergy(vec2 fragCoord, float time)
{
    // variation based on position and slow time drift
    float y = fragCoord.y;
    float energy = 1.0;
    
    // slow wave patterns simulating inconsistent beam energy
    energy += sin(y * 0.01 + time * 0.5) * scanEnergyVar * 0.5;
    energy += sin(y * 0.037 + time * 0.23) * scanEnergyVar * 0.3;
    energy += sin(y * 0.071 + time * 0.11) * scanEnergyVar * 0.2;
    
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
    
    // sample with convergence error or plain
    vec3 color;
    if (ENABLE_CONVERGENCE) {
        color = sampleConvergence(uv, iTime);
    } else {
        color = texture(iChannel0, uv).rgb;
    }
    
    // static scanlines with energy variation
    if (ENABLE_STATIC_SCANLINES) {
        float scanMask = abs(sin(fragCoord.y * 0.5) * 0.25 * scan);
        if (ENABLE_SCANLINE_ENERGY) {
            scanMask *= scanlineEnergy(fragCoord, iTime);
        }
        color = mix(color, vec3(0.0), scanMask);
    }
    
    // glow
    if (ENABLE_GLOW) {
        vec3 glow = sampleGlow(uv);
        color += glow * glowStrength;
    }
    
    // moving scanline
    if (ENABLE_MOVING_SCANLINE) {
        float movingScan = movingScanline(uv.y, iTime);
        color += color * movingScan * scanIntensity;
    }
    
    // vignette
    if (ENABLE_VIGNETTE) {
        color *= vignette(uv);
    }
    
    // brightness / contrast
    color = applyBrightnessContrast(color, brightness, contrast);
    
    fragColor = vec4(color, 1.0);
}