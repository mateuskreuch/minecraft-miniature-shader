#version 120

attribute vec4 mc_Entity;

varying vec4 color;

void main() {
    gl_Position = gl_ProjectionMatrix * (gl_ModelViewMatrix * gl_Vertex);
    color       = gl_Color;

    color.a = 1.0 - float(mc_Entity.x == 10020.0);
}