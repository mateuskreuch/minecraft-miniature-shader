#include "/shader.h"

uniform sampler2D colortex0;

varying vec2 texUV;

#include "/common/math.glsl"

void main() {
   #ifdef ENABLE_BLOOM
      vec4 color = texture2D(colortex0, texUV);
      float luminance = luma(color.rgb) * 0.5 + 0.5;
      vec3 bright = color.rgb * max(luminance - BLOOM_THRESHOLD, 0.0);
   #else
      vec3 bright = vec3(0.0);
   #endif

   /* RENDERTARGETS: 3 */
   gl_FragData[0] = vec4(bright, 1.0);
}