int pixelColor;
int imageScale = 50;
int cols;
int rows;
PImage myImage;

color selectedColor;
ArrayList allColors;

void setuppixelImage() {
  myImage = loadImage("arizona_350x500.jpg");
  allColors = new ArrayList();
}


int image_scale = 50;

color pixel_color(PImage img) {
  int c = img.width / image_scale;
  int r = img.height / image_scale;
  img.loadPixels();
  int x = (int)(random(0, c) * image_scale);
  int y = (int)(random(0, r) * image_scale);
  return img.get(x, y);
}

color findColor(int x, int y, int w, int h) {
  x = floor(x);
  y = floor(y);
  w = floor(w);
  h = floor(h);
  PImage tmp = new PImage();
  tmp = myImage.get(floor(x), floor(y), w, h);
  int red = 0, green = 0, blue = 0;
  for (int i = 0; i < (w * h); i++) {
    red += (tmp.pixels[i] >> 16) & 0xFF;
    green += (tmp.pixels[i] >> 8) & 0xFF;
    blue += tmp.pixels[i] & 0xFF;
  }

  int colorStringTmp = color(floor(red / (width * height)), floor(green / (width * height)), (floor(blue / (width * height))));

  return colorStringTmp;
}

