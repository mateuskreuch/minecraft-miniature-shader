uniform sampler2D texture;

varying vec2 texUV;
varying float alpha;

void main() {
   vec4 albedo = texture2D(texture, texUV);

   albedo.a *= alpha;

   if (albedo.a < 0.1) {
      discard;
   }

   gl_FragData[0] = albedo;
}