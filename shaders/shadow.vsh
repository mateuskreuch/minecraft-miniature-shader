#version 120

varying vec2 texUV;
varying float alpha;

void main() {
    gl_Position = gl_ProjectionMatrix * (gl_ModelViewMatrix * gl_Vertex);
    texUV       = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
    alpha       = gl_Color.a;
}