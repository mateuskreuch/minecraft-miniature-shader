#include "/shader.h"

uniform sampler2D colortex5;
varying vec2 texUV;

#include "/common/bloomDownsample.glsl"

void main() {
   vec3 color = downsample(colortex5, texUV, 1);

   /* RENDERTARGETS: 10 */
   gl_FragData[0] = vec4(color, 1.0);
}