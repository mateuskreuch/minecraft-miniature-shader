#version 120

#define gbuffers_water
#include "/shader.h"

/* DRAWBUFFERS:025 */

uniform vec3 fogColor;
uniform sampler2D lightmap;
uniform sampler2D texture;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 color;
varying vec4 normal;

varying float torchLight;
varying vec3 torchColor;

varying float fogMix;
varying float reflectiveness;
varying float texstrength;

void main() {
   vec4 albedo  = texture2D(texture, texcoord);
   vec4 ambient = texture2D(lightmap, lmcoord);

   albedo = reflectiveness > 0.99 
      ? vec4(max(3.2*texstrength * (albedo.rgb - 0.5) + 0.5, vec3(1.0)), 1.0)
      * color * WATER_COLOR
      : albedo * color;

   // remove default torch light and apply ours
   ambient.rgb = INV_CONTRAST * max(ambient.g - torchLight, 0.0) + torchColor;

   ambient *= albedo;
   ambient.rgb = mix(ambient.rgb, fogColor, fogMix);
   
   gl_FragData[0] = ambient;
   gl_FragData[1] = normal;
   gl_FragData[2] = vec4(0.0, reflectiveness, 0.0, 1.0);
}