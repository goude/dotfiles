// --- tint selection (uncomment one) ---
//const vec3 tint = vec3(1.0, 0.7, 0.3);   // amber
const vec3 tint = vec3(0.3, 1.0, 0.4);   // green
// const vec3 tint = vec3(0.4, 0.7, 1.0);   // blue

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy;
    vec3 color = texture(iChannel0, uv).rgb;

    // convert to luminance, then apply tint
    float luma = dot(color, vec3(0.299, 0.587, 0.114));

    fragColor = vec4(luma * tint, 1.0);
}
