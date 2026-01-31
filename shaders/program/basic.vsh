varying vec2 lightUV;
varying vec2 texUV;
varying vec4 color;

void main() {
   gl_Position = ftransform();

	texUV   = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lightUV = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
   color   = gl_Color;
}
