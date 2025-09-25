varying vec2 texUV;
varying vec4 color;

void main() {
   gl_Position = ftransform();

	texUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
   color = gl_Color;
}
