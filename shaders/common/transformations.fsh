vec2 screen2uv(vec3 screen) {
   return (0.5*nvec3(gbufferProjection * vec4(screen, 1.0)) + 0.5).st;
}

vec3 uv2screen(vec2 uv, float depth) {
   return nvec3(gbufferProjectionInverse * vec4(2.0*vec3(uv, depth) - 1.0, 1.0));
}

vec3 world2screen(vec3 world) {
   return mat3(gbufferModelView) * world;
}