#define gbuffers_particles

uniform sampler2D texture;

varying vec2 texUV;
varying vec4 color;

void main() {
   /* DRAWBUFFERS:06 */
   gl_FragData[0] = texture2D(texture, texUV) * color;
   gl_FragData[1] = vec4(vec3(0.0), 1.0);
}
