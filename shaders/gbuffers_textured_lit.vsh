#version 120

#include "shader.h"

attribute vec4 mc_Entity;

uniform int isEyeInWater;
uniform int worldTime;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform float fogEnd;
uniform float fogStart;
uniform float rainStrength;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 color;

varying vec3 torchColor;
varying float torchLight;

varying float diffuse;
varying float fogMix;

vec3 getWorldPosition() {
   return mat3(gbufferModelViewInverse)
        * (gl_ModelViewMatrix * gl_Vertex).xyz
        + gbufferModelViewInverse[3].xyz;
}

float calculateFog(float fogDepth) {
   float x = worldTime * NORMALIZE_TIME;

   x = clamp(25.0*(x < MIDNIGHT ? SUNSET - x : x - SUNRISE) + 0.3,
             OVERWORLD_FOG_MIN,
             OVERWORLD_FOG_MAX);

   x = min(x, 1.0 - rainStrength);
   x = isEyeInWater == 0 ? x : 1.0;

   return clamp((fogDepth - x*fogStart) / (fogEnd - x*fogStart), 0.0, 1.0);
}

void main() {
   gl_Position = ftransform();

   color    = gl_Color;
   lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   
   torchLight = pow(lmcoord.s, CONTRAST + 1.5);
   torchColor = (0.5 + CONTRAST) * torchLight * TORCH_COLOR;
   
   #if MC_VERSION >= 11300 && defined(ENABLE_FOG)
   fogMix = calculateFog(length(getWorldPosition().xz));
   #else
   fogMix = 0.0;
   #endif

   bool isThin = gl_Normal.x != 0.0 && abs(abs(gl_Normal.x) - abs(gl_Normal.z)) < 0.01;

   diffuse = 0.5 + 0.5
         //  reduce with fog
           * (1.0 - fogMix)
         //  reduce with rain strength
           * (1.0 - rainStrength)
         //  reduce with sky light
           * 2.0*max(min(1.6*lmcoord.t, 1.0) - 0.5, 0.0)
         //  thin objects have constant diffuse
           * (isThin ? 0.75 : clamp(2.5*dot(normalize(gl_NormalMatrix * gl_Normal),
                                            normalize(shadowLightPosition)), MAX_SHADOW_SUBTRACT, 1.0));
}