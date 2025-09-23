#define gbuffers_clouds

#include "/shader.h"

varying float fogMix;
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
	normalizedViewPos = normalize(viewPos);
}