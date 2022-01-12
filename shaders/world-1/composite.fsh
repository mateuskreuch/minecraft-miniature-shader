#version 120

#define composite
#include "/shader.h"

/* DRAWBUFFERS:367 */

uniform sampler2D colortex0;
uniform sampler2D colortex2;
uniform sampler2D colortex5;
uniform sampler2D depthtex0;
uniform int isEyeInWater;

varying vec2 texcoord;

void main() {
   vec4 color  = texture2D(colortex0, texcoord);
   vec4 normal = texture2D(colortex2, texcoord);
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
      // pass info along
      gl_FragData[2] = info;
   }

   gl_FragData[0] = color;
}