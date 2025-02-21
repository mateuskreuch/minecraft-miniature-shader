#define gbuffers_armor_glint

varying vec2 texUV;

void main() {
   gl_Position = ftransform();

   texUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
}
