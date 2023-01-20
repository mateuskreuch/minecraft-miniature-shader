#version 120

#define NOON 0.25
#define SUNSET 0.5325 // 12780
#define MIDNIGHT 0.75
#define SUNRISE 0.9675 // 23220

uniform mat4 gbufferModelViewInverse;
uniform vec3 moonPosition;
uniform vec3 sunPosition;
uniform int  worldTime;

varying vec3 lightColor;
varying vec3 lightPos;
varying vec2 texcoord;

vec3 screen2world(vec3 screen) {
   mat4 modelViewInverse = gbufferModelViewInverse;

   // clear transformations to stabilize conversions
   modelViewInverse[3] = vec4(0.0, 0.0, 0.0, 1.0);

   return (modelViewInverse * vec4(screen, 1.0)).xyz;
}

void main() {
   gl_Position = ftransform();

   texcoord = gl_MultiTexCoord0.st;

   float x    = worldTime/24000.0;
   float y    = x > SUNRISE ? x - 1.0 : x;
   bool isDay = x > SUNRISE || x < SUNSET;
   
   // get world-space light position
   lightPos = screen2world(normalize(isDay ? sunPosition : moonPosition));

   // make light redder on sunrise and sunset
   lightColor = isDay ? normalize(vec3(1.0 + clamp(66.0*(y - NOON)*(y - NOON) - 3.7142, 0.4, 1.0), 1.1, 1.0))
                      : vec3(0.05, 0.05, 0.15); 
   
   // create transition between color presets
   lightColor *= clamp(2.0*75.0*abs(x - (x < MIDNIGHT ? SUNSET : SUNRISE)) - 1.0, 0.0, 1.0);
}