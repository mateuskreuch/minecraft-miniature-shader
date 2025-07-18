#version 120

#define THE_END

#include "/shader.h"

uniform float frameTimeCounter;
uniform sampler2D texture;
uniform vec3 fogColor;

varying vec2 texUV;
varying vec4 color;
varying vec3 worldPos;

void main() {
   vec4 albedo = texture2D(texture, texUV) * color;

   #if MC_VERSION >= 12100
      albedo.rgb = mix(albedo.rgb, albedo.rgb * fogColor, 0.9);
   #endif

   float theta   = mod(atan(worldPos.y, worldPos.x), PI) - 0.5*PI;
   float phi     = acos(worldPos.z / length(worldPos))   - 0.5*PI;
   float slice   = ceil(atan(theta, phi) * END_STARS_AMOUNT);
   float offset  = cos(slice);
   float invDist = offset / (theta*theta + phi*phi);
   float time    = frameTimeCounter * END_STARS_SPEED;

   slice *= offset;

   vec4 stars = exp(fract(invDist + slice + time) * -END_STARS_DRAG) / invDist;

   gl_FragData[0] = albedo + clamp(stars, vec4(0.0), vec4(1.0)) * END_STARS_OPACITY;
}