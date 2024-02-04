#define gbuffers_textured_lit

#include "/shader.h"

attribute vec4 mc_Entity;

uniform int fogShape;
uniform int worldTime;
uniform int isEyeInWater;
uniform mat4 gbufferModelViewInverse;
uniform float fogEnd;
uniform float fogStart;
uniform float rainStrength;
uniform sampler2D lightmap;

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

#ifdef HIGHLIGHT_WAXED
   uniform int heldItemId;
   uniform int heldItemId2;
#endif

#ifdef OVERWORLD
   uniform vec3 shadowLightPosition;

   varying vec3 sunColor;
   varying float diffuse;
#endif

#include "/common/math.glsl"

void main() {
   gl_Position = ftransform();

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   ambient = texture2DLod(lightmap, vec2(AMBIENT_UV.s, lightUV.t), 1);

   #ifdef GLOWING_ORES

      isOre = float(mc_Entity.x == 10014.0);

   #endif

   #ifdef HIGHLIGHT_WAXED

      if ((heldItemId == 10041 || heldItemId2 == 10041) && mc_Entity.x == 10041.0) {
         color.rgb *= 0.4;
      }
   
   #endif

   #include "/common/getTorchStrength.vsh"
   #include "/common/getWorldPosition.vsh"
   #include "/common/getFogMix.vsh"

   #ifdef OVERWORLD
      #include "/common/getDiffuse.vsh"
      #include "/common/getSunColor.vsh"
   #endif
}