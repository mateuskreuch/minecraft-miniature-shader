{
#ifdef HAND_DYNAMIC_LIGHTING
float light = float(max(heldBlockLightValue, heldBlockLightValue2));
light = max(torchLight, min(1.0, light / pow(length(worldPos) + 1.5, 2.0)));
#else
float light = torchLight;
#endif

torchColor = TORCH_COLOR * max(0.0, light - 0.5*length(ambient.rgb));
}