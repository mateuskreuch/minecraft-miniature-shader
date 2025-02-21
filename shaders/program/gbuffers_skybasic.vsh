#define gbuffers_skybasic

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

varying vec4 color;

void main()
{
   vec3 position = (gl_ModelViewMatrix * gl_Vertex).xyz;
   position = (gbufferModelViewInverse * vec4(position, 1.0)).xyz;

   gl_Position = gl_ProjectionMatrix * gbufferModelView * vec4(position, 1.0);
   gl_FogFragCoord = length(position);

   color = gl_Color;
}
