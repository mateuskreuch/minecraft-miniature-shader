#define gbuffers_water

#include "/shader.h"

uniform sampler2D texture;

varying float fogMix;
varying float reflectiveness;
varying float torchStrength;
varying float waterTexStrength;
varying vec2 lightUV;
varying vec2 texUV;
varying vec3 gradientFogColor;
varying vec3 worldPos;
varying vec4 ambient;
varying vec4 color;
varying vec4 normal;

#ifdef HAND_DYNAMIC_LIGHTING
   uniform int heldBlockLightValue;
#endif

#include "/common/math.glsl"
#include "/common/getTorchColor.fsh"

void main() {
   vec4 albedo  = texture2D(texture, texUV);
   vec4 ambient = ambient;
   vec4 color   = color;

   if (reflectiveness > WATER_REFLECTIVENESS - 0.01) {
      #if MC_VERSION >= 11300
         albedo.rgb = vec3(WATER_BRIGHTNESS * max(vec3(1.0), contrast(albedo.rgb, 3.2*waterTexStrength)));

         #define WATER_BUFFER color
      #else
         #define WATER_BUFFER albedo
      #endif

      WATER_BUFFER.ba = min(WATER_BUFFER.ba, vec2(max(WATER_BUFFER.r, WATER_BUFFER.g)*WATER_B, WATER_A));
   }

   ambient.rgb += 0.5*getTorchColor(ambient.rgb);

   albedo *= color * ambient;

   albedo.rgb = mix(albedo.rgb, gradientFogColor, fogMix);

   /* DRAWBUFFERS:06 */
   gl_FragData[0] = albedo;
   gl_FragData[1] = vec4(sphericalEncode(normal.xyz), reflectiveness, 1.0);
}