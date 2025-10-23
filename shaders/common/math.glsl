float random(vec2 v) {
	return fract(sin(dot(v, vec2(18.9898, 28.633))) * 4378.5453);
}

float random(vec3 v) {
   return fract(sin(dot(v, vec3(12.9898, 78.233, 45.164))) * 43758.5453);
}

vec3 random3(vec3 v) {
   v = fract(v * vec3(0.3183099, 0.3678794, 0.7071068)); // 1/π, 1/e, 1/√2
   v += dot(v, v.yzx + 19.19);

   return fract(vec3(v.x * v.y * 95.4307,
                     v.y * v.z * 97.5901,
                     v.z * v.x * 93.8365)) - 0.5;
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

float round(float x) {
   return floor(x + 0.5);
}

vec3 round(vec3 x) {
   return floor(x + 0.5);
}

float squaredLength(vec3 v) {
   return dot(v, v);
}

float stepify(float x, float stepSize) {
   return round(x / stepSize) * stepSize;
}

vec3 stepify(vec3 x, float stepSize) {
   return round(x / stepSize) * stepSize;
}

vec3 bandify(vec3 value, float bands) {
   return (floor(value*bands + 0.01) + 0.5) / bands;
}

float fogify(float x, float w) {
	return w / (x * x + w);
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