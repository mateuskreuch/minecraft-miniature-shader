#version 120

#define final
#include "shader.h"

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform sampler2D colortex3;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D depthtex0;

varying vec2 texcoord;

vec3 nvec3(vec4 pos) {
   return pos.xyz / pos.w;
}

vec2 screen2uv(vec3 screen) {
   return (0.5*nvec3(gbufferProjection * vec4(screen, 1.0)) + 0.5).st;
}

vec3 uv2screen(vec2 uv, float depth) {
   return nvec3(gbufferProjectionInverse * vec4(2.0*vec3(uv, depth) - 1.0, 1.0));
}

vec3 world2screen(vec3 world) {
   return mat3(gbufferModelView) * world;
}

bool isReflective(vec2 uv) {
   return texture2D(colortex7, uv).y > 0.1;
}

void main() {
   vec4 color = texture2D(colortex3, texcoord);

   #if REFLECTIONS > 0
   if (isReflective(texcoord)) {
      float depth = texture2D(depthtex0, texcoord).x;

      // the normal doesn't come premultiplied by the normal matrix to
      // avoid the modelview transformations when view bobbing is on
      // which causes severe artifacts when moving
      vec3 normal  = world2screen(texture2D(colortex6, texcoord).xyz*2.0 - 1.0);
      vec3 fragPos = uv2screen(texcoord, depth);

      vec4 reflectionColor = vec4(0.0);
      vec3 reflection = normalize(reflect(fragPos, normal));
      vec3 curPos = fragPos + reflection;
      vec3 oldPos = fragPos;

      int j = 0;
      
      for (int _ = 0; _ < MAX_RAYS; _++) {
         vec2 curUV = screen2uv(curPos);

         if (curUV.s < 0.0 || curUV.s > 1.0 || curUV.t < 0.0 || curUV.t > 1.0)
            break;
         
         vec3 sample = uv2screen(curUV, texture2D(depthtex0, curUV).x);
         float dist  = abs(curPos.z - sample.z);
         float len   = dot(reflection, reflection);

         // check if distance between last and current depth is
         // smaller than the current length of the reflection vector
         // the numbers are trial and error to produce less distortion
         if (dist*dist < 2.0*len * exp(0.03*len) && !isReflective(curUV)) {
            j++;

            if (j >= MAX_REFINEMENTS) {
               // fade reflection with vignette
               vec2 vignette = curUV * (1.0 - curUV);

               reflectionColor = vec4(
                  texture2D(colortex3, curUV).rgb,
                  clamp(pow(15.0*vignette.s*vignette.t, 1.5), 0.0, 1.0)
               );
               break;
            }

            curPos = oldPos;
            reflection *= REFINEMENT_MULT;
         }

         reflection *= RAY_MULT;
         oldPos = curPos;
         curPos += reflection;
      }
      
      // also fade reflection with fresnel
      float fresnel = 1.0 - dot(normal, -normalize(fragPos));

      color.rgb = mix(color.rgb, reflectionColor.rgb, reflectionColor.a * fresnel * REFLECTIONS * 0.1);
   }
   #endif

   gl_FragData[0] = color;
}