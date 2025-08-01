float getFogMix(vec3 worldPos) {
   #ifndef ENABLE_FOG

      return 0.0;

   #endif

   float len = fogShape == 1 ? max(length(worldPos.xz), abs(worldPos.y)) : length(worldPos);

   #if MC_VERSION >= 11700

      if (fogEnd < far) {
         return rescale(len, min(fogStart, fogEnd), fogEnd);
      }

      #if defined gbuffers_skybasic

         return 0.0;

      #elif defined gbuffers_clouds

         return clamp((len - far) * (near * 0.01), 0.0, 1.0);

      #elif defined OVERWORLD

         float x = worldTime * NORMALIZE_TIME;

         x = clamp(25.0*(x < MIDNIGHT ? SUNSET - x : x - SUNRISE) + 0.3,
                  OVERWORLD_FOG_MIN,
                  OVERWORLD_FOG_MAX);

         x = min(x, 1.0 - rainStrength);
         x = max(x, 0.05); // Hopefully prevents fog covering everything in some cards

         return min(1.0, rescale(len, 0.9*x*far, far) + 0.0015*max(0.0, len - 96.0));

      #else

         return rescale(len, 0.9*far, far);

      #endif

   #else

      gl_FogFragCoord = len;

      return (isEyeInWater > 0) ? 1.0 - exp(-gl_FogFragCoord * gl_Fog.density)
                                 : clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0);

   #endif
}