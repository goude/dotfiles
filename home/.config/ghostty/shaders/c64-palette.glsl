// ============================================================
//  C64 Colodore Quantization Shader for Ghostty
//  Maps all colors to the 16 VIC-II palette colors
//  Optional ordered dithering
// ============================================================


// --- feature toggles ---
const bool ENABLE_C64_PALETTE = true;
const bool ENABLE_DITHER = false;
const bool PERCEPTUAL_DISTANCE = true;  // true = luma-weighted distance


// --- user tweakable settings ---
const float ditherAmount = 2.0;   // 0.0 = none, 1.0 = strong, >1 = aggressive
const float ditherScale  = 3.0;   // 1.0 = pixel sized, 2.0 = 2x2 blocks, etc.
// --------------------------------


// --- Colodore VIC-II palette (normalized RGB) ---
const vec3 C64[16] = vec3[](
    vec3(0.0, 0.0, 0.0),                 // 0  Black
    vec3(1.0, 1.0, 1.0),                 // 1  White
    vec3(0.4078, 0.2157, 0.1686),        // 2  Red
    vec3(0.4392, 0.6431, 0.6980),        // 3  Cyan
    vec3(0.4353, 0.2392, 0.5255),        // 4  Purple
    vec3(0.3451, 0.5529, 0.2627),        // 5  Green
    vec3(0.2078, 0.1569, 0.4745),        // 6  Blue
    vec3(0.7216, 0.7804, 0.4353),        // 7  Yellow
    vec3(0.4353, 0.3098, 0.1451),        // 8  Orange
    vec3(0.2627, 0.2235, 0.0),           // 9  Brown
    vec3(0.6039, 0.4039, 0.3490),        // 10 Light Red
    vec3(0.2667, 0.2667, 0.2667),        // 11 Dark Grey
    vec3(0.4235, 0.4235, 0.4235),        // 12 Grey
    vec3(0.6039, 0.8235, 0.5176),        // 13 Light Green
    vec3(0.4235, 0.3686, 0.7098),        // 14 Light Blue
    vec3(0.5843, 0.5843, 0.5843)         // 15 Light Grey
);


// --- 4x4 Bayer matrix ---
float bayer4(vec2 p)
{
    int x = int(mod(p.x, 4.0));
    int y = int(mod(p.y, 4.0));

    int index = x + y * 4;

    float m[16] = float[](
         0.,  8.,  2., 10.,
        12.,  4., 14.,  6.,
         3., 11.,  1.,  9.,
        15.,  7., 13.,  5.
    );

    return m[index] / 16.0;
}


// --- C64 quantization ---
vec3 quantizeC64(vec3 color, vec2 fragCoord)
{
    // Ordered dithering (before quantization)
    if (ENABLE_DITHER && ditherAmount > 0.0) {
        float threshold = bayer4(floor(fragCoord / ditherScale));
        float centered  = (threshold - 0.5) * 2.0; // -1 → +1
        color += centered * ditherAmount * 0.05;
    }

    float minDist = 1e9;
    vec3 best = C64[0];

    vec3 weight = PERCEPTUAL_DISTANCE
        ? vec3(0.299, 0.587, 0.114)
        : vec3(1.0);

    for (int i = 0; i < 16; i++) {
        vec3 diff = (color - C64[i]) * weight;
        float dist = dot(diff, diff);
        if (dist < minDist) {
            minDist = dist;
            best = C64[i];
        }
    }

    return best;
}


void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    vec3 color = texture(iChannel0, uv).rgb;

    if (ENABLE_C64_PALETTE) {
        color = quantizeC64(color, fragCoord);
    }

    fragColor = vec4(color, 1.0);
}
