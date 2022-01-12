#version 120

#define gbuffers_water
#include "/shader.h"

/* DRAWBUFFERS:0245 */

uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec4 color;
varying vec2 lmcoord;
varying vec4 normal;
varying vec2 texcoord;
varying float texstrength;
varying float absorption;

void main() {
   vec4 albedo  = texture2D(texture, texcoord) * color;
   vec4 ambient = texture2D(lightmap, lmcoord);

   albedo = absorption > 0.99 ? vec4(max(1.5*texstrength * albedo.rgb, vec3(1.0)), 1.0) * color * vec4(WATER_R, WATER_G, WATER_B, WATER_A)
                              : albedo * color;
   
   float torchLight = pow(lmcoord.s, CONTRAST + 1.5);

   // remove default torch light and apply ours
   ambient.rgb = ((1.0/CONTRAST) * max(ambient.g - torchLight, 0.0)
               + (0.5 + CONTRAST) * torchLight * vec3(TORCH_R, TORCH_G, TORCH_B));
   
   gl_FragData[0] = albedo * ambient;
   gl_FragData[1] = normal;
   gl_FragData[2] = albedo;

   // encode specular (r), sky light (g) and absorption (b)
   gl_FragData[3] = vec4(1.0, lmcoord.t, absorption, 1.0);
}