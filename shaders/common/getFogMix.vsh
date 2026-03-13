uniform float fogEnd, fogStart;
uniform float near, far;

float calcFogMix(vec3 feetPos, float fogStartMult) {
   float len = length(feetPos);
   float cylinderLen = max(length(feetPos.xz), abs(feetPos.y));

   return max(
      rescale(len, fogStartMult * fogStart, fogEnd),
      rescale(cylinderLen, fogStartMult * (far - clamp(0.1 * far, 4.0, 64.0)), far)
   );
}

float getFogMix(vec3 feetPos) {
   #ifndef ENABLE_FOG
      if (fogEnd >= far) {
         return 0.0;
      }
   #endif

   #if MC_VERSION >= 11700
      #ifndef MOD_COLORWHEEL
         if (fogEnd < far) {
            return calcFogMix(feetPos, 1.0);
         }
      #endif

      #if defined GBUFFERS_SKYBASIC
         return 0.0;
      #elif defined GBUFFERS_CLOUDS
         return clamp((length(feetPos) - far) * (near * 0.01), 0.0, 1.0);
      #else
         #ifdef OVERWORLD
            float x = worldTime * NORMALIZE_TIME;

            x = clamp(25.0*(x < MIDNIGHT ? SUNSET - x : x - SUNRISE) + 0.3,
                     OVERWORLD_FOG_MIN,
                     OVERWORLD_FOG_MAX);

            x = min(x, 1.0 - rainStrength);
         #else
            float x = 1.0;
         #endif

         return calcFogMix(feetPos, x);
      #endif
   #else
      gl_FogFragCoord = length(feetPos);

      return (isEyeInWater > 0) ? 1.0 - exp(-gl_FogFragCoord * gl_Fog.density)
                                : clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0);
   #endif
}