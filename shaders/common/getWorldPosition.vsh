vec3 getWorldPosition() {
   return mat3(gbufferModelViewInverse)
        * (gl_ModelViewMatrix * gl_Vertex).xyz
        + gbufferModelViewInverse[3].xyz;
}