// Adapted from https://github.com/Luracasmus/Base-460C

vec2 rot_trans_mmul(mat4 rot_trans_mat, vec2 vec) {
	return mat2(rot_trans_mat) * vec + rot_trans_mat[3].xy;
}

vec3 rot_trans_mmul(mat4 rot_trans_mat, vec3 vec) {
	return mat3(rot_trans_mat) * vec + rot_trans_mat[3].xyz;
}

vec4 proj_mmul(mat4 proj_mat, vec3 view) {
	return vec4(
		vec2(proj_mat[0].x, proj_mat[1].y) * view.xy,
		fma(proj_mat[2].z, view.z, proj_mat[3].z),
		proj_mat[2].w * view.z
	);
}

vec3 proj_inv(mat4 inv_proj_mat, vec3 ndc) {
	vec4 view_undiv = vec4(
		vec2(inv_proj_mat[0].x, inv_proj_mat[1].y) * ndc.xy,
		inv_proj_mat[3].z,
		fma(inv_proj_mat[2].w, ndc.z, inv_proj_mat[3].w)
	);

	return view_undiv.xyz / view_undiv.w;
}

uniform float viewHeight, viewWidth;
uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix, projectionMatrix;

in vec3 vaNormal, vaPosition;
in vec4 vaColor;

out VertexData {
	layout(location = 0, component = 0) vec4 tint;
} v;

void main() {
	v.tint = vaColor;

	vec3 model = vaPosition + chunkOffset;

	const float view_shrink = 1.0 - (1.0 / 256.0);
	vec4 start_clip = proj_mmul(projectionMatrix, view_shrink * rot_trans_mmul(modelViewMatrix, model));
	vec4 end_clip = proj_mmul(projectionMatrix, view_shrink * rot_trans_mmul(modelViewMatrix, model + vaNormal));

	vec3 start_ndc = start_clip.xyz / start_clip.w;
	vec3 end_ndc = end_clip.xyz / end_clip.w;

	const float line_width = 2.5;

	vec2 view_size = vec2(viewWidth, viewHeight);
	vec2 dir_screen = normalize((end_ndc.xy - start_ndc.xy) * view_size);
	vec2 offset_ndc = line_width / view_size * vec2(-dir_screen.y, dir_screen.x);

	start_ndc.xy += ((gl_VertexID & 1) == 0 ^^ offset_ndc.x < 0.0) ? -offset_ndc : offset_ndc;

	gl_Position = vec4(start_ndc * start_clip.w, start_clip.w);
}
