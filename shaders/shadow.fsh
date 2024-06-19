#version 120

uniform sampler2D texture;

varying vec2 texUV;
varying float alpha;

void main() {
    vec4 albedo = texture2DLod(texture, texUV, 0);

    albedo.a *= alpha;

    gl_FragData[0] = albedo;
}