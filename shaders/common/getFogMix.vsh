float getFogMix(vec3 worldPos) {
#if MC_VERSION >= 11300 && defined ENABLE_FOG
   float len = fogShape == 1 ? length(worldPos.xz) : length(worldPos);

   #if defined gbuffers_clouds

      return rescale(len, fogStart, fogStart + 150.0);

   #elif defined OVERWORLD

      float x = worldTime * NORMALIZE_TIME;

      x = clamp(25.0*(x < MIDNIGHT ? SUNSET - x : x - SUNRISE) + 0.3,
                OVERWORLD_FOG_MIN,
                OVERWORLD_FOG_MAX);

      x = min(x, 1.0 - rainStrength);
      x = max(x, float(isEyeInWater != 0));

      return rescale(len, x*fogStart, fogEnd);

   #elif defined THE_NETHER

      return rescale(len, fogStart, fogEnd * (isEyeInWater == 0 ? NETHER_FOG : 1.0));

   #else

      return rescale(len, fogStart, fogEnd);

   #endif
#else

   return 0.0;

#endif
}