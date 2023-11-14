#if REFLECTIONS > 0

#define MAX_RAYS 16
#define MAX_REFINEMENTS 4
#define RAY_MULT 2.0
#define REFINEMENT_MULT 0.1

if (isReflective(texcoord)) {
   float depth = texture2D(depthtex0, texcoord).x;

   // the normal doesn't come premultiplied by the normal matrix to
   // avoid the modelview transformations when view bobbing is on
   // which causes severe artifacts when moving
   vec3 prenormal = texture2D(colortex6, texcoord).xyz*2.0 - 1.0;

   #if WATER_WAVE_SIZE > 0

   prenormal.xz *= 0.01 * INV_WATER_BANDING_MULT * WATER_WAVE_SIZE;

   #endif

   vec3 normal  = world2screen(prenormal);
   vec3 fragPos = uv2screen(texcoord, depth);

   vec4 reflectionColor = vec4(0.0);
   vec3 reflection = normalize(reflect(fragPos, normal));
   vec3 curPos = fragPos + reflection;
   vec3 oldPos = fragPos;

   int j = 0;
   
   for (int _ = 0; _ < MAX_RAYS; _++) {
      vec2 curUV = screen2uv(curPos);

      if (curUV.s < 0.0 || curUV.s > 1.0 || curUV.t < 0.0 || curUV.t > 1.0)
         break;
      
      vec3 sample = uv2screen(curUV, texture2D(depthtex0, curUV).x);
      float dist  = abs(curPos.z - sample.z);
      float len   = squaredLength(reflection);

      // check if distance between last and current depth is
      // smaller than the current length of the reflection vector
      // the numbers are trial and error to produce less distortion
      if (dist*dist < 2.0*len * exp(0.03*len) && !isReflective(curUV)) {
         j++;

         if (j >= MAX_REFINEMENTS) {
            // fade reflection with vignette
            vec2 vignette = curUV;

            vignette.y = 1.0 - vignette.y;
            vignette.x *= 1.0 - vignette.x;

            reflectionColor = vec4(
               texture2D(colortex0, curUV).rgb,
               1.0 - pow(1.0 - vignette.x, 50.0*vignette.y*vignette.y)
            );
            break;
         }

         curPos = oldPos;
         reflection *= REFINEMENT_MULT;
      }

      reflection *= RAY_MULT;
      oldPos = curPos;
      curPos += reflection;
   }
   
   // also fade reflection with fresnel
   float fresnel = 1.0 - dot(normal, -normalize(fragPos));

   vec3 c = mix(color.rgb, reflectionColor.rgb, reflectionColor.a * fresnel * 0.1*REFLECTIONS * (1.0 - color.rgb));

   color.rgb = mix(c, fogColor * vec3(fresnel), pow(fresnel, 192.0));
}

#endif