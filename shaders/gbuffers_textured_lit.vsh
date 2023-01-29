#version 120

#include "shader.h"

attribute vec4 mc_Entity;

uniform mat4 gbufferModelViewInverse;
uniform float fogStart;
uniform float fogEnd;
uniform float rainStrength;
uniform int isEyeInWater;
uniform int worldTime;

varying vec4 color;
varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 normal;

varying float isThin;
varying float fogMix;
varying float torchLight;
varying vec3 torchColor;

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
   
   isThin = mc_Entity.x == 10031.0 ? 0.5 : 0.0;
   fogMix = calculateFog(length(getWorldPosition().xz));
   torchLight = pow(lmcoord.s, CONTRAST + 1.5);
   torchColor = (0.5 + CONTRAST) * torchLight * TORCH_COLOR;

   // scale normal to 0..1
   normal = vec4(0.5 + 0.5*gl_Normal, 1.0);
}