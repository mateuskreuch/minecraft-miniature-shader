vec3 getViewPosition() {
   return (gl_ModelViewMatrix * gl_Vertex).xyz;
}