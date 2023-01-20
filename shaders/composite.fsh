#version 120

#define composite
#include "shader.h"

/* DRAWBUFFERS:367 */

uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D depthtex0;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform float rainStrength;
uniform int isEyeInWater;

#ifdef SHADOWS
uniform sampler2D shadow;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;
#endif

varying vec3 lightColor;
varying vec3 lightPos;
varying vec2 texcoord;

vec3 nvec3(vec4 pos) {
   return pos.xyz / pos.w;
}

vec3 screen2world(vec3 screen) {
   return (gbufferModelViewInverse * vec4(screen, 1.0)).xyz;
}

vec3 uv2screen(vec2 uv, float depth) {
   return nvec3(gbufferProjectionInverse * vec4(2.0*vec3(uv, depth) - 1.0, 1.0));
}

float squaredLength(vec3 v) {
   return dot(v, v);
}

void main() {
   vec4 color  = texture2D(colortex0, texcoord);
   vec4 normal = texture2D(colortex2, texcoord);
   vec4 albedo = texture2D(colortex4, texcoord);
   vec4 info   = texture2D(colortex5, texcoord);

   gl_FragData[1] = normal;

   // is in liquid
   if (isEyeInWater > 0) {
      float depth = texture2D(depthtex0, texcoord).x;

      color.rgb = mix(
         color.rgb,
         isEyeInWater == 1 ? gl_Fog.color.rgb * vec3(UNDERWATER_R, UNDERWATER_G, UNDERWATER_B) : gl_Fog.color.rgb,
         isEyeInWater == 1 ? exp(300.0*(depth - 1.0)) : clamp(3.0*depth - 1.9, 0.0, 1.0)
      );
   }
   // has normal, therefore can receive diffuse light
   else if (normal != color) {
      // absorption effect on diffuse strength
      float diffuse = 1.0 - info.b;

      // rain effect on diffuse strength
      diffuse *= max(1.0 - rainStrength, 0.1);

      // reduce diffuse on dark spots
      diffuse *= 2.0*max(info.g - 0.5, 0.0);

      #ifdef SHADOWS
      float depth  = texture2D(depthtex0, texcoord).x;
      vec3 fragPos = uv2screen(texcoord, depth);
      
      // limit shadow render distance to increase performance
      if (squaredLength(fragPos) < SHADOW_MAX_DIST*SHADOW_MAX_DIST) {
         vec3 worldPos     = screen2world(fragPos);
         vec4 shadowScreen = shadowModelView * vec4(worldPos, 1.0);
         vec2 shadowUV     = nvec3(shadowProjection * shadowScreen).st*0.5 + 0.5;

         if (-shadowScreen.z > 0.0 &&
            shadowUV.s > 0.0 && shadowUV.s < 1.0 &&
            shadowUV.t > 0.0 && shadowUV.t < 1.0)
         {
            float shadowFade   = clamp(1.0 - squaredLength(worldPos) / (SHADOW_MAX_DIST*SHADOW_MAX_DIST), 0.0, 1.0);
            float shadowSample = texture2D(shadow, shadowUV).x;
            float shadowDepth  = 256.0*shadowSample;

            diffuse *= 1.0 - shadowFade * clamp(-shadowScreen.z - shadowDepth, 0.0, 1.0);
         }
      }
      #endif

      // re-scale normal back to -1..1
      normal.xyz = normal.xyz*2.0 - 1.0;

      // objects with lower normal alpha are thin and have
      // constant diffuse to simulate subsurface scattering
      diffuse *= normal.a < 1.0 ? normal.a : clamp(2.5*dot(normal.xyz, lightPos), 0.0, 1.0);

      // apply diffuse
      color.rgb += albedo.rgb * CONTRAST * diffuse * lightColor;

      // pass info along
      gl_FragData[2] = info;
   }

   gl_FragData[0] = color;
}