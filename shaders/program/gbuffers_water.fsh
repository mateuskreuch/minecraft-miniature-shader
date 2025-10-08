#include "/shader.h"

uniform float screenBrightness;
uniform ivec2 eyeBrightnessSmooth;
uniform sampler2D gtexture;

varying float fogMix;
varying float reflectivity;
varying float torchStrength;
varying float waterTexStrength;
varying vec2 lightUV;
varying vec2 texUV;
varying vec3 feetPos;
varying vec3 gradientFogColor;
varying vec3 normal;
varying vec4 ambient;
varying vec4 color;

#ifdef HAND_DYNAMIC_LIGHTING
   uniform int heldBlockLightValue;
#endif

#include "/common/math.glsl"
#include "/common/getTorchColor.fsh"

void main() {
   vec4 albedo  = texture2D(gtexture, texUV);
   vec4 ambient = ambient;
   vec4 color   = color;

   if (reflectivity > WATER_REFLECTIVITY - 0.01) {
      #if MC_VERSION >= 11300
         albedo.rgb = vec3(WATER_BRIGHTNESS * max(vec3(1.0), contrast(albedo.rgb, 3.2*waterTexStrength)));

         #define WATER_BUFFER color
      #else
         #define WATER_BUFFER albedo
      #endif

      WATER_BUFFER.ba = min(WATER_BUFFER.ba, vec2(max(WATER_BUFFER.r, WATER_BUFFER.g)*WATER_B, WATER_A));
   }

   ambient.rgb += 0.5*getTorchColor(torchStrength, ambient.rgb, feetPos);

   albedo *= color * ambient;

   albedo.rgb = mix(albedo.rgb, gradientFogColor, fogMix);

   /* DRAWBUFFERS:067 */
   gl_FragData[0] = albedo;
   gl_FragData[1] = vec4(normal, 1.0);
   gl_FragData[2] = vec4(reflectivity * step(fogMix, 0.999), 0.0, 1.0, 1.0);
}