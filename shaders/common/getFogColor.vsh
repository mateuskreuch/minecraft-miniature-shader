vec3 getFogColor(float fogMix, vec3 worldPos) {
   return mix(fogColor, skyColor, fogMix * max(0.0, 0.006*worldPos.y));
}