#version 120

#include "shader.h"

uniform int worldTime;

varying vec3 lightColor;
varying vec2 texcoord;

void main() {
   gl_Position = ftransform();

   texcoord = gl_MultiTexCoord0.st;

   float x    = worldTime * NORMALIZE_TIME;
   float y    = x > SUNRISE ? x - 1.0 : x;
   bool isDay = x > SUNRISE || x < SUNSET;

   // make light redder on sunrise and sunset
   lightColor = isDay ? normalize(vec3(1.0 + clamp(66.0*(y - NOON)*(y - NOON) - 3.7142, 0.4, 1.0), 1.1, 1.0))
                      : vec3(0.04, 0.04, 0.12); 
   
   // create transition between color presets
   lightColor *= clamp(2.0*75.0*abs(x - (x < MIDNIGHT ? SUNSET : SUNRISE)) - 1.0, 0.0, 1.0);
}