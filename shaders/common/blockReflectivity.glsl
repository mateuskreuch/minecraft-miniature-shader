// x = reflection strength  (0-1)
// y = reflection min luma  (0-1)
// z = reflection roughness (0-1)
const vec3 BLOCK_REFLECTIVITY[18] = vec3[](
   vec3(0.0),              // default
   vec3(0.60, 0.05, 0.07), // cauldron and anvil
   vec3(0.60, 0.10, 0.11), // deepslate bricks
   vec3(0.40, 0.15, 0.15), // polished tuff
   vec3(0.80, 0.35, 0.11), // stone bricks blocks
   vec3(0.70, 0.05, 0.15), // polished blackstone and blackstone bricks
   vec3(0.70, 0.10, 0.07), // polished deepslate
   vec3(0.65, 0.30, 0.07), // waxed copper blocks
   vec3(0.65, 0.30, 0.07), // copper blocks
   vec3(0.50, 0.35, 0.07), // cobblestone blocks
   vec3(0.60, 0.20, 0.07), // polished granite
   vec3(0.60, 0.20, 0.07), // polished andesite
   vec3(0.60, 0.45, 0.07), // polished diorite
   vec3(1.00, 0.35, 0.12), // iron bars
   vec3(0.70, 0.50, 0.07), // blue ice
   vec3(0.60, 0.40, 0.07), // packed ice
   vec3(0.20, 0.00, 0.04), // ore blocks
   vec3(0.10, 0.00, 0.05)  // quartz blocks
);