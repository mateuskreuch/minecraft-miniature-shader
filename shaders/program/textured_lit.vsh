#define textured_lit

#include "/shader.h"

attribute vec4 mc_Entity;

uniform float rainStrength;
uniform int isEyeInWater;
uniform int worldTime;
uniform sampler2D lightmap;
uniform vec3 sunPosition;

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

#ifdef HIGHLIGHT_WAXED
   uniform int heldItemId;
   uniform int heldItemId2;
#endif

#include "/common/math.glsl"
#include "/common/transformations.glsl"
#include "/common/getFogMix.vsh"
#include "/common/getFogColor.vsh"
#include "/common/getAmbientColor.vsh"
#include "/common/getViewPosition.vsh"
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

   float sunHeight = view2feet(sunPosition).y;

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   ambient = getAmbientColor(sunHeight);
   isLava  = float(mc_Entity.x == 10068.0);

   #ifdef ENABLE_BLOCK_REFLECTIONS

      normal = vec4(gl_Normal, 1.0);
      reflectivity = 0.0;

      if (mc_Entity.x > 99999.0) {
         reflectivity      = 0.01*floor(mc_Entity.x / 10000.0);           // [aa]bbcc
         reflectionMinLuma = 0.01*floor(mod(mc_Entity.x / 100.0, 100.0)); // aa[bb]cc
         reflectionMaxLuma = 0.01*mod(mc_Entity.x, 100.0);                // aabb[cc]
      }

   #endif

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

      if ((heldItemId == 203070 || heldItemId2 == 203070) && mc_Entity.x == 203070.0) {
         color.rgb *= 0.4;
      }

   #endif

   torchStrength = getTorchStrength(lightUV.s);
   feetPos = view2feet(getViewPosition());
   fogMix = getFogMix(feetPos);
   gradientFogColor = getFogColor(fogMix, feetPos);

   #ifdef ENABLE_SHADOWS
      diffuse = getDiffuse(lightUV.t);
      lightColor = getLightColor(sunHeight);
   #endif
}