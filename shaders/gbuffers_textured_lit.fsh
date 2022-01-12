#version 120

#define gbuffers_textured_lit
#include "shader.h"

/* DRAWBUFFERS:0245 */

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform vec4 entityColor;
uniform int entityId;

varying vec4 color;
varying vec4 normal;
varying vec2 lmcoord;
varying vec2 texcoord;

void main() {
   vec4 albedo  = texture2D(texture, texcoord) * color;
   vec4 ambient = texture2D(lightmap, lmcoord);

   // render thunder
   albedo.a = entityId == 11000.0 ? 0.15 : albedo.a;

   // render entity color changes (e.g taking damage)
   albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

   float torchLight = pow(lmcoord.s, CONTRAST + 1.5);

   // remove default torch light and apply ours
   ambient.rgb = ((1.0/CONTRAST) * max(ambient.g - torchLight, 0.0)
               + (0.5 + CONTRAST) * torchLight * vec3(TORCH_R, TORCH_G, TORCH_B));
   
   gl_FragData[0] = albedo * ambient;
   gl_FragData[1] = normal;
   gl_FragData[2] = albedo;

   // encode specular (r), sky light (g) and absorption (b)
   gl_FragData[3] = vec4(0.0, lmcoord.t, 0.0, 1.0);
}