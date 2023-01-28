#version 120

#define composite
#include "/shader.h"

/* DRAWBUFFERS:367 */

uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D colortex5;

varying vec2 texcoord;

void main() {
   gl_FragData[0] = texture2D(colortex0, texcoord);
   gl_FragData[1] = texture2D(colortex2, texcoord);
   gl_FragData[2] = texture2D(colortex5, texcoord);
}