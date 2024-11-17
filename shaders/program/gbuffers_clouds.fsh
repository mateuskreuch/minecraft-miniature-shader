#define gbuffers_clouds

#include "/shader.h"

uniform sampler2D texture;

varying float fogMix;
varying vec4 color;

void main() {
   gl_FragData[0] = color;
   gl_FragData[0].a = mix(color.a, 0.0, fogMix);
}
