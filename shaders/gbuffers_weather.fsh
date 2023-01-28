#version 120

uniform sampler2D texture;

varying vec4 color;
varying vec2 texcoord;
varying float lmcoord;

void main() {
	vec4 albedo = texture2D(texture, texcoord) * color;

	albedo.a *= 0.25;
	
	gl_FragData[0] = albedo;
}
