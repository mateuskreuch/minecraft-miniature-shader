#define gbuffers_water

#include "/shader.h"

uniform vec3 fogColor;
uniform sampler2D texture;

varying vec2 texUV;
varying vec2 lightUV;
varying vec3 worldPos;
varying vec4 color;
varying vec4 normal;
varying vec4 ambient;
varying float fogMix;
varying float isWater;
varying float texStrength;
varying float torchStrength;

#ifdef HAND_DYNAMIC_LIGHTING
   uniform int heldBlockLightValue;
#endif

#include "/common/math.glsl"

void main() {
   vec4 albedo  = texture2D(texture, texUV);
   vec4 ambient = ambient;
   vec4 color   = color;

   if (isWater > 0.9) {
      albedo = vec4(WATER_BRIGHTNESS * max(vec3(1.0), contrast(albedo.rgb, 3.2*texStrength)), 1.0);
      color.ba = min(color.ba, vec2(max(color.r, color.g)*WATER_B, WATER_A));
   }

   vec3 torchColor;
   #include "/common/getTorchColor.fsh"

   ambient.rgb += 0.5*torchColor;

   albedo *= color * ambient;

   albedo.rgb = mix(albedo.rgb, fogColor, fogMix);

   /* DRAWBUFFERS:067 */
   gl_FragData[0] = albedo;
   gl_FragData[1] = normal;
   gl_FragData[2] = vec4(1.0, isWater, 0.0, 1.0);
}