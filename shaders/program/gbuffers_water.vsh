#define gbuffers_water

#include "/shader.h"

attribute vec4 mc_Entity;

uniform float fogEnd;
uniform float fogStart;
uniform float frameTimeCounter;
uniform float near, far;
uniform float rainStrength;
uniform float screenBrightness;
uniform int fogShape;
uniform int isEyeInWater;
uniform int worldTime;
uniform mat4 gbufferModelViewInverse;
uniform sampler2D lightmap;
uniform vec3 cameraPosition;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform vec3 sunPosition;

varying float fogMix;
varying float isWater;
varying float torchStrength;
varying float waterTexStrength;
varying vec2 lightUV;
varying vec2 texUV;
varying vec3 gradientFogColor;
varying vec3 worldPos;
varying vec4 ambient;
varying vec4 color;
varying vec4 normal;

#include "/common/math.glsl"
#include "/common/getFogMix.vsh"
#include "/common/getFogColor.vsh"
#include "/common/getAmbientColor.vsh"
#include "/common/getWorldPosition.vsh"
#include "/common/getTorchStrength.vsh"
#include "/common/getWaterTextureStrength.vsh"
#include "/common/getWaterWave.vsh"

void main() {
   gl_Position = ftransform();

   float sunHeight = (gbufferModelViewInverse * vec4(sunPosition, 1.0)).y;

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   normal  = vec4(gl_Normal, 1.0);
   ambient = getAmbientColor(sunHeight);
   isWater = float(mc_Entity.x == 10008.0);

   torchStrength = getTorchStrength(lightUV.s);
   worldPos = getWorldPosition();
   fogMix = getFogMix(worldPos);
   gradientFogColor = getFogColor(worldPos);

   if (isWater > 0.9) {
      float posRandom = random(floor(worldPos.xz) + floor(cameraPosition.xz));

      #if WATER_WAVE_SIZE > 0

         getWaterWave(normal, posRandom);

      #endif

      waterTexStrength = getWaterTextureStrength(posRandom);
   }

   // scale normal to 0..1
   normal = vec4(0.5 + 0.5*normal.xyz, 1.0);
}