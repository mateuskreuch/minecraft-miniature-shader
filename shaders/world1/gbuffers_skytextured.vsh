#version 120

#define THE_END

#include "/shader.h"

uniform mat4 gbufferModelViewInverse;

varying vec2 texUV;
varying vec4 color;
varying vec3 worldPos;

#include "/common/getWorldPosition.vsh"

void main() {
   gl_Position = ftransform();

   color = gl_Color;
   texUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

   worldPos = getWorldPosition();
   worldPos.y += END_STARS_FLOOR;
}
