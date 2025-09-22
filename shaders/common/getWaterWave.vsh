void getWaterWave(inout vec4 normal, float random, vec3 feetPos) {
   if (abs(normal.y) > 0.8) {
      float v = (20.0 / (WATER_WAVE_SIZE - 0.4))
              / max(1.0, length(feetPos.xz));

      v = min(1.0, v);

      normal.xyz = normalize(normal.xyz + vec3(
         v * pow3(sin(random * WATER_WAVE_SPEED * frameTimeCounter)),
         0.0,
         v * pow3(cos(random * WATER_WAVE_SPEED * frameTimeCounter))
      ));
   }
}