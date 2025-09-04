uniform sampler2D texture;

uniform float viewWidth;
uniform float viewHeight;

uniform vec4 entityColor;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

varying vec2 texcoord;
varying vec4 color;

void main() {
	vec4 albedo = texture2D(texture, texcoord) * color;
	
	albedo.rgb = mix(albedo.rgb, entityColor.rgb * color.rgb, entityColor.a);
	
	gl_FragData[0] = albedo;
}