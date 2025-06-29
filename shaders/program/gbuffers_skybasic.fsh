#define gbuffers_skybasic

#include "/shader.h"

uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform vec3 fogColor;
uniform vec3 skyColor;

varying float fogMix;
varying vec4 starColor;

#include "/common/math.glsl"
#include "/common/transformations.fsh"

void main() {
	vec3 color;

	if (starColor.a > 0.9) {
		color = starColor.rgb;
	}
	else {
      vec2 uv = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
      vec3 screenPos = normalize(uv2screen(uv, 1.0));
      float upDot = dot(screenPos, gbufferModelView[1].xyz);

		color = mix(skyColor, fogColor, max(fogMix, fogify(max(upDot, 0.0), 0.05)));
	}

   gl_FragData[0] = vec4(color, 1.0);
}
