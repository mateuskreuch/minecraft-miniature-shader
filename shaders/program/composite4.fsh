#include "/shader.h"

uniform sampler2D colortex11;
varying vec2 texUV;

#include "/common/bloomDownsample.glsl"

void main() {
   vec3 color = downsample(colortex11, texUV, 3);

   /* RENDERTARGETS: 12 */
   gl_FragData[0] = vec4(color, 1.0);
}