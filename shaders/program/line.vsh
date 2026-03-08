const float LINE_WIDTH = 2.5;
const float VIEW_SHRINK = 1.0 - (1.0 / 256.0);

uniform float viewHeight;
uniform float viewWidth;

varying vec4 color;

#include "/common/transformations.glsl"

void main() {
	color = gl_Color;

	vec4 lineStartClip = view2clip(VIEW_SHRINK * feet2view(gl_Vertex.xyz));
	vec4 lineEndClip = view2clip(VIEW_SHRINK * feet2view(gl_Vertex.xyz + gl_Normal));

	vec3 lineStartNdc = clip2ndc(lineStartClip);
	vec3 lineEndNdc = clip2ndc(lineEndClip);

	vec2 resolution = vec2(viewWidth, viewHeight);
	vec2 lineScreenDirection = normalize((lineEndNdc.xy - lineStartNdc.xy) * resolution);
	vec2 lineOffset = vec2(-lineScreenDirection.y, lineScreenDirection.x) * LINE_WIDTH / resolution;

	lineStartNdc.xy += ((gl_VertexID & 1) == 0 ^^ lineOffset.x < 0.0) ? -lineOffset : lineOffset;

	gl_Position = vec4(lineStartNdc * lineStartClip.w, lineStartClip.w);
}