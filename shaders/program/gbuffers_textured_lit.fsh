#define gbuffers_textured_lit

#include "/shader.h"

uniform int entityId;
uniform sampler2D texture;
uniform vec3 fogColor;
uniform vec4 entityColor;

varying float fogMix;
varying float isLava;
varying float torchStrength;
varying vec2 lightUV;
varying vec2 texUV;
varying vec3 worldPos;
varying vec4 ambient;
varying vec4 color;

#ifdef GLOWING_ORES
   varying float isOre;
#endif

#ifdef HAND_DYNAMIC_LIGHTING
   uniform int heldBlockLightValue;
#endif

#include "/common/math.glsl"
#include "/common/getTorchColor.fsh"

#ifdef ENABLE_SHADOWS
   uniform vec3 cameraPosition;
   uniform mat4 shadowModelView;
   uniform mat4 shadowProjection;
   uniform mat4 gbufferProjectionInverse;
   uniform sampler2D shadowtex1;

   varying vec3 lightColor;
   varying float diffuse;

   #include "/common/getLightStrength.fsh"
#endif

void main() {
   vec4 albedo  = texture2D(texture, texUV);
   vec4 ambient = ambient;

   #ifdef GLOWING_ORES

      ambient.rgb = mix(
         ambient.rgb,
         vec3(1.0, 0.9, 0.9),
         isOre * 0.3333*squaredLength(rescale(albedo.rgb, vec3(0.59), vec3(1.0)))
      );

   #endif

   albedo *= color;

   #ifdef ENABLE_SHADOWS

      float lightStrength = max(0.75*isLava, getLightStrength());
      float blueness = (1.0 - lightStrength) * SHADOW_BLUENESS;

      ambient.rgb *= 1.0 - SHADOW_DARKNESS;
      ambient.g *= 1.0 + 0.3333*blueness;
      ambient.b *= 1.0 + blueness;

      float lightBrightness = max(0.0, LIGHT_BRIGHTNESS - 0.5*pow3(luma(albedo.rgb)));

      ambient.rgb *= 1.0 + (lightBrightness * lightStrength) * lightColor;

   #endif

   ambient.rgb += getTorchColor(ambient.rgb);

   // render thunder
   albedo.a = entityId == 11000.0 ? 0.15 : albedo.a;

   // render entity color changes (e.g taking damage)
   albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

   albedo *= ambient;

   albedo.rgb = mix(albedo.rgb, fogColor, fogMix);

   gl_FragData[0] = albedo;
}