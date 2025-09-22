#define final

#include "/shader.h"

uniform float far;
uniform int isEyeInWater;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform sampler2D colortex0;
uniform sampler2D colortex6;
uniform sampler2D depthtex0;
uniform vec3 cameraPosition;

varying vec2 texUV;

#include "/common/math.glsl"
#include "/common/transformations.fsh"
#include "/common/getReflectionColor.fsh"

void main() {
   vec4 color = texture2D(colortex0, texUV);
   vec4 normalAndReflectivity = texture2D(colortex6, texUV);
   float reflectivity = normalAndReflectivity.z;
   float decodedReflectivity = fract(2.0*reflectivity);

   if (decodedReflectivity > MIN_REFLECTIVITY) {
      // the normal doesn't come premultiplied by the normal matrix to
      // avoid the modelview transformations when view bobbing is on
      // which causes severe artifacts when moving
      vec3 prenormal = sphericalDecode(normalAndReflectivity.xy);

      #if WATER_WAVE_SIZE > 0

         if ((abs(prenormal.x) > 0.0 || abs(prenormal.z) > 0.0) && abs(prenormal.y) > 0.3333) {
            prenormal.xyz *= 1.0 / prenormal.y;
            prenormal.xz *= 0.01 * WATER_WAVE_SIZE;
         }

      #endif

      bool isSmoothReflection = reflectivity > 0.5;
      float depth  = texture2D(depthtex0, texUV).x;
      vec3 normal  = feet2viewBobless(prenormal);
      vec3 viewPos = isSmoothReflection
                   ? uv2view(texUV, depth)
                   : world2view(bandify(uv2world(texUV, depth), REFLECTIONS_PIXEL));

      vec4 reflectionColor = getReflectionColor(depth, normal, viewPos);

      color.rgb = mix(
         color.rgb,
         isSmoothReflection ? reflectionColor.rgb : max(color.rgb, reflectionColor.rgb),
         reflectionColor.a * decodedReflectivity * 0.1*REFLECTIONS
      );
   }

   gl_FragData[0] = color;
}