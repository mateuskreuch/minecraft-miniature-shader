#include "/shader.h"

uniform sampler2D colortex10;
varying vec2 texUV;

#include "/common/bloomDownsample.glsl"

void main() {
   vec3 color = downsample(colortex10, texUV, 2);

   /* RENDERTARGETS: 11 */
   gl_FragData[0] = vec4(color, 1.0);
}