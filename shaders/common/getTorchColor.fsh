{
#ifdef HAND_DYNAMIC_LIGHTING

   float strength = float(heldBlockLightValue);

   strength = max(torchStrength, min(1.0, strength / pow2(length(worldPos) + 1.5)));

#else

   float strength = torchStrength;

#endif

torchColor = mix(TORCH_OUTER_COLOR, TORCH_COLOR, strength) * max(0.0, strength - 0.5*length(ambient.rgb));
}