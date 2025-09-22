vec3 getViewPosition() {
   return (gl_ModelViewMatrix * gl_Vertex).xyz;
}

vec3 getEyePosition() {
   return mat3(gbufferModelViewInverse) * getViewPosition();
}

vec3 getFeetPosition() {
   return getEyePosition() + gbufferModelViewInverse[3].xyz;
}