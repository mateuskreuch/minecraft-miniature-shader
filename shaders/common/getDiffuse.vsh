float getDiffuse(float skyLight) {
  bool isThin = mc_Entity.x == 10031.0 || mc_Entity.x == 10059.0
             || mc_Entity.x == 10175.0 || mc_Entity.x == 10176.0
             || (abs(gl_Normal.y) < 0.01 && abs(abs(gl_Normal.x) - abs(gl_Normal.z)) < 0.01);

        //  reduce under water
  return (isEyeInWater == 0 ? 1.0 : 0.5)
        //  reduce with fog
          * (1.0 - fogMix)
        //  reduce with rain strength
          * (1.0 - rainStrength)
        //  reduce with sky light
          * rescale(skyLight, 0.3137, 0.6235)
        //  thin objects have constant diffuse
          * (isThin ? 0.75 : clamp(2.5*dot(normalize(gl_NormalMatrix * gl_Normal),
                                           normalize(shadowLightPosition)), -0.3333, 1.0));
}