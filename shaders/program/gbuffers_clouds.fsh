#define gbuffers_clouds

#include "/shader.h"

uniform sampler2D texture;
uniform vec3 fogColor;

varying float fogMix;
varying vec4 color;

void main() {
   gl_FragData[0] = vec4(mix(color.rgb, fogColor, 0.4), mix(0.8*color.a, 0.0, fogMix));
}