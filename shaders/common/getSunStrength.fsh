{
   #if SHADOW_PIXEL > 0

   vec3 pos = worldPos + cameraPosition;
   pos = pos * SHADOW_PIXEL + 0.01;
   pos = floor(pos + 0.5);
   pos = pos / SHADOW_PIXEL - cameraPosition;

   #else

   vec3 pos = worldPos;

   #endif

   sunStrength = diffuse;

   float posDistance = squaredLength(pos);
   vec4 shadowScreen = shadowModelView * vec4(pos, 1.0);
   vec2 shadowUV     = nvec3(shadowProjection * shadowScreen).st*0.5 + 0.5;

   if (posDistance < SHADOW_MAX_DIST_SQUARED &&
      -shadowScreen.z > 0.0 && diffuse > 0.0 &&
      shadowUV.s > 0.0 && shadowUV.s < 1.0 &&
      shadowUV.t > 0.0 && shadowUV.t < 1.0)
   {
      float shadowFade  = 1.0 - posDistance * INV_SHADOW_MAX_DIST_SQUARED;
      float shadowDepth = 256.0*texture2D(shadowtex1, shadowUV).x;

      sunStrength *= (1.0 - shadowFade * clamp(-shadowScreen.z - shadowDepth, 0.0, 1.0));
   }
}