// x = reflectivity (0-0.99), 0-0.5 are pixelated reflections and 0.5-0.99 are mirror-like reflections
// y = reflection min luma (0-0.99)
// z = reflection max luma (0-0.99)
const vec3 BLOCK_REFLECTIVITY[19] = vec3[](
   vec3(0.0),              // default
   vec3(0.15, 0.05, 0.40), // cauldron and anvil
   vec3(0.15, 0.08, 0.40), // deepslate tiles
   vec3(0.15, 0.10, 0.55), // deepslate bricks
   vec3(0.15, 0.25, 0.60), // polished tuff
   vec3(0.15, 0.35, 0.65), // stone bricks blocks
   vec3(0.20, 0.09, 0.40), // polished blackstone and blackstone bricks
   vec3(0.20, 0.10, 0.55), // polished deepslate
   vec3(0.20, 0.30, 0.70), // waxed copper blocks
   vec3(0.20, 0.30, 0.71), // copper blocks
   vec3(0.35, 0.35, 0.99), // cobblestone blocks
   vec3(0.40, 0.25, 0.99), // polished granite
   vec3(0.40, 0.30, 0.99), // polished andesite
   vec3(0.40, 0.62, 0.99), // polished diorite
   vec3(0.49, 0.35, 0.85), // iron bars
   vec3(0.49, 0.50, 0.99), // blue ice
   vec3(0.49, 0.57, 0.99), // packed ice
   vec3(0.60, 0.00, 0.01), // ore blocks
   vec3(0.70, 0.00, 0.01)  // quartz blocks
);