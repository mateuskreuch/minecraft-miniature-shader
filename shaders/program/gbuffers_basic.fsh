uniform sampler2D gtexture;

varying vec2 texUV;
varying vec4 color;

void main() {
   gl_FragData[0] = texture2D(gtexture, texUV) * color;
}
