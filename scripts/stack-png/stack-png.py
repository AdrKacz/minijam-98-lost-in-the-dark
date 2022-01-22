import sys
from PIL import Image

images = [Image.open(x) for x in ['spark_06.png'] * 10]
widths, heights = zip(*(i.size for i in images))

max_width = max(widths)
total_height = sum(heights)

new_im = Image.new('RGB', (max_width, total_height))

y_offset = 0
for im in images:
  new_im.paste(im, (0,y_offset))
  y_offset += im.size[1]

new_im.save('spark_06_1.png')