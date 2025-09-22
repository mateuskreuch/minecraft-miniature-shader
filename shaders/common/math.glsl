float random(vec2 pos) {
	return fract(sin(dot(pos, vec2(18.9898, 28.633))) * 4378.5453);
}

float random(vec3 pos) {
   return fract(sin(dot(pos, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

float luma(vec3 color) {
   return dot(vec3(0.299, 0.587, 0.114), color);
}

float rescale(float x, float a, float b) {
   return clamp((x - a) / (b - a), 0.0, 1.0);
}

vec3 rescale(vec3 x, vec3 a, vec3 b) {
   return clamp((x - a) / (b - a), vec3(0.0), vec3(1.0));
}

float squaredLength(vec3 v) {
   return dot(v, v);
}

vec3 bandify(vec3 value, float bands) {
   return (floor(value*bands + 0.01) + 0.5) / bands;
}

float fogify(float x, float w) {
	return w / (x * x + w);
}

vec3 nvec3(vec4 pos) {
   return pos.xyz / pos.w;
}

vec3 contrast(vec3 color, float contrast) {
   return contrast * (color.rgb - 0.5) + 0.5;
}

float invpow2(float x) {
   return 1.0 - x*x;
}

float smoothe(float x) {
   return x*x*(3.0 - 2.0*x);
}

float pow2(float x) {
   return x*x;
}

float pow3(float x) {
   return x*x*x;
}

vec2 sphericalEncode(vec3 n) {
   float yaw   = atan(n.y, n.x);
   float pitch = asin(clamp(n.z, -1.0, 1.0));

   yaw += float(yaw < 0.0) * TAU;

   return vec2(INV_TAU * yaw, INV_PI * (pitch + HALF_PI));
}

vec3 sphericalDecode(vec2 e) {
   float yaw   = TAU * e.x;
   float pitch =  PI * e.y - HALF_PI;
   float cy    = cos(pitch);

   return vec3(cos(yaw) * cy, sin(yaw) * cy, sin(pitch));
}