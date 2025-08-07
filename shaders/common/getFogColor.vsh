vec3 getFogColor(float fogMix, vec3 worldPos) {
   return mix(fogColor, skyColor, fogMix * clamp(0.006*worldPos.y, 0.0, 1.0));
}