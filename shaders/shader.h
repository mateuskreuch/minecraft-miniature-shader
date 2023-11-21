#define NOON 0.25 // 6000
#define SUNSET 0.5325 // 12780
#define MIDNIGHT 0.75 // 18000
#define SUNRISE 0.9675 // 23220

const float NORMALIZE_TIME = 1.0/24000.0;
const vec2 AMBIENT_UV = vec2(8.0/255.0, 247.0/255.0);

#define CONTRAST 1.2 //[1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0]

const float INV_CONTRAST = 1.0/CONTRAST;

#define ENABLE_FOG
#define OVERWORLD_FOG_MAX_SLIDER 7 //[0 1 2 3 4 5 6 7 8 9 10]
#define OVERWORLD_FOG_MIN_SLIDER 0 //[0 1 2 3 4 5 6 7 8 9 10]
#define NETHER_FOG_SLIDER 10 //[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18]

const float OVERWORLD_FOG_MIN = 1.0 - 0.1*OVERWORLD_FOG_MAX_SLIDER;
const float OVERWORLD_FOG_MAX = 1.0 - 0.1*OVERWORLD_FOG_MIN_SLIDER;
const float NETHER_FOG = 2.0 - 0.1*NETHER_FOG_SLIDER;

// optifine needs this to show on menu
#ifdef ENABLE_FOG
#endif

#define IS_OPTIFINE

#ifdef gbuffers_textured_lit
   #define TORCH_R 1.0 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
   #define TORCH_G 0.8 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
   #define TORCH_B 0.6 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

   const vec2 TORCH_UV_SCALE = vec2(8.0/255.0, 231.0/255.0);
   const vec3 TORCH_COLOR = vec3(TORCH_R, TORCH_G, TORCH_B);


   #define SHADOW_PIXEL 16 //[0 4 8 16 32 64 128 256 512]
   #define SHADOW_BLUENESS 0.05 //[0.0 0.05 0.1 0.15 0.2]

   #ifdef IS_OPTIFINE
      #define MAX_SHADOW_SUBTRACT 0.0
   #else
      #define MAX_SHADOW_SUBTRACT -0.15
   #endif

   const float shadowDistance = 96.0; //[8.0 16.0 32.0 64.0 96.0 128.0 192.0 256.0 512.0 1024.0]
   const int shadowMapResolution = 1024; //[256 512 1024 2048 3072 4096]
   const float shadowIntervalSize = 15.0; //[1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 9.0 10.0 11.0 12.0 13.0 14.0 15.0 16.0]

   const float SHADOW_MAX_DIST_SQUARED = shadowDistance * shadowDistance;
   const float INV_SHADOW_MAX_DIST_SQUARED = 1.0/SHADOW_MAX_DIST_SQUARED;
   
   #define SHADOW_ENTITY
   #ifdef SHADOW_ENTITY
   #endif
#endif

#ifdef final
   #define REFLECTIONS 10 //[0 1 2 3 4 5 6 7 8 9 10]
#endif

#ifdef gbuffers_water
   #define WATER_MIN_TEXTURE 4 //[-1 0 1 2 3 4 5 6 7 8 9 10]
   #define WATER_WAVE_SPEED 2 //[1 2 3 4 5 6 7 8 9 10]

   #define WATER_BRIGHTNESS 0.3 //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
   #define WATER_B 1.2          //[1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0]
   #define WATER_A 0.7          //[0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#endif

#define WATER_WAVE_SIZE 1 //[0 1 2 3 4 5 6 7 8 9 10]

const float WATER_BANDING_MULT = 0.034 + (WATER_WAVE_SIZE/10.0)*0.06;
const float INV_WATER_BANDING_MULT = 1.0/WATER_BANDING_MULT;