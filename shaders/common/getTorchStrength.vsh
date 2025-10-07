float getTorchStrength(float torchLight) {
   return rescale(torchLight, TORCH_UV_SCALE.x, TORCH_UV_SCALE.y);
}