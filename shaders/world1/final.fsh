#version 120

#define final
#include "/shader.h"

uniform sampler2D colortex3;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D depthtex0;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;

varying vec2 texcoord;

vec3 nvec3(vec4 pos) {
   return pos.xyz / pos.w;
}

// vec3 screen2world(vec3 screen) {
//    return (gbufferModelViewInverse * vec4(screen, 1.0)).xyz;
// }

vec3 screen2uv(vec3 screen) {
   return 0.5*nvec3(gbufferProjection * vec4(screen, 1.0)) + 0.5;
}

vec3 uv2screen(vec2 uv, float depth) {
   return nvec3(gbufferProjectionInverse * vec4(2.0*vec3(uv, depth) - 1.0, 1.0));
}

vec3 world2screen(vec3 world) {
   mat4 modelView = gbufferModelView;

   // clear transformations to stabilize conversions
   modelView[3] = vec4(0.0, 0.0, 0.0, 1.0);

   return (modelView * vec4(world, 1.0)).xyz;
}

bool isReflective(vec2 uv) {
   return texture2D(colortex7, uv).x > 0.75;
}

void main() {
   vec4 color = texture2D(colortex3, texcoord);

   #ifdef REFLECTIONS
   if (isReflective(texcoord)) {
      float depth  = texture2D(depthtex0, texcoord).x;

      // the normal doesn't come premultiplied by the normal matrix to
      // avoid the modelview transformations when view bobbing is on
      // which causes severe artifacts when moving
      vec3 normal  = normalize(world2screen(texture2D(colortex6, texcoord).xyz*2.0 - 1.0));
      vec3 fragPos = uv2screen(texcoord, depth);

      vec4 reflectionColor = vec4(0.0);
      vec3 reflection = normalize(reflect(fragPos, normal));
      vec3 curPos = fragPos + reflection;
      vec3 oldPos = fragPos;

      int j = 0;
      
      for (int _ = 0; _ < MAX_RAYS; _++) {
         vec3 curUV = screen2uv(curPos);

         if (curUV.x < 0.0 || curUV.x > 1.0
         ||  curUV.y < 0.0 || curUV.y > 1.0
         ||  curUV.z < 0.0 || curUV.z > 1.0)
            break;
         
         vec3 sample = uv2screen(curUV.st, texture2D(depthtex0, curUV.st).x);
         float dist  = abs(curPos.z - sample.z);
         float len   = dot(reflection, reflection);

         // check if distance between last and current depth is
         // smaller than the current length of the reflection vector
         // the numbers are trial and error to produce less distortion
         if (dist*dist < 2.0*len * exp(0.03*len) && !isReflective(curUV.st)) {
            j++;

            if (j >= MAX_REFINEMENTS) {
               // fade reflection with vignette
               vec2 vignette = curUV.st * (1.0 - curUV.st);

               reflectionColor = vec4(
                  texture2D(colortex3, curUV.st).rgb,
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

      color.rgb = mix(color.rgb, reflectionColor.rgb, reflectionColor.a * fresnel);
   }
   #endif

   gl_FragData[0] = color;
}