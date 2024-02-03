#define gbuffers_water

#include "/shader.h"

attribute vec4 mc_Entity;

uniform int fogShape;
uniform int worldTime;
uniform int isEyeInWater;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform float fogEnd;
uniform float fogStart;
uniform float rainStrength;
uniform float frameTimeCounter;
uniform sampler2D lightmap;

varying vec2 texUV;
varying vec2 lightUV;
varying vec3 worldPos;
varying vec4 color;
varying vec4 normal;
varying vec4 ambient;
varying float fogMix;
varying float isWater;
varying float texStrength;
varying float torchStrength;

#include "/common/math.glsl"

void main() {
   gl_Position = ftransform();

   color   = gl_Color;
   texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   isWater = float(mc_Entity.x == 10008.0);
   ambient = texture2DLod(lightmap, vec2(AMBIENT_UV.s, lightUV.t), 1);

   #include "/common/getTorchStrength.vsh"
   #include "/common/getWorldPosition.vsh"
   #include "/common/water.vsh"
   #include "/common/getFogMix.vsh"
}