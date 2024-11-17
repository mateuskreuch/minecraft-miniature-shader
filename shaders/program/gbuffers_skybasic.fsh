#define gbuffers_skybasic

#include "/shader.h"

uniform sampler2D texture;
uniform vec3 fogColor;

varying float fogMix;
varying vec4 color;

void main() {
   gl_FragData[0] = color;
   gl_FragData[0].rgb = mix(color.rgb, fogColor, min(1.0, fogMix));
}
