{
float posNoise = noise(floor(worldPos.xz) + floor(cameraPosition.xz));

normal.xyz = gl_Normal;

#if WATER_WAVE_SIZE > 0

if (isWater > 0.9) {
   normal.xyz += vec3(
      0.01*WATER_WAVE_SIZE*sin(posNoise * frameTimeCounter),
      0.0,
      0.01*WATER_WAVE_SIZE*cos(posNoise * frameTimeCounter)
   );
}

#endif

#if WATER_MIN_TEXTURE >= 0

texstrength = 2.0*max(posNoise - 0.5, 0.05*WATER_MIN_TEXTURE);

#else

texstrength = 0.0;

#endif

// scale normal to 0..1
normal = vec4(0.5 + 0.5*normal.xyz, 1.0);

#if MC_VERSION >= 11300

// if the water is not still show all texture
texstrength = gl_Normal.x == 0.0 && gl_Normal.z == 0.0 ? texstrength : 1.0;

#else

// older versions set water color at white, so this gives it some blue
texstrength = 0.75;

#endif
}