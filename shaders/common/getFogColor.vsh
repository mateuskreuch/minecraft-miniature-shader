vec3 getFogColor(vec3 worldPos) {
   return mix(fogColor, skyColor, max(0.0, 0.0067*worldPos.y));
}