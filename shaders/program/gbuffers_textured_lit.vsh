#define gbuffers_textured_lit

#include "/shader.h"

attribute vec4 mc_Entity;

uniform float fogEnd;
uniform float fogStart;
uniform float near, far;
uniform float rainStrength;
uniform float screenBrightness;
uniform int fogShape;
uniform int isEyeInWater;
uniform int worldTime;
uniform mat4 gbufferModelViewInverse;
uniform sampler2D lightmap;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform vec3 sunPosition;

varying float fogMix;
varying float isLava;
varying float torchStrength;
varying vec2 lightUV;
varying vec2 texUV;
varying vec3 gradientFogColor;
varying vec3 worldPos;
varying vec4 ambient;
varying vec4 color;

#ifdef GLOWING_ORES
   varying float isOre;
#endif

#ifdef HIGHLIGHT_WAXED
   uniform int heldItemId;
   uniform int heldItemId2;
#endif

#include "/common/math.glsl"
#include "/common/getFogMix.vsh"
#include "/common/getFogColor.vsh"
#include "/common/getAmbientColor.vsh"
#include "/common/getWorldPosition.vsh"
#include "/common/getTorchStrength.vsh"

#ifdef ENABLE_SHADOWS
   uniform vec3 shadowLightPosition;

   varying vec3 lightColor;
   varying float diffuse;

   #include "/common/getDiffuse.vsh"
   #include "/common/getLightColor.vsh"
#endif

void main() {
   gl_Position = ftransform();

   float sunHeight = (gbufferModelViewInverse * vec4(sunPosition, 1.0)).y;

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   ambient = getAmbientColor(sunHeight);
   isLava  = float(mc_Entity.x == 10068.0);

   if (isLava > 0.9) {
      color.rgb = mix(vec3(0.8, 0.5, 0.3), vec3(1.0), rescale(color.rgb, vec3(0.54), vec3(0.9)));
   }

   #ifdef THE_END

      ambient.rgb *= END_AMBIENT + 0.02*(gl_NormalMatrix * gl_Normal).xyz;

   #endif

   #ifdef GLOWING_ORES

      isOre = float(mc_Entity.x == 10014.0);

   #endif

   #ifdef HIGHLIGHT_WAXED

      if ((heldItemId == 10041 || heldItemId2 == 10041) && mc_Entity.x == 10041.0) {
         color.rgb *= 0.4;
      }

   #endif

   torchStrength = getTorchStrength(lightUV.s);
   worldPos = getWorldPosition();
   fogMix = getFogMix(worldPos);
   gradientFogColor = getFogColor(fogMix, worldPos);

   #ifdef ENABLE_SHADOWS
      diffuse = getDiffuse(lightUV.t);
      lightColor = getLightColor(sunHeight);
   #endif
}