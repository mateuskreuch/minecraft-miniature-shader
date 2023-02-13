#define gbuffers_water

#include "/shader.h"

attribute vec4 mc_Entity;

uniform int worldTime;
uniform int isEyeInWater;
uniform vec3 cameraPosition;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform float fogEnd;
uniform float fogStart;
uniform float rainStrength;
uniform float frameTimeCounter;

varying vec2 lightUV;
varying vec2 texUV;
varying vec4 color;
varying vec4 normal;

varying float fogMix;
varying float isWater;
varying float texstrength;

#include "/common/math.glsl"
#include "/common/transformations.vsh"

void main() {
   gl_Position = ftransform();

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   isWater = mc_Entity.x == 10008.0 ? 1.0 : 0.0;

   // simulate light passthrough property of translucents
   lightUV.s = mix(AMBIENT_UV.s, lightUV.s, 0.7);

   vec3 worldPos = getWorldPosition();
   
   #include "/common/water.vsh"
   #include "/common/fog.vsh"
}