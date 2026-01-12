#define GBUFFERS_CLOUDS

#include "/shader.h"

uniform int isEyeInWater;
uniform vec3 sunPosition;

varying float fogMix;
varying float sunClosenessToHorizon;
varying vec2 texUV;
varying vec3 normalizedViewPos;
varying vec4 color;

#include "/common/math.glsl"
#include "/common/transformations.glsl"
#include "/common/getViewPosition.vsh"
#include "/common/getFogMix.vsh"

void main() {
	gl_Position = ftransform();

	vec3 viewPos = getViewPosition();

	color  = gl_Color;
	texUV  = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	fogMix = getFogMix(view2feet(viewPos));
	sunClosenessToHorizon = clamp(1.0 - 0.01*abs(view2feet(sunPosition).y), 0.0, 1.0);
	normalizedViewPos = normalize(viewPos);
}