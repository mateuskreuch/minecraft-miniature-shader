#include "/shader.h"

uniform float screenBrightness;
uniform int entityId;
uniform ivec2 eyeBrightnessSmooth;
uniform sampler2D gtexture;
uniform vec4 entityColor;

flat varying float lightSourceLevel;
varying float fogMix;
varying float torchStrength;
varying vec2 lightUV;
varying vec2 texUV;
varying vec3 feetPos;
varying vec3 gradientFogColor;
varying vec4 ambient;

#ifdef GBUFFERS_TERRAIN
   varying vec4 color;
#else
   flat varying vec4 color;
#endif

#if BLOCK_REFLECTIONS > 0
   flat varying vec3 blockReflectivity;
   varying vec3 normal;
#endif

#ifdef GLOWING_ORES
   flat varying float isOre;
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
   if (fogMix > 0.999) {
      discard;
   }

   vec4 albedo  = texture2D(gtexture, texUV);
   vec4 ambient = ambient;
   vec4 color   = color;
   float ambientOcclusion = 1.0;

   #ifdef GBUFFERS_TERRAIN
      ambientOcclusion = color.a;
      color.a = 1.0;
   #endif

   #ifdef GLOWING_ORES
      ambient.rgb = mix(
         ambient.rgb,
         vec3(1.0, 0.9, 0.9),
         isOre * 0.3333*squaredLength(rescale(albedo.rgb, vec3(0.59), vec3(1.0)))
      );
   #endif

   albedo *= color;

   // render thunder
   albedo.a = entityId == 11000.0 ? 0.15 : albedo.a;
   // render entity color changes (e.g taking damage)
   albedo.rgb = mix(albedo.rgb, entityColor.rgb, entityColor.a);

   float albedoLuma = luma(albedo.rgb);

   #ifdef ENABLE_SHADOWS
      float lightStrength = max(0.75*lightSourceLevel, getLightStrength(feetPos));
      float lightBrightness = max(0.0, LIGHT_BRIGHTNESS - 0.5*pow3(albedoLuma));

      ambient.rgb *= mix(SHADOW_COLOR, vec3(1.0), lightStrength);
      ambient.rgb *= 0.75 + (lightBrightness * lightStrength) * lightColor;
   #endif

   ambient.rgb += getTorchColor(torchStrength, ambient.rgb, feetPos);

   albedo.rgb *= ambientOcclusion;

   albedo *= ambient;

   albedo.rgb = mix(albedo.rgb, gradientFogColor, fogMix);

   /* DRAWBUFFERS:067 */
   gl_FragData[0] = albedo;

   #if BLOCK_REFLECTIONS > 0
      float reflectivity = max(0.0, (albedoLuma - blockReflectivity.y) * blockReflectivity.x * 0.2*BLOCK_REFLECTIONS);

      gl_FragData[1] = vec4(normal, 1.0);
      gl_FragData[2] = vec4(reflectivity, blockReflectivity.z, 0.5, 1.0);
   #else
      gl_FragData[1] = vec4(vec3(0.0), 1.0);
      gl_FragData[2] = vec4(vec3(0.0), 1.0);
   #endif
}