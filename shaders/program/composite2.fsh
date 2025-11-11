#include "/shader.h"

uniform sampler2D colortex3;
uniform float viewWidth;
uniform float viewHeight;

varying vec2 texUV;

void main() {
   #ifdef ENABLE_BLOOM
      vec2 viewSize = vec2(viewWidth, viewHeight);

      vec3 sum = vec3(0.0);
      float weights[64] = float[64](
         0.300, 0.285, 0.271, 0.257, 0.244, 0.232, 0.220, 0.209,
         0.198, 0.188, 0.178, 0.169, 0.160, 0.152, 0.145, 0.138,
         0.131, 0.125, 0.119, 0.113, 0.108, 0.103, 0.098, 0.093,
         0.089, 0.085, 0.081, 0.077, 0.074, 0.070, 0.067, 0.064,
         0.061, 0.058, 0.055, 0.053, 0.050, 0.048, 0.046, 0.044,
         0.042, 0.040, 0.038, 0.037, 0.035, 0.034, 0.032, 0.031,
         0.030, 0.029, 0.027, 0.026, 0.025, 0.024, 0.023, 0.022,
         0.021, 0.021, 0.020, 0.020, 0.019, 0.018, 0.018, 0.017
      );
      for (int i = -63; i <= 63; ++i)
         sum += texture2D(colortex3, texUV + vec2(i, 0.0) / viewSize).rgb * weights[abs(i)];
   #else
      vec3 sum = vec3(0.0);
   #endif

   /* RENDERTARGETS: 4 */
   gl_FragData[0] = vec4(sum*BLOOM_INTENSITY, 1.0);
}