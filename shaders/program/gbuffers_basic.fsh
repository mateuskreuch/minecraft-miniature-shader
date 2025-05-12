#define gbuffers_basic

uniform sampler2D texture;

varying vec2 texUV;

void main() {
   gl_FragData[0] = texture2D(texture, texUV);
}
