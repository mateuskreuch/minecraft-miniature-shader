vec3 getShadowDistortion(vec3 shadowClipPos){
  shadowClipPos.xy /= 0.8*abs(shadowClipPos.xy) + 0.2;

  return shadowClipPos;
}