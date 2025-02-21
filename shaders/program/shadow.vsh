varying vec2 texUV;
varying float alpha;

#include "/common/getShadowDistortion.glsl"

void main() {
   gl_Position = ftransform();
   gl_Position.xyz = getShadowDistortion(gl_Position.xyz);

   texUV = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
   alpha = gl_Color.a;
}