#define gbuffers_textured_lit

#include "/shader.h"

uniform int entityId;
uniform vec3 fogColor;
uniform vec4 entityColor;
uniform sampler2D texture;

varying vec2 texUV;
varying vec2 lightUV;
varying vec3 worldPos;
varying vec4 color;
varying vec4 ambient;
varying float fogMix;
varying float torchStrength;

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

   varying vec3 sunColor;
   varying float diffuse;

   #include "/common/math.glsl"
#endif

void main() {
   vec4 albedo  = texture2D(texture, texUV) * color;
   vec4 ambient = ambient;
   
   #ifdef OVERWORLD

      float sunStrength;
      #include "/common/getSunStrength.fsh"
      
      ambient.rgb *= 1.0 - SHADOW_DARKNESS;
      ambient.b *= mix(1.0 + SHADOW_BLUENESS, 1.0, sunStrength);

   #endif

   vec3 torchColor;
   #include "/common/getTorchColor.fsh"

   ambient.rgb += torchColor;

   #ifdef OVERWORLD

      ambient.rgb += (SUN_BRIGHTNESS * sunStrength) * sunColor;

   #endif
   
   // render thunder
   albedo.a = entityId == 11000.0 ? 0.15 : albedo.a;

   // render entity color changes (e.g taking damage)
   albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

   albedo *= ambient;
   
   albedo.rgb = mix(albedo.rgb, fogColor, fogMix);

   gl_FragData[0] = albedo;
}