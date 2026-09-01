vec3 getTorchColor(float torchLight, vec3 ambient, vec3 feetPos) {
   // clamp: Tweakeroo gamma can push screenBrightness > 1, which would overdrive the mixes below
   float brightness = clamp(screenBrightness, 0.0, 1.0);

   float strength = rescale(torchLight, TORCH_UV_SCALE.x, TORCH_UV_SCALE.y);

   #if HAND_DYNAMIC_LIGHTING >= 0

      strength = max(strength, rescale(float(heldBlockLightValue) - SQRT_2 * length(feetPos), 0.0, 15.0));

   #endif

   strength = mix(strength*strength, smoothe(strength), brightness);
   strength = mix(strength*strength, strength, max(1.0 - brightness, eyeBrightnessSmooth.y/240.0));

   return max(0.0, 1.0 - luma(ambient)) * strength * mix(
      mix(TORCH_OUTER_COLOR, TORCH_MIDDLE_COLOR, strength),
      TORCH_INNER_COLOR,
      slopeTo1(strength, 8.0)
   );
}