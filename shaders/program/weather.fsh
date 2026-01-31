#include "/shader.h"

uniform sampler2D gtexture;

varying vec2 texUV;
varying vec4 color;

void main() {
   vec4 albedo = texture2D(gtexture, texUV) * color;

   albedo.a *= WEATHER_OPACITY;

   gl_FragData[0] = albedo;
}
