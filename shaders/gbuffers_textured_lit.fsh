#version 120

#define gbuffers_textured_lit
#include "shader.h"

/* DRAWBUFFERS:0245 */

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform vec4 entityColor;
uniform int entityId;
uniform vec3 fogColor;

varying vec4 color;
varying vec4 normal;
varying vec2 lmcoord;
varying vec2 texcoord;

varying float isThin;
varying float fogMix;
varying float torchLight;
varying vec3 torchColor;

void main() {
   vec4 albedo  = texture2D(texture, texcoord) * color;
   vec4 ambient = texture2D(lightmap, lmcoord);

   // render thunder
   albedo.a = entityId == 11000.0 ? 0.15 : albedo.a;

   // render entity color changes (e.g taking damage)
   albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

   // remove default torch light and apply ours
   ambient.rgb = INV_CONTRAST * max(ambient.g - torchLight, 0.0) + torchColor;
   
   ambient *= albedo;
   ambient.rgb = mix(ambient.rgb, fogColor, fogMix);

   gl_FragData[0] = ambient;
   gl_FragData[1] = normal;
   gl_FragData[2] = albedo;

   // encode lighting interaction (r), sky light (g) and absorption (b)
   // r == 0.0: normal terrain, 0.5: subsurface scattering, 1.0: reflective
   gl_FragData[3] = vec4(isThin, lmcoord.t, fogMix, 1.0);
}