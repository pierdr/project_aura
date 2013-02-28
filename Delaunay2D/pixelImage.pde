int pixelColor;
int imageScale = 50;
int cols;
int rows;
PImage myImage;

color selectedColor;
ArrayList allColors;

void setuppixelImage() {
  myImage = loadImage("arizona_350x500.jpg");
 // image (myImage, 0, 0);
//  cols = myImage.width/imageScale;
//  rows = myImage.height/imageScale;
  allColors = new ArrayList();
}

/////////////////////////////////////////////////////////////////////////

//color pixelate(PImage source) {
//  allColors.clear();
//  source.loadPixels();
//  for (int i = 0; i < rows; i++) {
//    for (int j = 0; j < cols; j++) {
//
//      int x = (j*imageScale);
//      int y = (i*imageScale);
//
//      color pixelColor = source.get(x, y);
//      allColors.add(pixelColor);
//
////      println (j + " " + i);
////      fill (pixelColor);
////noStroke();
////      rect (x, y, 50, 50);
//      //updatePixels();
//    }
//  }
//  
//  int loc = random;
//  selectedColor = pixels[loc];
//  return selectedColor;
//
////  fill(selectedColor);
////  rect(600, 125, 100, 100);
//}

/////////////////////////////////////////////////////////////////////////

int image_scale = 50;
color pixel_color(PImage img) {
  int c = img.width / image_scale;
  int r = img.height / image_scale;
  img.loadPixels();
  int x = (int)(random(0, c) * image_scale);
  int y = (int)(random(0, r) * image_scale);
  return img.get(x, y);
}

color findColor(int x,int y, int w, int h) {
x = floor(x);
y = floor(y);
w = floor(w);
h = floor(h);
PImage tmp = new PImage();
tmp = myImage.get(floor(x), floor(y), w, h);
//var meanTmp = 0;
int red = 0, green = 0, blue = 0;
for(int i = 0; i < (w * h); i++) {
red += (tmp.pixels[i] >> 16) & 0xFF;
green += (tmp.pixels[i] >> 8) & 0xFF;
blue += tmp.pixels[i] & 0xFF;
//meanTmp = (meanTmp / (i + 1)) + tmp.pixels.getPixel(i);
}

int colorStringTmp = color(floor(red / (width * height)) ,floor(green / (width * height)) , (floor(blue / (width * height))));

return colorStringTmp;

//console.log("(" + x + "," + y + ")", "(" + width + "," + height + ")", red, green, blue);
//sketch.pa.image(tmp, x, y);

}

/////////////////////////////////////////////////////////////////////////


//void mousePressed()
//{
//
//  println( mouseX + " " + mouseY );
//
//  int scaledMouseX = mouseX / imageScale;
//  int scaledMouseY = mouseY / imageScale;
//
//  println( scaledMouseX + " " + scaledMouseY );
//  println((scaledMouseX)+(scaledMouseY*10));
//  println(cols);
//
//  selectedColor = (color)(Integer) allColors.get((scaledMouseX)+ (scaledMouseY*10));
//}

/////////////////////////////////////////////////////////////////////////

