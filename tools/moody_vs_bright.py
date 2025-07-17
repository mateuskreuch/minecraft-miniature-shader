from PIL import Image
import matplotlib.pyplot as plt
import numpy as np

moody = Image.open("tools/day_moody.png")
bright = Image.open("tools/day_bright.png")
moody_pixels = list(moody.getdata())
bright_pixels = list(bright.getdata())

x_data = []
y_data = []

for i, rgba in enumerate(moody_pixels):
   _, moody_g, _, _ = rgba
   _, bright_g, _, _ = bright_pixels[i]

   x = moody_g / 255.0
   diff = (bright_g - moody_g) / 255.0

   x_data.append(x)
   y_data.append(diff)

x_data = np.array(x_data)
y_data = np.array(y_data)
best_fit = np.poly1d(np.polyfit(x_data, y_data, 4))

print(best_fit)

def custom_fit(x):
   return 0.8494*x**4 + 0.9687*x**3 - 5.238*x**2 + 3.711*x - 0.2864

x_best_fit = np.linspace(min(x_data), max(x_data), 100)
y_best_fit = best_fit(x_best_fit)
x_custom_fit = np.linspace(min(x_data), max(x_data), 100)
y_custom_fit = custom_fit(x_best_fit)

plt.scatter(np.array(x_data), np.array(y_data), label='Data')
plt.plot(x_best_fit, y_best_fit, 'r-', label='Best Curve Fit')
plt.plot(x_custom_fit, y_custom_fit, 'y-', label='Miniature\'s Curve Fit')
plt.legend()
plt.xlabel('x')
plt.ylabel('y')
plt.title('Brightness Difference (Bright - Moody) Curve Fit')
plt.show()