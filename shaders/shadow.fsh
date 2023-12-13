#version 120

varying vec4 color;

void main() {
    if (color.a <= 0.01) discard;

    gl_FragData[0] = vec4(color.rgb, 1.0);
}