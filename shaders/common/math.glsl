#define rescale(x, a, b) clamp((x - a) / (b - a), 0.0, 1.0)
#define squaredLength(v) dot(v, v)
#define luma(color) dot(vec3(0.299, 0.587, 0.114), color)

float noise(vec2 pos) {
	return fract(sin(dot(pos, vec2(18.9898, 28.633))) * 4378.5453);
}

vec3 nvec3(vec4 pos) {
   return pos.xyz / pos.w;
}