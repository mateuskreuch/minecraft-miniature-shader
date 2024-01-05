{
bool isThin = mc_Entity.x == 10031.0 || mc_Entity.x == 10059.0
           || mc_Entity.x == 10175.0 || mc_Entity.x == 10176.0
           || gl_Normal.y == 0.0 && abs(abs(gl_Normal.x) - abs(gl_Normal.z)) < 0.01;

      //  reduce under water
diffuse = (isEyeInWater == 0 ? 1.0 : 0.5)
      //  reduce with fog
         * (1.0 - fogMix)
      //  reduce with rain strength
         * (1.0 - rainStrength)
      //  reduce with sky light
         * 2.0*max(min(1.6*lightUV.t, 1.0) - 0.5, 0.0)
      //  thin objects have constant diffuse
         * (isThin ? 0.75 : clamp(2.5*dot(normalize(gl_NormalMatrix * gl_Normal),
                                          normalize(shadowLightPosition)), 0.0, 1.0));
}

//----------------------------------------------------------------------------//

{
float x    = worldTime * NORMALIZE_TIME;
float y    = x > SUNRISE ? x - 1.0 : x;
bool isDay = x > SUNRISE || x < SUNSET;

// make light redder on sunrise and sunset
lightColor = isDay ? normalize(vec3(1.0 + clamp(66.0*(y - NOON)*(y - NOON) - 3.7142, 0.4, 1.0), 1.1, 1.0))
                   : vec3(0.04, 0.04, 0.12); 

// create transition between color presets using light height
lightColor *= clamp(2.0*0.1123*(gbufferModelViewInverse * vec4(shadowLightPosition, 1.0)).y - 1.0, 0.0, 1.0);

// reduce color burn on dark spots
lightColor = mix(vec3(length(lightColor)), lightColor, lightUV.t);
}