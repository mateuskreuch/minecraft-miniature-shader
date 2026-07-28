float getWaterTextureStrength(float random) {
   // if the water is moving show all texture
   return !(abs(gl_Normal.x) < 0.01 && abs(gl_Normal.z) < 0.01) ? 1.0
      #if WATER_MIN_GLINT >= 0

         : max(random, 0.1*WATER_MIN_GLINT);

      #else

         : 0.0;

      #endif
}