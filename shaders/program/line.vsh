const float LINE_WIDTH = 2.5;
const float VIEW_SHRINK = 1.0 - (1.0 / 256.0);
const mat4 VIEW_SCALE = mat4(
	VIEW_SHRINK, 0.0, 0.0, 0.0,
	0.0, VIEW_SHRINK, 0.0, 0.0,
	0.0, 0.0, VIEW_SHRINK, 0.0,
	0.0, 0.0, 0.0, 1.0
);

uniform float viewHeight;
uniform float viewWidth;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;

varying vec4 color;

void main() {
	color = gl_Color;

	vec2 resolution = vec2(viewWidth, viewHeight);
	vec4 linePosStart = gbufferProjection * (VIEW_SCALE * (gbufferModelView * vec4(gl_Vertex.xyz, 1.0)));
	vec4 linePosEnd = gbufferProjection * (VIEW_SCALE * (gbufferModelView * vec4(gl_Vertex.xyz + gl_Normal, 1.0)));

	linePosStart /= linePosStart.w;
	linePosEnd /= linePosEnd.w;

	vec2 lineScreenDirection = normalize((linePosEnd.xy - linePosStart.xy) * resolution);
	vec2 lineOffset = vec2(-lineScreenDirection.y, lineScreenDirection.x) * LINE_WIDTH / resolution;

	if (gl_VertexID % 2 != 0) {
		lineOffset = -lineOffset;
	}

	gl_Position = vec4((linePosStart.xyz + vec3(lineOffset, 0.0)) * linePosStart.w, linePosStart.w);
}