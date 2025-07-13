vec4 getAmbientColor() {
   float brightness = 1.0 - screenBrightness;
   brightness = 1.0 - brightness * brightness;

   vec4 ambient = texture2D(lightmap, vec2(AMBIENT_UV.s, lightUV.t));
   vec3 s = rescale(ambient.rgb, vec3(0.16), vec3(1.0));
   vec3 sharperAmbient = ambient.rgb + 8.0*(ambient.rgb * s*s);
   sharperAmbient = min(vec3(1.0), sharperAmbient);

   ambient.rgb = mix(sharperAmbient, ambient.rgb, brightness);

   return ambient;
}