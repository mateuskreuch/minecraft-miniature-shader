#define final

varying vec2 texUV;

void main() {
   gl_Position = ftransform();

   texUV = gl_MultiTexCoord0.st;
}