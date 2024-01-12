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
varying vec3 worldPos;
varying vec4 color;
varying vec4 normal;

varying float fogMix;
varying float isWater;
varying float torchLight;
varying float texStrength;

#include "/common/math.glsl"
#include "/common/transformations.vsh"

void main() {
   gl_Position = ftransform();

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   isWater = float(mc_Entity.x == 10008.0);

   torchLight = 1.1*rescale(lightUV.s, TORCH_UV_SCALE.x, TORCH_UV_SCALE.y);
   torchLight *= torchLight;

   worldPos = getWorldPosition();
   
   #include "/common/water.vsh"
   #include "/common/fog.vsh"
}