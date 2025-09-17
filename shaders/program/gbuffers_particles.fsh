#define gbuffers_particles

#include "/shader.h"

uniform sampler2D lightmap;
uniform sampler2D texture;

varying vec2 lightUV;
varying vec2 texUV;
varying vec4 color;

void main() {
   vec4 albedo = texture2D(texture, texUV) * color;

   albedo.rgb *= max(texture2D(lightmap, lightUV).rgb, vec3(lightUV.s));

   /* DRAWBUFFERS:06 */
   gl_FragData[0] = albedo;
   gl_FragData[1] = vec4(vec3(0.0), 1.0);
}
