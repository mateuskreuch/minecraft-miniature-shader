#version 120

#define THE_END

#include "/shader.h"

varying vec2 texUV;
varying vec3 feetPos;
varying vec4 color;

#include "/common/transformations.glsl"
#include "/common/getViewPosition.vsh"

void main() {
   gl_Position = ftransform();

   color = gl_Color;
   texUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

   feetPos = view2feet(getViewPosition());
   feetPos.y += END_STARS_FLOOR;
}
