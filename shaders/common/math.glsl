float noise(vec2 pos) {
	return fract(sin(dot(pos, vec2(18.9898, 28.633))) * 4378.5453);
}

float rescale(float x, float a, float b) {
   return clamp((x - a) / (b - a), 0.0, 1.0);
}

float squaredLength(vec3 v) {
   return dot(v, v);
}

vec3 nvec3(vec4 pos) {
   return pos.xyz / pos.w;
}