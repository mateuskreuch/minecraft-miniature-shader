#define gbuffers_textured_lit

#include "/shader.h"

uniform int entityId;
uniform vec3 fogColor;
uniform vec4 entityColor;
uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec2 texUV;
varying vec2 lightUV;
varying vec4 color;
varying float fogMix;
varying float torchLight;

void main() {
   vec4 albedo  = texture2D(texture, texUV) * color;
   vec4 ambient = texture2D(lightmap, vec2(AMBIENT_UV.s, lightUV.t));

   ambient.rgb *= INV_CONTRAST;
   ambient.rgb += TORCH_COLOR * max(0.0, torchLight - 0.5*length(ambient.rgb));
   
   // render thunder
   albedo.a = entityId == 11000.0 ? 0.15 : albedo.a;

   // render entity color changes (e.g taking damage)
   albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

   albedo *= ambient;
   
   albedo.rgb = mix(albedo.rgb, fogColor, fogMix);

   gl_FragData[0] = albedo;
}