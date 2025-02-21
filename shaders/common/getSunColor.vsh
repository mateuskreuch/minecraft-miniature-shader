vec3 getSunColor() {
   float x    = worldTime * NORMALIZE_TIME;
   float y    = x > SUNRISE ? (x - 1.0) - NOON : x - NOON;
   bool isDay = x > SUNRISE || x < SUNSET;

   // make light redder on sunrise and sunset
   vec3 sunColor = isDay ? normalize(vec3(1.0 + clamp(66.0*y*y - 3.7142, 0.12, 1.0), 1.06, 1.0))
                         : MOON_COLOR;

   // create transition between color presets using light height
   sunColor *= clamp(0.1*(gbufferModelViewInverse * vec4(shadowLightPosition, 1.0)).y - 0.4453, 0.0, 1.0);

   // reduce color burn on dark spots
   return mix(vec3(length(sunColor)), sunColor, lightUV.t);
}