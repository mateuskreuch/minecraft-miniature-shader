#version 120

attribute vec4 mc_Entity;

varying vec4 color;
varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 normal;

void main() {
   gl_Position = ftransform();

   color    = gl_Color;
   lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).st;
   texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

   // scale normal to 0..1
   // thin materials (like grass) encode that info on normal alpha
   normal = vec4(0.5 + 0.5*gl_Normal, mc_Entity.x == 10031.0 ? 0.75 : 1.0);
}