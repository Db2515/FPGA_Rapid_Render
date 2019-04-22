from PIL import Image, ImageColor
import sys

im = Image.new("RGBA", (1080, 2160), "black");

with open(sys.argv[1]) as file:
	for line in file:
		vars = line.strip().split(",");
		r = int(vars[2][6:8], 16);
		g = int(vars[2][4:6], 16);
		b = int(vars[2][2:4], 16);
		a = int(vars[2][0:2], 16);
		
		#print(vars[0], vars[1], vars[2], r, g, b, a);
		im.putpixel((int(vars[0]), int(vars[1])), (r,g,b,a));

im.save('screen.png');
		
