class ColorPicture {
  Color[] pixel = new Color[0];
  int pWidth;
  int pHeight;
  int pixelCount;

  ColorPicture(PImage image) {
    pWidth = image.width;
    pHeight = image.height;
    pixelCount = image.width*image.height;
    imageToArray();
  }
  void imageToArray() {
    pixel = new Color[pixelCount];
    image.loadPixels();
    for (int i = 0; i<pWidth*pHeight; i++) {
      color c = image.pixels[i];
      pixel[i] = new Color(int(red(c)), int(green(c)), int(blue(c)));
    }
  }

  //private int getX(int z) {//returns the x-coordinate in a picture with a given number in the pixel-array
  //  return z % pWidth;
  //}

  //private int getY(int z) {//returns the y-coordinate in a picture with a given number in the pixel-array
  //  return floor(z/pWidth);
  //}

  int length() {
    return pixelCount;
  }

  private int getZ(int x, int y) {//returns the number in a pixel-array of an Image with given x and y coordinates
    return x+y*pWidth;
  }
  Color getC(int z) {
    return pixel[z];
  }
  Color getC(int x, int y) { //returns the Color of a pixel in the ArrayList at specific x and y coordinates in a picture
    return pixel[getZ(x, y)];
  }

  void setC(Color c, int x, int y) {//sets the Color in the ArrayList of Colors at a specific x and y coordinate
    pixel[getZ(x, y)] = c;
    ;
  }
  void setC(Color c, int z) {
    pixel[z] = c;
  }

  PImage convertToImage() {//converts its ArrayList of Colors into an image and returns it
    PImage img = createImage(pWidth, pHeight, RGB);
    img.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
      img.pixels[i] = color(pixel[i].red, pixel[i].green, pixel[i].blue);
    }
    img.updatePixels();
    return img;
  }
}
