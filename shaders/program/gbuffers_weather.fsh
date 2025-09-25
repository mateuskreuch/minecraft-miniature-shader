uniform sampler2D texture;

varying vec2 texUV;
varying vec4 color;

void main() {
   vec4 albedo = texture2D(texture, texUV) * color;

   albedo.a *= 0.33;

   gl_FragData[0] = albedo;
}
