vec3 getTorchColor(vec3 ambient, vec3 feetPos) {
   #ifdef HAND_DYNAMIC_LIGHTING

      float strength = float(heldBlockLightValue);

      strength = max(torchStrength, min(1.0, strength / pow2(length(feetPos) + 1.5)));

   #else

      float strength = torchStrength;

   #endif

   strength = smoothe(strength);
   strength = mix(strength*strength, strength, eyeBrightnessSmooth.y/240.0);

   return mix(TORCH_OUTER_COLOR, TORCH_COLOR, strength) * strength * max(0.0, 1.0 - luma(ambient));
}