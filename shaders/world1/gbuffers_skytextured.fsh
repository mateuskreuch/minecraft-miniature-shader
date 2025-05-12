#version 120

#define THE_END

#include "/shader.h"

uniform sampler2D texture;
uniform float frameTimeCounter;

varying vec2 texUV;
varying vec4 color;
varying vec3 worldPos;

void main() {
   vec4 albedo = texture2D(texture, texUV) * color;

   float theta   = mod(atan(worldPos.y, worldPos.x), PI) - 0.5*PI;
   float phi     = acos(worldPos.z / length(worldPos))   - 0.5*PI;
   float slice   = ceil(atan(theta, phi) * END_STARS_AMOUNT);
   float offset  = cos(slice);
   float invDist = offset / (theta*theta + phi*phi);
   float time    = frameTimeCounter * END_STARS_SPEED;

   slice *= offset;

   vec4 stars = exp(fract(invDist + slice + time) * -END_STARS_DRAG) / invDist;

   // TODO: Find out why this is needed
   #if MC_VERSION >= 12100
      albedo.rgb -= 0.6;
   #endif

   gl_FragData[0] = albedo + clamp(stars, vec4(0.0), vec4(1.0)) * END_STARS_OPACITY;
}