#version 120

#include "/shader.h"

const vec2 OFFSET = vec2(0.5*PI);

uniform sampler2D texture;
uniform float frameTimeCounter;

varying vec2 texUV;
varying vec4 color;
varying vec3 worldPos;

void main() {
	vec4 albedo = texture2D(texture, texUV) * color;

	float theta    = atan(worldPos.y, worldPos.x);
	float phi      = acos(worldPos.z / length(worldPos));
	vec2  position = vec2(mod(theta, PI), phi) - OFFSET;
	float slice    = ceil(atan(position.x, position.y) * END_STARS_AMOUNT);
	float offset   = cos(slice);
	float invDist  = offset / dot(position, position);
	float time     = frameTimeCounter * END_STARS_SPEED;

	slice *= offset;

	vec4 stars = exp(fract(invDist + slice + time) * -END_STARS_DRAG) / invDist;

	gl_FragData[0] = albedo + stars;
}