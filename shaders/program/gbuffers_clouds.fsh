#define gbuffers_clouds

#include "/shader.h"

uniform sampler2D texture;
uniform vec3 fogColor;

varying float fogMix;
varying vec2 texUV;
varying vec4 color;

void main() {
   vec4 albedo = texture2D(texture, texUV) * color;

   gl_FragData[0] = vec4(mix(albedo.rgb, fogColor, 0.4), mix(0.8*albedo.a, 0.0, fogMix));
}