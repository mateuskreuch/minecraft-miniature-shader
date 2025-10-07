uniform sampler2D gtexture;

varying vec2 texUV;
varying float alpha;

void main() {
   vec4 albedo = texture2DLod(gtexture, texUV, 0);

   albedo.a *= alpha;

   if (albedo.a < 0.1) {
      discard;
   }

   gl_FragData[0] = albedo;
}