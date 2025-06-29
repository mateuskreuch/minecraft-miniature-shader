#define gbuffers_clouds

#include "/shader.h"

uniform float fogEnd;
uniform float fogStart;
uniform float near, far;
uniform int fogShape;
uniform mat4 gbufferModelViewInverse;

varying float fogMix;
varying vec2 texUV;
varying vec4 color;

#include "/common/math.glsl"
#include "/common/getWorldPosition.vsh"
#include "/common/getFogMix.vsh"

void main() {
	gl_Position = ftransform();

	color = gl_Color;
	texUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;

	fogMix = getFogMix(getWorldPosition());
}