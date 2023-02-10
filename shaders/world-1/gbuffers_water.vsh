#version 120

#define gbuffers_water
#include "/shader.h"

attribute vec4 mc_Entity;

uniform int isEyeInWater;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform float frameTimeCounter;
uniform float fogEnd;
uniform float fogStart;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 color;
varying vec4 normal;

varying float torchLight;
varying vec3 torchColor;

varying float fogMix;
varying float reflectiveness;
varying float texstrength;

float noise(vec2 pos) {
	return fract(sin(dot(pos, vec2(18.9898, 28.633))) * 4378.5453);
}

vec3 getWorldPosition() {
   return mat3(gbufferModelViewInverse)
        * (gl_ModelViewMatrix * gl_Vertex).xyz
        + gbufferModelViewInverse[3].xyz;
}

float calculateFog(float fogDepth) {
   return clamp((fogDepth - fogStart) / ((isEyeInWater == 0 ? NETHER_FOG : 1.0)*fogEnd - fogStart), 0.0, 1.0);
}

void main() {
   gl_Position = ftransform();

   color    = gl_Color;
   lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

   reflectiveness = mc_Entity.x == 10008.0 ? 1.0 : 0.5;
   torchLight = pow(lmcoord.s, CONTRAST + 1.5);
   torchColor = (0.5 + CONTRAST) * torchLight * TORCH_COLOR;
   normal.xyz = gl_Normal;

   vec3 worldPos  = getWorldPosition();
   vec2 waterPos  = floor(worldPos.xz) + floor(cameraPosition.xz);
   float posNoise = noise(waterPos);

   #if WATER_WAVE_SIZE > 0
      if (mc_Entity.x == 10008.0) {
         normal.xyz += vec3(
            0.01*WATER_WAVE_SIZE*sin(posNoise * frameTimeCounter),
            0.0,
            0.01*WATER_WAVE_SIZE*cos(posNoise * frameTimeCounter)
         );
      }
   #endif

   #if WATER_MIN_TEXTURE >= 0
      texstrength = 2.0*max(posNoise - 0.5, 0.05*WATER_MIN_TEXTURE);
   #else
      texstrength = 0.0;
   #endif

   // scale normal to 0..1
   normal = vec4(0.5 + 0.5*normal.xyz, 1.0);

   // if the water is pointing directly up there's just some texture
   texstrength = gl_Normal.x == 0.0 && gl_Normal.z == 0.0 ? texstrength : 1.0;

   #if MC_VERSION >= 11300 && defined(ENABLE_FOG)
   fogMix = calculateFog(length(worldPos));
   #else
   fogMix = 0.0;
   texstrength = 0.0;
   #endif
}