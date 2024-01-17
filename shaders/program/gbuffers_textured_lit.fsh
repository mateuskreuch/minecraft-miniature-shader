#define gbuffers_textured_lit

#include "/shader.h"

uniform int entityId;
uniform vec3 fogColor;
uniform vec4 entityColor;
uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec2 texUV;
varying vec2 lightUV;
varying vec3 worldPos;
varying vec4 color;
varying float fogMix;
varying float torchLight;

#ifdef HAND_DYNAMIC_LIGHTING
   uniform int heldBlockLightValue;
   uniform int heldBlockLightValue2;
#endif

#ifdef OVERWORLD
   uniform vec3 cameraPosition;
   uniform mat4 shadowModelView;
   uniform mat4 shadowProjection;
   uniform mat4 gbufferProjectionInverse;
   uniform sampler2D shadowtex1;

   varying vec3 lightColor;
   varying float diffuse;

   #include "/common/math.glsl"
   #include "/common/shadow.fsh"
#endif

void main() {
   vec4 albedo  = texture2D(texture, texUV) * color;
   vec4 ambient = texture2D(lightmap, vec2(AMBIENT_UV.s, lightUV.t));
   vec3 torchColor;

   #include "/common/torchLight.fsh"

   #ifdef OVERWORLD
   float diffuse = getShadow();
   
   ambient.rgb *= 1.0 - SHADOW_DARKNESS;
   ambient.b *= mix(1.0 + SHADOW_BLUENESS, 1.0, diffuse);
   #endif

   ambient.rgb += torchColor;

   #ifdef OVERWORLD
   ambient.rgb += SUN_BRIGHTNESS * lightColor * diffuse;
   #endif
   
   // render thunder
   albedo.a = entityId == 11000.0 ? 0.15 : albedo.a;

   // render entity color changes (e.g taking damage)
   albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

   albedo *= ambient;
   
   albedo.rgb = mix(albedo.rgb, fogColor, fogMix);

   gl_FragData[0] = albedo;
}