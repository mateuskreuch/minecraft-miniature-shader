uniform sampler2D gtexture;
uniform sampler2D lightmap;

varying vec2 lightUV;
varying vec2 texUV;
varying vec4 color;

void main() {
   gl_FragData[0] = texture2D(gtexture, texUV)
                  * texture2D(lightmap, lightUV)
                  * color;
}
