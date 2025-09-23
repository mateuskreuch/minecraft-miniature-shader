uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform vec3 cameraPosition;

vec3 uv2view(vec2 uv, float depth) {
   return nvec3(gbufferProjectionInverse * vec4(2.0*vec3(uv, depth) - 1.0, 1.0));
}

vec2 view2uv(vec3 view) {
   return (0.5*nvec3(gbufferProjection * vec4(view, 1.0)) + 0.5).st;
}

vec3 view2feetBobless(vec3 view) {
   return mat3(gbufferModelViewInverse) * view;
}

vec3 view2feet(vec3 view) {
   return (mat4(gbufferModelViewInverse) * vec4(view, 1.0)).xyz;
}

vec3 feet2viewBobless(vec3 world) {
   return mat3(gbufferModelView) * world;
}

vec3 feet2view(vec3 world) {
   return (mat4(gbufferModelView) * vec4(world, 1.0)).xyz;
}

vec3 feet2world(vec3 feet) {
   return feet + cameraPosition;
}

vec3 world2feet(vec3 world) {
   return world - cameraPosition;
}

// combined functions

vec3 uv2feet(vec2 uv, float depth) {
   return view2feet(uv2view(uv, depth));
}

vec3 uv2world(vec2 uv, float depth) {
   return feet2world(uv2feet(uv, depth));
}

vec3 world2view(vec3 world) {
   return feet2view(world2feet(world));
}