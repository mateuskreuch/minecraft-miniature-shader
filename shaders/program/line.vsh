const float LINE_WIDTH = 2.5;
const float VIEW_SHRINK = 1.0 - (1.0 / 256.0);

uniform float viewHeight;
uniform float viewWidth;

varying vec4 color;

#include "/common/transformations.glsl"

void main() {
	color = gl_Color;

	vec3 linePosStart = view2ndc(VIEW_SHRINK * feet2view(gl_Vertex.xyz));
	vec3 linePosEnd = view2ndc(VIEW_SHRINK * feet2view(gl_Vertex.xyz + gl_Normal));

	vec2 resolution = vec2(viewWidth, viewHeight);
	vec2 lineScreenDirection = normalize((linePosEnd.xy - linePosStart.xy) * resolution);
	vec2 lineOffset = vec2(-lineScreenDirection.y, lineScreenDirection.x) * LINE_WIDTH / resolution;

	if (gl_VertexID % 2 != 0) {
		lineOffset = -lineOffset;
	}

	linePosStart.xy += lineOffset;

	gl_Position = vec4(linePosStart, 1.0);
}