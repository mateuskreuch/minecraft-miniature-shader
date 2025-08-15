#define final

#include "/shader.h"

uniform int isEyeInWater;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform sampler2D colortex0;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D depthtex0;

varying vec2 texUV;

#include "/common/math.glsl"
#include "/common/transformations.fsh"
#include "/common/getReflectionColor.fsh"

void main() {
   vec4 color = texture2D(colortex0, texUV);
   vec4 normalAndReflectiveness = texture2D(colortex6, texUV);
   float reflectiveness = normalAndReflectiveness.z;

   if (reflectiveness > 0.1) {
      // the normal doesn't come premultiplied by the normal matrix to
      // avoid the modelview transformations when view bobbing is on
      // which causes severe artifacts when moving
      vec3 prenormal = sphericalDecode(normalAndReflectiveness.xy);

      #if WATER_WAVE_SIZE > 0

         if (reflectiveness > WATER_REFLECTIVENESS - 0.01 && abs(prenormal.y) > 0.3333) {
            prenormal.xyz *= 1.0 / prenormal.y;
            prenormal.xz *= 0.01 * WATER_WAVE_SIZE;
         }

      #endif

      float depth          = texture2D(depthtex0, texUV).x;
      vec3 normal          = world2screen(prenormal);
      vec3 fragPos         = uv2screen(texUV, depth);
      vec4 reflectionColor = getReflectionColor(depth, normal, fragPos);
      float fresnel        = 1.0 - dot(normal, -normalize(fragPos));

      color.rgb = mix(
         color.rgb,
         reflectionColor.rgb,
         reflectionColor.a * fresnel * 0.1*REFLECTIONS * (1.0 - color.rgb) * reflectiveness
      );
   }

   gl_FragData[0] = color;
}