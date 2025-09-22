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
   float grazingEpsilon = rescale(1.0 - abs(dot(R, normal)), 0.95, 1.0);
   float invR = 1.0 / abs(R.z);
   float invFar = 1.0 / (2.0*far);
   float lengthR = 1.0;
   vec3 oldPos = viewPos;

   for (int i = 0; i < SSR_MAX_STEPS; i++) {
      vec3 curPos = viewPos + R * lengthR;
      vec2 curUV  = view2uv(curPos);

      if (curUV.s < 0.0 || curUV.s > 1.0 || curUV.t < 0.0 || curUV.t > 1.0)
         break;

      float sceneDepth = texture2D(depthtex0, curUV).x;
      float sceneZ = uv2view(curUV, sceneDepth).z;
      float distanceEpsilon = clamp(abs(sceneZ) * invFar, 0.0, 1.0);
      float epsilon = 1.0 + 0.1*max(distanceEpsilon, grazingEpsilon);
      float diffZ = curPos.z - sceneZ * epsilon;

      if (diffZ < 0.0) {
         vec3 a = oldPos;
         vec3 b = curPos;

         for (int j = 0; j < SSR_BINARY_STEPS; j++) {
            vec3 mid = (a + b) * 0.5;

            curUV = view2uv(mid);
            sceneDepth = texture2D(depthtex0, curUV).x;
            sceneZ = uv2view(curUV, sceneDepth).z;

            if (sceneDepth + 0.001 <= depth) return vec4(0.0);

            if (-mid.z < -sceneZ) { a = mid; }
            else                  { b = mid; }
         }

         return vec4(texture2D(colortex0, curUV).rgb,
                     getReflectionVignette(curUV) * fresnel);
      }

      oldPos = curPos;
      lengthR += max(SSR_STEP_SIZE * abs(diffZ) * invR, 1.0);
   }

   return vec4(0.0);
}