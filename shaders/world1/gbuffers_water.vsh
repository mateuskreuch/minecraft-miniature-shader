#version 120

#define gbuffers_water
#include "/shader.h"

attribute vec4 mc_Entity;

const float TAU = 1.57079632;

uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform float fogStart;
uniform float fogEnd;

varying vec4 color;
varying vec2 lmcoord;
varying vec4 normal;
varying vec2 texcoord;
varying float texstrength;
varying float absorption;
varying float fogMix;

float noise(vec2 pos) {
	return 2.0*max(fract(sin(dot(pos, vec2(18.9898, 28.633))) * 4378.5453) - 0.5, 0.0);
}

vec3 getWorldPosition() {
   return mat3(gbufferModelViewInverse)
        * (gl_ModelViewMatrix * gl_Vertex).xyz
        + gbufferModelViewInverse[3].xyz;
}

float calculateFog(float fogDepth) {
   return clamp((fogDepth - fogStart) / (fogEnd - fogStart), 0.0, 1.0);
}

void main() {
   gl_Position = ftransform();

   color      = gl_Color;
   lmcoord    = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   texcoord   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   absorption = mc_Entity.x == 10008.0 ? 1.0 : 0.5;

   vec3 worldPos = getWorldPosition();
   vec3 absoluteWorldPos = worldPos + floor(cameraPosition);

   #ifdef WATER_SHOW_SOME_TEXTURE
   texstrength = max(noise(floor(absoluteWorldPos.xz)), 0.4);
   #else
   texstrength = 0.0;
   #endif

   fogMix = calculateFog(length(worldPos));

   // scale normal to 0..1
   normal = vec4(0.5 + 0.5*gl_Normal, 1.0);

   // if the water is pointing directly up there's just some texture
   texstrength = gl_Normal.x == 0.0 && gl_Normal.z == 0.0 ? texstrength : 1.0;
}