#version 120

attribute vec4 mc_Entity;

varying vec2 texUV;
varying vec4 color;

void main() {
    gl_Position = gl_ProjectionMatrix * (gl_ModelViewMatrix * gl_Vertex);
    color       = gl_Color;

    texUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
}