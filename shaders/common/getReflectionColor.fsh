#define MAX_STEPS 16
#define BINARY_STEPS 6

float getReflectionVignette(vec2 uv) {
   uv.y = min(uv.y, 1.0 - uv.y);
   uv.x *= 1.0 - uv.x;
   uv.y *= uv.y;

   return 1.0 - pow(1.0 - uv.x, 50.0*uv.y);
}

vec4 getReflectionColor(float depth, vec3 normal, vec3 viewPos) {
   vec3 V = normalize(viewPos);
   vec3 R = normalize(reflect(V, normal));

   if (R.z >= -0.05) return vec4(0.0);

   float fresnel = 1.0 - dot(normal, -V);
   float epsilon = mix(1.0, 1.15, pow(fresnel, 10.0));
   vec3  oldPos  = viewPos;

   for (int i = 0; i < MAX_STEPS; i++) {
      float stepSize = pow(2.0, float(i));
      vec3 curPos = viewPos + R * stepSize;
      vec2 curUV  = view2uv(curPos);

      if (curUV.s < 0.0 || curUV.s > 1.0 || curUV.t < 0.0 || curUV.t > 1.0)
         break;

      float sceneDepth = texture2D(depthtex0, curUV).x;
      float sceneZ = uv2view(curUV, sceneDepth).z;

      if (-curPos.z >= -sceneZ * epsilon && sceneDepth + 0.001 > depth) {
         vec3 a = oldPos;
         vec3 b = curPos;
         vec2 midUV = curUV;

         for (int j = 0; j < BINARY_STEPS; j++) {
            vec3 mid = (a + b) * 0.5;
            midUV = view2uv(mid);

            float midDepth  = texture2D(depthtex0, midUV).x;
            float midZ = uv2view(midUV, midDepth).z;

            if (midDepth + 0.001 < depth) return vec4(0.0);

            if (-mid.z < -midZ) { a = mid; }
            else                { b = mid; }
         }

         return vec4(texture2D(colortex0, midUV).rgb,
                     getReflectionVignette(midUV) * fresnel);
      }

      oldPos = curPos;
   }

   return vec4(0.0);
}