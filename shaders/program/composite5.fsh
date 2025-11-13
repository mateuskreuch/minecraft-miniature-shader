#include "/shader.h"

uniform sampler2D colortex12;
varying vec2 texUV;

#include "/common/bloomDownsample.glsl"

void main() {
   vec3 color = downsample(colortex12, texUV, 4);

   /* RENDERTARGETS: 13 */
   gl_FragData[0] = vec4(color, 1.0);
}