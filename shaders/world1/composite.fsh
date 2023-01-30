#version 120

#define composite
#include "/shader.h"

/* DRAWBUFFERS:36 */

uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D colortex5;

varying vec2 texcoord;

void main() {
   gl_FragData[0] = texture2D(colortex0, texcoord); // color
   gl_FragData[1] = texture2D(colortex2, texcoord); // normal
}