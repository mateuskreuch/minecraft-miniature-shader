float getWaterTextureStrength(float random) {
   // if the water is moving show all texture
   return !(abs(gl_Normal.x) < 0.01 && abs(gl_Normal.z) < 0.01) ? 1.0
      #if WATER_MIN_TEXTURE >= 0

         : 2.0*max(random - 0.5, 0.05*WATER_MIN_TEXTURE);

      #else

         : 0.0;

      #endif
}