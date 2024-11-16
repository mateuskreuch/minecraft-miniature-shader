#define MAX_RAYS 16
#define MAX_REFINEMENTS 4
#define RAY_MULT 2.0
#define REFINEMENT_MULT 0.1

vec2 getReflectionUV(float depth, vec3 normal, vec3 fragPos) {
   vec3 reflection = normalize(reflect(fragPos, normal));
   vec3 curPos = fragPos + reflection;
   vec3 oldPos = fragPos;
   int j = 0;

   for (int _ = 0; _ < MAX_RAYS; _++) {
      vec2 curUV = screen2uv(curPos);

      if (curUV.s < 0.0 || curUV.s > 1.0 || curUV.t < 0.0 || curUV.t > 1.0)
         break;

      float sampleDepth = texture2D(depthtex0, curUV).x;
      vec3  samplePos   = uv2screen(curUV, sampleDepth);
      float dist        = abs(curPos.z - samplePos.z);
      float len         = squaredLength(reflection);

      // check if distance between last and current depth is
      // smaller than the current length of the reflection vector
      // the numbers are trial and error to produce less distortion
      if (dist*dist < 2.0*len * exp(0.03*len) && !(texture2D(colortex7, curUV).x > 0.99)) {
         j++;

         if (j >= MAX_REFINEMENTS && sampleDepth + 0.001 >= depth) {
            return curUV;
         }

         curPos = oldPos;
         reflection *= REFINEMENT_MULT;
      }

      reflection *= RAY_MULT;
      oldPos = curPos;
      curPos += reflection;
   }
}