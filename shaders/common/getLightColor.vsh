vec3 getLightColor() {
   vec3 lightColor = isDay ? sunColor : MOON_COLOR;

   lightColor *= shadowLightStrength;

   // reduce color burn on dark spots
   return mix(vec3(luma(lightColor)), lightColor, lightUV.t);
}