#version 120

#define gbuffers_water
#include "/shader.h"

/* DRAWBUFFERS:0245 */

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform vec3 fogColor;

varying vec4 color;
varying vec2 lmcoord;
varying vec4 normal;
varying vec2 texcoord;

varying float texstrength;
varying float absorption;
varying float fogMix;
varying float torchLight;
varying vec3 torchColor;

void main() {
   vec4 albedo  = texture2D(texture, texcoord);
   vec4 ambient = texture2D(lightmap, lmcoord);

   albedo = absorption > 0.99 
      ? vec4(max(3.0*texstrength * (albedo.rgb - 0.5) + 0.5, vec3(1.0)), 1.0)
      * color * WATER_COLOR
      : albedo * color;

   // remove default torch light and apply ours
   ambient.rgb = INV_CONTRAST * max(ambient.g - torchLight, 0.0) + torchColor;

   ambient *= albedo;
   ambient.rgb = mix(ambient.rgb, fogColor, fogMix);
   
   gl_FragData[0] = ambient;
   gl_FragData[1] = normal;
   gl_FragData[2] = albedo;

   // encode lighting interaction (r), sky light (g) and absorption (b)
   // r == 0.0: normal terrain, 0.5: subsurface scattering, 1.0: reflective
   gl_FragData[3] = vec4(1.0, lmcoord.t, max(absorption, fogMix), 1.0);
}