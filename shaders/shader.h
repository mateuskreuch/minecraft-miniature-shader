const float NORMALIZE_TIME = 1.0/24000.0;

#define CONTRAST 1.2 //[1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0]

const float INV_CONTRAST = 1.0/CONTRAST;

#define TORCH_R 1.0 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define TORCH_G 0.8 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define TORCH_B 0.6 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

const vec3 TORCH_COLOR = vec3(TORCH_R, TORCH_G, TORCH_B);

#define NOON 0.25 // 6000
#define SUNSET 0.5325 // 12780
#define MIDNIGHT 0.75 // 18000
#define SUNRISE 0.9675 // 23220

#define SHADOW_BLUENESS 0.05 //[0.0 0.05 0.1 0.15 0.2]

#define OVERWORLD_FOG_MIN 0.3 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1]
#define OVERWORLD_FOG_MAX 1.0 //[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1]
#define NETHER_FOG 1.0 //[0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

#define IS_OPTIFINE

#ifdef IS_OPTIFINE
   #define MAX_SHADOW_SUBTRACT 0.0
#else
   #define MAX_SHADOW_SUBTRACT -0.15
#endif

#ifdef composite
   #define SHADOW_PIXEL 16 //[0 4 8 16 32 64 128 256 512]

   const float shadowDistance = 96.0; //[8.0 16.0 32.0 64.0 96.0 128.0 192.0 256.0]
   const int shadowMapResolution = 1024; //[256 512 1024 2048 3072 4096]

   const float SHADOW_MAX_DIST_SQUARED = shadowDistance * shadowDistance;
   const float INV_SHADOW_MAX_DIST_SQUARED = 1.0/SHADOW_MAX_DIST_SQUARED;
#endif

#ifdef final
   #define REFLECTIONS 10 //[0 1 2 3 4 5 6 7 8 9 10]

   #define MAX_RAYS 16
   #define MAX_REFINEMENTS 4
   #define RAY_MULT 2.0
   #define REFINEMENT_MULT 0.1
#endif

#ifdef gbuffers_water
   #define WATER_SHOW_SOME_TEXTURE
   #define WATER_MIRROR

   #define WATER_R 0.4  //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
   #define WATER_G 0.4  //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
   #define WATER_B 0.25 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
   #define WATER_A 0.6  //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

   const vec4 WATER_COLOR = vec4(WATER_R, WATER_G, WATER_B, WATER_A);
#endif