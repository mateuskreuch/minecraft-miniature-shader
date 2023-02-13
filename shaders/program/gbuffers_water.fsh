#define gbuffers_water

#include "/shader.h"

uniform vec3 fogColor;
uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec2 texUV;
varying vec2 lightUV;
varying vec4 color;
varying vec4 normal;

varying float fogMix;
varying float isWater;
varying float texstrength;

void main() {
   vec4 albedo  = texture2D(texture, texUV);
   vec4 ambient = texture2D(lightmap, lightUV);

   albedo = isWater < 0.9
      ? albedo * color
      : vec4(WATER_BRIGHTNESS * max(vec3(1.0), 3.2*texstrength * (albedo.rgb - 0.5) + 0.5), 1.0)
      * min(color, vec4(1.0, 1.0, max(color.r, color.g)*WATER_B, WATER_A));

   albedo *= ambient;

   albedo.rgb = mix(albedo.rgb, fogColor, fogMix);
   
   /* DRAWBUFFERS:067 */
   gl_FragData[0] = albedo;
   gl_FragData[1] = normal;
   gl_FragData[2] = vec4(1.0, 0.0, 0.0, 1.0);
}