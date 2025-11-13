uniform float viewWidth;
uniform float viewHeight;


vec3 downsample(sampler2D last_mipmap, vec2 uv, int index) {
    vec2 viewSize = vec2(viewWidth, viewHeight);
    float scale = pow(2.0, index);
    vec2 texel = 1.0 / viewSize * scale;
    vec3 sum = vec3(0.0);

    // 3x3 box blur
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 offset = vec2(x, y) * texel;
            sum += texture2D(last_mipmap, uv + offset).rgb;
        }
    }

    return sum / 9.0;
}