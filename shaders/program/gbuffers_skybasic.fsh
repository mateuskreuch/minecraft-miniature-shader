#define gbuffers_skybasic

uniform int isEyeInWater;
uniform vec3 fogColor;

varying vec4 color;

void main() {
   float fog = (isEyeInWater > 0)
             ? 1.0 - exp(-gl_FogFragCoord * gl_Fog.density)
             : clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0);

   gl_FragData[0] = mix(color, vec4(fogColor, color.a), fog);
}
