#version 120

varying vec2 texcoord;
varying vec4 color;
varying float lmcoord;

void main() {
   gl_Position = ftransform();

   color    = gl_Color;
   lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).s;
   texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
}
