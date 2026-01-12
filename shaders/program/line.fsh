// Adapted from https://github.com/Luracasmus/Base-460C

/* RENDERTARGETS: 0 */
layout(location = 0) out vec4 colortex0;

in VertexData {
	layout(location = 0, component = 0) vec4 tint;
} v;

void main() {
	colortex0 = v.tint;
}
