#version 120

#define composite
#include "shader.h"

/* DRAWBUFFERS:367 */

uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D depthtex0;
uniform sampler2D shadow;

varying vec3 lightColor;
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
   vec4 albedo = texture2D(colortex4, texcoord);
   vec4 info   = texture2D(colortex5, texcoord);

   // has diffuse info
   if (info.a > 0.01 && info != color) {
      float lightStrength = 1.0;
      float depth  = texture2D(depthtex0, texcoord).x;
      vec3 fragPos = uv2screen(texcoord, depth);
      
      // limit shadow render distance to increase performance
      if (squaredLength(fragPos) < SHADOW_MAX_DIST_SQUARED) {
         vec3 worldPos = screen2world(fragPos);

         #if SHADOW_PIXEL > 0
         worldPos = (floor((worldPos + cameraPosition) * SHADOW_PIXEL + 0.01) + 0.5)
                  / SHADOW_PIXEL - cameraPosition;
         #endif

         vec4 shadowScreen = shadowModelView * vec4(worldPos, 1.0);
         vec2 shadowUV     = nvec3(shadowProjection * shadowScreen).st*0.5 + 0.5;

         if (-shadowScreen.z > 0.0 &&
            shadowUV.s > 0.0 && shadowUV.s < 1.0 &&
            shadowUV.t > 0.0 && shadowUV.t < 1.0)
         {
            float shadowFade  = min(1.0 - squaredLength(worldPos) * INV_SHADOW_MAX_DIST_SQUARED, 1.0);
            float shadowDepth = 256.0*texture2D(shadow, shadowUV).x;

            lightStrength = 1.0 - shadowFade * clamp(-shadowScreen.z - shadowDepth, 0.0, 1.0);
         }
      }

      color.rgb += albedo.rgb * mix(vec3(length(lightColor)), lightColor, info.z)
                 * min(info.x*2.0 - 1.0, lightStrength);

      gl_FragData[2] = info;
   }

   gl_FragData[0] = color;
   gl_FragData[1] = texture2D(colortex2, texcoord);
}