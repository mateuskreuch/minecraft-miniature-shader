#include "/shader.h"

attribute vec4 mc_Entity;

uniform float rainStrength;
uniform float screenBrightness;
uniform int isEyeInWater;
uniform int worldTime;
uniform sampler2D lightmap;
uniform vec3 sunPosition;

flat varying float isLava;
varying float fogMix;
varying float torchStrength;
varying vec2 lightUV;
varying vec2 texUV;
varying vec3 feetPos;
varying vec3 gradientFogColor;
varying vec4 ambient;
varying vec4 color;

#ifdef ENABLE_BLOCK_REFLECTIONS
   flat varying vec3 blockReflectivity;
   varying vec3 normal;

   #include "/common/blockReflectivity.glsl"
#endif

#ifdef GLOWING_ORES
   flat varying float isOre;
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

      normal = ndc2screen(gl_Normal);
      blockReflectivity = BLOCK_REFLECTIVITY[int(max(0.0, mc_Entity.x - 20000.0))];

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

      color.rgb *= (heldItemId == 20008 || heldItemId2 == 20008) && mc_Entity.x == 20008.0 ? 0.4 : 1.0;

   #endif

   torchStrength = getTorchStrength(lightUV.s);
   feetPos = view2feet(getViewPosition());
   fogMix = getFogMix(feetPos);
   gradientFogColor = getFogColor(fogMix, feetPos);

   #ifdef ENABLE_SHADOWS
      float skyLight = clamp(lightUV.t, 0.0, 1.0);

      diffuse = getDiffuse(skyLight);
      lightColor = getLightColor(sunHeight, skyLight);
   #endif
}