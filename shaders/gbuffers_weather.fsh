#version 120

uniform sampler2D texture;

varying vec2 texcoord;
varying vec4 color;
varying float lmcoord;

void main() {
	vec4 albedo = texture2D(texture, texcoord) * color;

	albedo.a *= 0.25;
	
	gl_FragData[0] = albedo;
}
