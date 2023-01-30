#version 120

#include "/shader.h"

attribute vec4 mc_Entity;

uniform int isEyeInWater;
uniform mat4 gbufferModelViewInverse;
uniform float fogEnd;
uniform float fogStart;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 color;

varying vec3 torchColor;
varying float torchLight;

varying float fogMix;

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

   torchLight = pow(lmcoord.s, CONTRAST + 1.5);
   torchColor = (0.5 + CONTRAST) * torchLight * TORCH_COLOR;

   #if MC_VERSION >= 11300
   fogMix = calculateFog(length(getWorldPosition()));
   #endif
}