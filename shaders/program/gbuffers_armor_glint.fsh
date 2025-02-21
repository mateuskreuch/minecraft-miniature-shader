#define gbuffers_armor_glint

uniform sampler2D texture;

varying vec2 texUV;

void main() {
   gl_FragData[0] = texture2D(texture, texUV);
}
