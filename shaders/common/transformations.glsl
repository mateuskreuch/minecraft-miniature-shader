uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform vec3 cameraPosition;

vec3 nvec3(vec4 pos) {
   return pos.xyz / pos.w;
}

vec3 screen2ndc(vec2 uv, float depth) {
   return 2.0*vec3(uv, depth) - 1.0;
}

vec3 ndc2screen(vec3 ndc) {
   return 0.5*ndc + 0.5;
}

vec3 ndc2view(vec3 ndc) {
   return nvec3(gbufferProjectionInverse * vec4(ndc, 1.0));
}

vec3 clip2screen(vec4 clip) {
   return 0.5*nvec3(clip) + 0.5;
}

vec3 view2ndc(vec3 view) {
   return nvec3(gbufferProjection * vec4(view, 1.0));
}

vec3 view2feetBobless(vec3 view) {
   return mat3(gbufferModelViewInverse) * view;
}

vec3 view2feet(vec3 view) {
   return (gbufferModelViewInverse * vec4(view, 1.0)).xyz;
}

vec3 feet2viewBobless(vec3 feet) {
   return mat3(gbufferModelView) * feet;
}

vec3 feet2view(vec3 feet) {
   return (gbufferModelView * vec4(feet, 1.0)).xyz;
}

vec3 feet2world(vec3 feet) {
   return feet + cameraPosition;
}

vec3 world2feet(vec3 world) {
   return world - cameraPosition;
}

// combined functions

vec3 screen2view(vec2 uv, float depth) {
   return ndc2view(screen2ndc(uv, depth));
}

vec3 screen2feet(vec2 uv, float depth) {
   return view2feet(screen2view(uv, depth));
}

vec3 screen2world(vec2 uv, float depth) {
   return feet2world(screen2feet(uv, depth));
}

vec3 view2screen(vec3 view) {
   return ndc2screen(view2ndc(view));
}

vec3 world2view(vec3 world) {
   return feet2view(world2feet(world));
}