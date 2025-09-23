uniform float screenBrightness;

vec4 getAmbientColor(float sunHeight) {
   vec4 ambient = texture2D(lightmap, vec2(AMBIENT_UV.s, lightUV.t));

   float x = ambient.g;
   float final = (((0.8494 * x + 0.9687) * x - 5.238) * x + 3.711) * x - 0.2864;

   final = max(0.0, final);

   ambient.rgb = mix(
      min(vec3(1.0), ambient.rgb + vec3(final) * clamp(0.2*sunHeight, 0.0, 1.0)),
      ambient.rgb,
      screenBrightness
   );

   return ambient;
}