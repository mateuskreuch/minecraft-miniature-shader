vec3 getWaterWave(float random) {
   if (abs(normal.y) > 0.8) {
      float v = (20.0 / (WATER_WAVE_SIZE - 0.4))
              / max(1.0, length(worldPos.xz));

      v = min(1.0, v);

      return vec3(
         v * pow3(sin(random * WATER_WAVE_SPEED * frameTimeCounter)),
         0.0,
         v * pow3(cos(random * WATER_WAVE_SPEED * frameTimeCounter))
      );
   }
}