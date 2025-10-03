vec3 getWaterWave(float random, vec3 feetPos) {
   float v = (20.0 / (WATER_WAVE_SIZE - 0.4))
            / max(1.0, length(feetPos.xz));

   v = min(1.0, v);

   return v * vec3(
      pow3(sin(random * WATER_WAVE_SPEED * frameTimeCounter)),
      0.0,
      pow3(cos(random * WATER_WAVE_SPEED * frameTimeCounter))
   );
}