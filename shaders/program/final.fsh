#define final

#include "/shader.h"

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform sampler2D colortex0;
uniform sampler2D colortex6;
uniform sampler2D colortex7;
uniform sampler2D depthtex0;

varying vec2 texcoord;

#include "/common/math.glsl"
#include "/common/transformations.fsh"

bool isReflective(vec2 uv) {
   return texture2D(colortex7, uv).r > 0.99;
}

void main() {
   vec4 color = texture2D(colortex0, texcoord);

   #include "/common/reflections.fsh"

   gl_FragData[0] = color;
}