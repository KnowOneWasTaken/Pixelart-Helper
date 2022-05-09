class Color { //Class with 3 integer values that describe red, green and blue of a color (RGB)
  int red;
  int green;
  int blue;
  Color(int red, int green, int blue) {
    this.red = red;
    this.green = green;
    this.blue = blue;
    maxMin();
  }

  Color() {//initilizer without any parameters: default Color is black
    this.red = 0;
    this.green = 0;
    this.blue = 0;
    maxMin();
  }

  color getColor() {
    return color(red, green, blue, RGB);
  }

  private void maxMin() { //sets the RGB-values in the RGB-range, if they are higher than 255 or lower than 0
    if (red > 255) {
      red = 255;
    }
    if (green > 255) {
      green = 255;
    }
    if (blue > 255) {
      blue = 255;
    }
    if (red < 0) {
      red = 0;
    }
    if (green < 0) {
      green = 0;
    }
    if (blue < 0) {
      blue = 0;
    }
  }

  //returns the values of R,G, and B (red,green,blue)
  int getRed() {
    return red;
  }
  int getGreend() {
    return green;
  }
  int getBlue() {
    return blue;
  }
}