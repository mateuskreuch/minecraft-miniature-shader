#define gbuffers_textured_lit

#include "/shader.h"

attribute vec4 mc_Entity;

uniform int isEyeInWater;
uniform mat4 gbufferModelViewInverse;
uniform float fogEnd;
uniform float fogStart;

varying vec2 texUV;
varying vec2 lightUV;
varying vec4 color;
varying float fogMix;
varying float torchLight;

#include "/common/math.glsl"
#include "/common/transformations.vsh"

void main() {
   gl_Position = ftransform();

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;

   torchLight = rescale(lightUV.s, TORCH_UV_SCALE.x, TORCH_UV_SCALE.y)
              * 0.9166*CONTRAST;

   torchLight *= torchLight;
   
   vec3 worldPos = getWorldPosition();

   #include "/common/fog.vsh"
}