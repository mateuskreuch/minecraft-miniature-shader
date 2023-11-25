{
#if MC_VERSION >= 11300 && defined ENABLE_FOG
   #if defined THE_NETHER
      
      fogMix = rescale(length(worldPos), fogStart, fogEnd * (isEyeInWater == 0 ? NETHER_FOG : 1.0));

   #elif defined THE_END

      fogMix = rescale(length(worldPos), fogStart, fogEnd);

   #else

      float x = worldTime * NORMALIZE_TIME;

      x = clamp(25.0*(x < MIDNIGHT ? SUNSET - x : x - SUNRISE) + 0.3,
               OVERWORLD_FOG_MIN,
               OVERWORLD_FOG_MAX);

      x = min(x, 1.0 - rainStrength);
      x = max(x, float(isEyeInWater != 0));

      fogMix = rescale(length(worldPos.xz), x*fogStart, fogEnd);

   #endif
#else

   fogMix = 0.0;
   
#endif
}