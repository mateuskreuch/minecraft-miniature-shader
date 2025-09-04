#version 330 compatibility
uniform sampler2D texture;

uniform float viewWidth;
uniform float viewHeight;
uniform int blockEntityId;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform float frameTimeCounter;
varying vec2 texcoord;
varying vec4 color;

in vec2 lmcoord;

#define BrightnessSin(speed, mod) (sin((time+mod)*(speed))/4 + 3.75)
#define coord(theta) vec2(\
	gl_FragCoord.x*cos(theta)-gl_FragCoord.y*sin(theta),\
	gl_FragCoord.x*sin(theta)+gl_FragCoord.y*cos(theta)\
)

void main() {
	if(blockEntityId == 1000){
		float time = frameTimeCounter / 65;
		vec4 albedo;
		albedo  = texture2D(texture, coord(0.123)/1800 + vec2(0, time*0.5+12)) 			* color * BrightnessSin(10, 0)	*.9 	*vec4(0.5,1.3,0.75,1);
		albedo += texture2D(texture, coord(5.123)/1500 + vec2(9283, time*0.4-78)) 		* color * BrightnessSin(10, 100)*.65 	*vec4(0.75,1,0.8,1);
		albedo += texture2D(texture, coord(0.998)/1000 + vec2(45, time*0.89+238)) 		* color * BrightnessSin(10, 56)	*.5;
		albedo += texture2D(texture, coord(0.765)/1100 + vec2(423, time*0.5+24328)) 	* color * BrightnessSin(10, 56)	*.5		*vec4(1.3, 0.5, 0.7, 1);
		albedo += texture2D(texture, coord(1.23)/900   + vec2(273, time*1.3+24)) 		* color * BrightnessSin(10, 75)	*.25 	*vec4(1,0,1,1);
		albedo += texture2D(texture, coord(5.324)/00   + vec2(21233, time*1.1+24)) 		* color * BrightnessSin(10, 43)	*.5;
		albedo += texture2D(texture, coord(3.45)/300   + vec2(24323, time*0.85+53)) 	* color * BrightnessSin(10, 12)	*.5		*vec4(1.3, 0.5, 0.7, 1);
		albedo += texture2D(texture, coord(4.32)/100   + vec2(24323, time*0.95+53)) 	* color * BrightnessSin(10, 12)	*.5		*vec4(1.5, 1, 1.25, 0.7);
		albedo += texture2D(texture, coord(0.85)/4000  + vec2(24323, time*1.15+53)) 	* color * BrightnessSin(10, 12)	*.15	*vec4(1.2, 1, 1.22, 0.7);
		albedo += texture2D(texture, coord(2.75)/4000  + vec2(24323, time*0.25+53)) 	* color * BrightnessSin(10, 12)	*.15	*vec4(1.2, 1, 1.24, 0.7);
		albedo += texture2D(texture, coord(1.35)/10000 + vec2(24323, time*0.845+53)) 	* color * BrightnessSin(10, 12)	*.15	*vec4(1.3, 1, 1.45, 0.7);
	
		gl_FragData[0] = albedo;
	}
	else{
		vec4 albedo = texture2D(texture, texcoord) * color;
	
		gl_FragData[0] = albedo;
	}

}