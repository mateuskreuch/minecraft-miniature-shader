{
#ifdef HAND_DYNAMIC_LIGHTING

   float strength = float(heldBlockLightValue);

   strength = max(torchStrength, min(1.0, strength / pow2(length(worldPos) + 1.5)));

#else

   float strength = torchStrength;

#endif

strength = smoothe(strength);
torchColor = mix(TORCH_OUTER_COLOR, TORCH_COLOR, strength) * strength * max(1.0 - luma(ambient.rgb), 0.0);
}