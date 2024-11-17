#define gbuffers_skybasic

#include "/shader.h"

uniform float fogEnd;
uniform float fogStart;
uniform int fogShape;
uniform mat4 gbufferModelViewInverse;

varying float fogMix;
varying vec4 color;

#include "/common/math.glsl"
#include "/common/getWorldPosition.vsh"
#include "/common/getFogMix.vsh"

void main() {
	gl_Position = ftransform();

	color = gl_Color;
	fogMix = 2.75*getFogMix(getWorldPosition());
}
