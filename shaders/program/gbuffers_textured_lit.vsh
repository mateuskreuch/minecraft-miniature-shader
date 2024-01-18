#define gbuffers_textured_lit

#include "/shader.h"

attribute vec4 mc_Entity;

uniform int isEyeInWater;
uniform int worldTime;
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform float fogEnd;
uniform float fogStart;
uniform float rainStrength;

varying vec2 texUV;
varying vec2 lightUV;
varying vec3 worldPos;
varying vec4 color;
varying float fogMix;
varying float torchStrength;

#ifdef OVERWORLD
   varying float diffuse;
   varying vec3 sunColor;
#endif

#include "/common/math.glsl"

void main() {
   gl_Position = ftransform();

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;

   #include "/common/getTorchStrength.vsh"
   #include "/common/getWorldPosition.vsh"
   #include "/common/fog.vsh"

   #ifdef OVERWORLD
   #include "/common/shadow.vsh"
   #endif
}