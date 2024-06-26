{
#if MC_VERSION >= 11300 && defined ENABLE_FOG
   float len = length(fogShape == 1 ? vec3(worldPos.xz, 0.0) : worldPos);

   #if defined OVERWORLD

      float x = worldTime * NORMALIZE_TIME;

      x = clamp(25.0*(x < MIDNIGHT ? SUNSET - x : x - SUNRISE) + 0.3,
                OVERWORLD_FOG_MIN,
                OVERWORLD_FOG_MAX);

      x = min(x, 1.0 - rainStrength);
      x = max(x, float(isEyeInWater != 0));

      fogMix = rescale(len, x*fogStart, fogEnd);

   #elif defined THE_NETHER

      fogMix = rescale(len, fogStart, fogEnd * (isEyeInWater == 0 ? NETHER_FOG : 1.0));

   #else

      fogMix = rescale(len, fogStart, fogEnd);

   #endif
#else

   fogMix = 0.0;

#endif
}