uniform sampler2D texture;

varying vec2 texUV;
varying vec4 color;

void main() {
   gl_FragData[0] = texture2D(texture, texUV) * color;
}
