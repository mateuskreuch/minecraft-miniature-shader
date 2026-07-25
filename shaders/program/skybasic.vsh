#define GBUFFERS_SKYBASIC

#include "/shader.h"

uniform int isEyeInWater;

varying float fogMix;
varying vec4 color;

#include "/common/math.glsl"
#include "/common/getFogMix.vsh"

void main() {
   gl_Position = ftransform();

   fogMix = getFogMix(vec3(9999999999.0));
   color = gl_Color;
}
