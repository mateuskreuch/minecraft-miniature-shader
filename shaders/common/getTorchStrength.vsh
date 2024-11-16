float getTorchStrength(float torchLight) {
   return 1.1*rescale(torchLight, TORCH_UV_SCALE.x, TORCH_UV_SCALE.y);
}