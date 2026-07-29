vec3 getLightColor(float sunHeight, float skyLight) {
   float sunRedness = 1.0 - clamp(0.2*sunHeight - 3.929, 0.0, 1.0);

   vec3 lightColor = sunHeight > 0.01 ? normalize(vec3(1.0 + clamp(sunRedness, 0.12, 1.0), 1.06, 1.0))
                                      : MOON_COLOR;

   // reduce color burn on dark spots
   return mix(vec3(luma(lightColor)), lightColor, skyLight);
}