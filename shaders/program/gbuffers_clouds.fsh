#define gbuffers_clouds

#include "/shader.h"

uniform sampler2D texture;
uniform vec3 fogColor;

varying float fogMix;
varying vec2 texUV;
varying vec4 color;

void main() {
   vec4 albedo = texture2D(texture, texUV) * color;

   albedo.a = mix(albedo.a, 0, fogMix);
   albedo.rgb = mix(albedo.rgb, fogColor, 0.6);

   gl_FragData[0] = albedo;
}