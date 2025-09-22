#define gbuffers_clouds

#include "/shader.h"

uniform sampler2D texture;
uniform vec3 fogColor;
uniform vec3 shadowLightPosition;

varying float fogMix;
varying vec2 texUV;
varying vec3 normalizedViewPos;
varying vec4 color;

#include "/common/math.glsl"

void main() {
   vec4 albedo = texture2D(texture, texUV) * color;
   float angleToLight = dot(normalizedViewPos, normalize(shadowLightPosition));

   albedo.a = mix(albedo.a, 0, fogMix);
   albedo.rgb = mix(albedo.rgb, fogColor, 0.6);
   albedo.a *= 1.0 - rescale(angleToLight, 0.96, 1.0);

   /* DRAWBUFFERS:06 */
   gl_FragData[0] = albedo;
   gl_FragData[1] = vec4(vec3(0.0), 1.0);
}