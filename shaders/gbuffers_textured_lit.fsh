#version 120

#define gbuffers_textured_lit
#include "shader.h"

/* DRAWBUFFERS:045 */

uniform int entityId;
uniform vec3 fogColor;
uniform vec4 entityColor;
uniform sampler2D lightmap;
uniform sampler2D texture;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 color;

varying vec3 torchColor;
varying float torchLight;

varying float diffuse;
varying float fogMix;

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

   // tint shadows blue based on reflectiveness
   ambient.rg *= (1.0 - SHADOW_BLUENESS);
   albedo.b   *= (1.0 - SHADOW_BLUENESS);

   ambient.rgb = mix(ambient.rgb, fogColor, fogMix);

   gl_FragData[0] = ambient;
   gl_FragData[1] = albedo;
   gl_FragData[2] = vec4(diffuse, 0.0, 0.0, 1.0);
}