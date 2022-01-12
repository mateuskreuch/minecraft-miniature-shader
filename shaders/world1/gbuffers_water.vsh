#version 120

attribute vec4 mc_Entity;

varying vec4 color;
varying vec2 lmcoord;
varying vec4 normal;
varying vec2 texcoord;
varying float texstrength;
varying float absorption;

void main() {
   gl_Position = ftransform();

   color      = gl_Color;
   lmcoord    = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   texcoord   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   absorption = mc_Entity.x == 10008.0 ? 1.0 : 0.5;

   // scale normal to 0..1
   normal = vec4(0.5 + 0.5*gl_Normal, 1.0);

   // if the water is pointing directly up there's no texture
   texstrength = gl_Normal.r == 0.0 && gl_Normal.b == 0.0 ? 0.0 : 1.0;
}