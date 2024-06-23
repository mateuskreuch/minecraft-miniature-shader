{
normal.xyz = gl_Normal;

if (isWater > 0.9) {
   float posNoise = noise(floor(worldPos.xz) + floor(cameraPosition.xz));

   #if WATER_WAVE_SIZE > 0

      if (abs(normal.y) > 0.8) {
         float v = (20.0 / (WATER_WAVE_SIZE - 0.4))
               / max(1.0, length(worldPos.xz));

         v = min(1.0, v);

         normal.xyz += vec3(
            v * pow3(sin(posNoise * WATER_WAVE_SPEED * frameTimeCounter)),
            0.0,
            v * pow3(cos(posNoise * WATER_WAVE_SPEED * frameTimeCounter))
         );
      }

   #endif

   #if MC_VERSION >= 11300
      #if WATER_MIN_TEXTURE >= 0

         texStrength = 2.0*max(posNoise - 0.5, 0.05*WATER_MIN_TEXTURE);

      #else

         texStrength = 0.0;

      #endif

      // if the water is not still show all texture
      texStrength = gl_Normal.x == 0.0 && gl_Normal.z == 0.0 ? texStrength : 1.0;

   #else
      // older versions set water color at white, so this gives it some blue
      texStrength = 0.75;

   #endif
}

// scale normal to 0..1
normal = vec4(0.5 + 0.5*normal.xyz, 1.0);
}