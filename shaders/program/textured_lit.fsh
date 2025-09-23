#define gbuffers_textured_lit

#include "/shader.h"

uniform int entityId;
uniform ivec2 eyeBrightnessSmooth;
uniform sampler2D texture;
uniform vec4 entityColor;

varying float fogMix;
varying float isLava;
varying float torchStrength;
varying vec2 lightUV;
varying vec2 texUV;
varying vec3 feetPos;
varying vec3 gradientFogColor;
varying vec4 ambient;
varying vec4 color;

#ifdef ENABLE_BLOCK_REFLECTIONS
   varying float reflectionMaxLuma;
   varying float reflectionMinLuma;
   varying float reflectivity;
   varying vec4 normal;
#endif

#ifdef GLOWING_ORES
   varying float isOre;
#endif

#ifdef HAND_DYNAMIC_LIGHTING
   uniform int heldBlockLightValue;
#endif

#include "/common/math.glsl"
#include "/common/getTorchColor.fsh"

#ifdef ENABLE_SHADOWS
   uniform mat4 shadowModelView;
   uniform mat4 shadowProjection;
   uniform sampler2D shadowtex1;

   varying vec3 lightColor;
   varying float diffuse;

   #include "/common/transformations.glsl"
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

   albedo.rgb *= color.rgb;
   // render thunder
   albedo.a = entityId == 11000.0 ? 0.15 : albedo.a;
   // render entity color changes (e.g taking damage)
   albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

   float albedoLuma = luma(albedo.rgb);

   #ifdef ENABLE_SHADOWS

      float lightStrength = max(0.75*isLava, getLightStrength(feetPos));
      vec3 shadowColor = vec3(1.0 - SHADOW_DARKNESS);
      shadowColor.g += 0.3333*SHADOW_BLUENESS;
      shadowColor.b += SHADOW_BLUENESS;

      ambient.rgb = mix(
         ambient.rgb * shadowColor,
         ambient.rgb,
         lightStrength
      );

      float lightBrightness = max(0.0, LIGHT_BRIGHTNESS - 0.5*pow3(albedoLuma));

      ambient.rgb *= 0.75 + (lightBrightness * lightStrength) * lightColor;

   #endif

   ambient.rgb += getTorchColor(ambient.rgb, feetPos);

   albedo *= color.a;
   albedo *= ambient;

   albedo.rgb = mix(albedo.rgb, gradientFogColor, fogMix);

   /* DRAWBUFFERS:06 */
   gl_FragData[0] = albedo;

   #ifdef ENABLE_BLOCK_REFLECTIONS
      float finalReflectivity = rescale(albedoLuma, reflectionMinLuma, reflectionMaxLuma);

      finalReflectivity *= finalReflectivity * reflectivity;

      gl_FragData[1] = vec4(sphericalEncode(normal.xyz), finalReflectivity * step(fogMix, 0.999), 1.0);
   #else
      gl_FragData[1] = vec4(vec3(0.0), 1.0);
   #endif
}