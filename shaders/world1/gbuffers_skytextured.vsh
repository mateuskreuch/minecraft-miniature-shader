#version 120

#include "/shader.h"

uniform mat4 gbufferModelViewInverse;

varying vec2 texUV;
varying vec4 color;
varying vec3 worldPos;

void main() {
   gl_Position = ftransform();
   color = gl_Color;
   texUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

   #include "/common/getWorldPosition.vsh"

   worldPos.y += END_STARS_FLOOR;
}
