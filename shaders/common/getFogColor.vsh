uniform vec3 fogColor;
uniform vec3 skyColor;

vec3 getFogColor(float fogMix, vec3 feetPos) {
   return mix(fogColor, skyColor, fogMix * clamp(0.006*feetPos.y, 0.0, 1.0));
}