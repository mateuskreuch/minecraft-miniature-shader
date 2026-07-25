#define GBUFFERS_SKYBASIC

#include "/shader.h"

uniform float viewHeight;
uniform float viewWidth;
uniform vec3 fogColor;

varying float fogMix;
varying vec4 color;

#include "/common/math.glsl"
#include "/common/transformations.glsl"

void main() {
	vec4 color = color;

	vec2 uv = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
	vec3 screenPos = normalize(screen2view(uv, 1.0));
	float upDot = dot(screenPos, gbufferModelView[1].xyz);

	color.rgb = mix(color.rgb, fogColor, max(fogMix, fogify(max(upDot, 0.0), 0.05)));

   gl_FragData[0] = color;
}
