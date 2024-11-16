float getReflectionVignette(vec2 uv) {
   uv.y = 1.0 - uv.y;
   uv.x *= 1.0 - uv.x;
   uv.y *= uv.y;

   return 1.0 - pow(1.0 - uv.x, 50.0*uv.y);
}