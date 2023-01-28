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

bool isThin(vec4 info) {
   return info.x > 0.25 && info.x < 0.75;
}

void main() {
   vec4 color  = texture2D(colortex0, texcoord);
   vec4 normal = texture2D(colortex2, texcoord);
   vec4 albedo = texture2D(colortex4, texcoord);
   vec4 info   = texture2D(colortex5, texcoord);

   gl_FragData[1] = normal;

   // has normal, therefore can receive diffuse light
   if (normal.a > 0.01) {
      // re-scale normal back to -1..1
      normal.xyz = normal.xyz*2.0 - 1.0;

      // absorption effect on diffuse strength
      float diffuse = 1.0 - info.b;

      // rain effect on diffuse strength
      diffuse *= max(1.0 - rainStrength, 0.1);

      // reduce diffuse on dark spots
      diffuse *= 2.0*max(min(1.6*info.g, 1.0) - 0.5, 0.0);

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

      // thin objects have constant diffuse to simulate subsurface scattering
      diffuse *= isThin(info) ? 0.75 : clamp(2.5*dot(normal.xyz, lightPos), 0.0, 1.0);
      #else
      // since there are no shadows, make it so that thin objects have upwards
      // normal, to match ground color
      if (isThin(info)) {
         normal.xyz = vec3(0.0, 1.0, 0.0);
      }

      diffuse *= clamp(2.5*dot(normal.xyz, lightPos), 0.0, 1.0);
      #endif
      
      // tint shadows blue based on absorption
      color.rg *= vec2(0.85 + 0.15*info.b);
      albedo.b *= 0.85 + 0.15*info.b;

      // apply diffuse
      color.rgb += albedo.rgb * CONTRAST * diffuse * lightColor;

      // pass info along
      gl_FragData[2] = info;
   }

   gl_FragData[0] = color;
}