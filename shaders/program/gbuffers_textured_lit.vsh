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
varying vec3 lightColor;
varying vec4 color;
varying float fogMix;
varying float diffuse;
varying float torchLight;

#include "/common/math.glsl"
#include "/common/transformations.vsh"

void main() {
   gl_Position = ftransform();

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;

   torchLight = 1.1*rescale(lightUV.s, TORCH_UV_SCALE.x, TORCH_UV_SCALE.y);
   torchLight *= torchLight;
   
   worldPos = getWorldPosition();

   #include "/common/fog.vsh"

   #ifdef OVERWORLD
   #include "/common/shadow.vsh"
   #endif
}