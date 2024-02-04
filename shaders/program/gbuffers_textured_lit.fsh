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

#ifdef GLOWING_ORES
   varying float isOre;
#endif

#ifdef HAND_DYNAMIC_LIGHTING
   uniform int heldBlockLightValue;
   uniform int heldBlockLightValue2;
#endif

#ifdef ENABLE_SHADOWS
   uniform vec3 cameraPosition;
   uniform mat4 shadowModelView;
   uniform mat4 shadowProjection;
   uniform mat4 gbufferProjectionInverse;
   uniform sampler2D shadowtex1;

   varying vec3 sunColor;
   varying float diffuse;
#endif

#include "/common/math.glsl"

void main() {
   vec4 albedo  = texture2D(texture, texUV);
   vec4 ambient = ambient;

   #ifdef GLOWING_ORES

      if (isOre > 0.9) {
         ambient.rgb = mix(
            ambient.rgb,
            vec3(1.0),
            invpow2(1.0 - 0.3333*squaredLength(pow(albedo.rgb, vec3(6.0))))
         );
      }

   #endif

   albedo *= color;
   
   #ifdef ENABLE_SHADOWS

      float sunStrength;
      #include "/common/getSunStrength.fsh"
      
      ambient.rgb *= 1.0 - SHADOW_DARKNESS;
      ambient.b *= mix(1.0 + SHADOW_BLUENESS, 1.0, sunStrength);

   #endif

   vec3 torchColor;
   #include "/common/getTorchColor.fsh"

   ambient.rgb += torchColor;

   #ifdef ENABLE_SHADOWS

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