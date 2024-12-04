float getSunStrength() {
   #if SHADOW_PIXEL > 0

      vec3 pos = worldPos + cameraPosition;
      pos = pos * SHADOW_PIXEL;
      pos = floor(pos + 0.01) + 0.5;
      pos = pos / SHADOW_PIXEL - cameraPosition;

   #else

      vec3 pos = worldPos;

   #endif

   float posDistance = squaredLength(pos);
   vec4 shadowView   = shadowModelView * vec4(pos, 1.0);
   vec3 shadowUV     = nvec3(shadowProjection * shadowView)*0.5 + 0.5;

   if (posDistance < SHADOW_MAX_DIST_SQUARED &&
      diffuse    > 0.0 && shadowUV.z < 1.0 &&
      shadowUV.s > 0.0 && shadowUV.s < 1.0 &&
      shadowUV.t > 0.0 && shadowUV.t < 1.0)
   {
      float shadowFade  = 1.0 - posDistance * INV_SHADOW_MAX_DIST_SQUARED;
      float shadowDepth = texture2D(shadowtex1, shadowUV.st).x;

      return diffuse * (1.0 - shadowFade * clamp(2.0*(shadowDepth - shadowUV.z) / shadowProjection[2].z, 0.0, 1.0));
   }

   return diffuse;
}