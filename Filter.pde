class Filter {

  Filter() {
  }

  PImage applyFilter(PImage img, float[][] matrix, float factor, int w, int h) {
    PImage img2 = img;
    try {
      img2.loadPixels();
      float red = 0;
      float green = 0;
      float blue = 0;
      for (int y = 0; y < img.height; y++) {
        for (int x = 0; x < img.width; x++) {
          red = 0;
          green = 0;
          blue = 0;
          for (int j = -w/2; j < h/2+1; j++) {
            for (int i = -w/2; i < w/2+1; i++) {
              int pX = x+i;
              int pY = y+i;
              if (pX>=img.width) {
                pX = x+i-((x+i) - (img.width-1));
              }
              if (pX<0) {
                pX = pX*-1;
              }
              if (pY>=img.height) {
                pY = y+j-((y+j) - (img.height-1));
              }
              if (pY<0) {
                pY = pY*-1;
              }
              red = red + red(img.pixels[getZ(pX, pY, img.width)])*matrix[i+(w/2)][j+(h/2)];
              green = green + green(img.pixels[getZ(pX, pY, img.width)])*matrix[i+(w/2)][j+(h/2)];
              blue = blue + blue(img.pixels[getZ(pX, pY, img.width)])*matrix[i+(w/2)][j+(h/2)];
            }
          }
          red = red * factor;
          green = green * factor;
          blue = blue * factor;
          Color c = new Color(color(red, green, blue));
          img2.pixels[getZ(x, y, img.width)] = color(c.red, c.green, c.blue);
        }
      }
      img2.updatePixels();
      img = img2;
      return img;
    }
    catch(Exception e) {
      println("[Filter[Filter]] Error while apllying a Filter on the image: "+e);
      return img;
    }
  }

  PImage blur(PImage img, int w, int h) {
    float[][] matrix = new float[w][h];
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        matrix[i][j] = 1;
      }
    }
    return applyFilter(img, matrix, 1f/(w*h), w, h);
  }

  PImage edges(PImage img) {
    int w = 3;
    int h = 3;
    float[][] matrix = new float[w][h];
    matrix[0][0] = -1;
    matrix[1][0] = -1;
    matrix[2][0] = -1;
    matrix[0][1] = -1;
    matrix[1][1] = 8;
    matrix[2][1] = -1;
    matrix[0][2] = -1;
    matrix[1][2] = -1;
    matrix[2][2] = -1;
    return applyFilter(img, matrix, 0.25f, w, h);
  }

  PImage sharpen(PImage img) {
    int w = 3;
    int h = 3;
    float[][] matrix = new float[w][h];
    matrix[0][0] = 0;
    matrix[1][0] = -1;
    matrix[2][0] = 0;
    matrix[0][1] = -1;
    matrix[1][1] = 4;
    matrix[2][1] = -1;
    matrix[0][2] = 0;
    matrix[1][2] = -1;
    matrix[2][2] = 0;
    return applyFilter(img, matrix, 1, w, h);
  }

  PImage relief(PImage img) {
    int w = 3;
    int h = 3;
    float[][] matrix = new float[w][h];
    matrix[0][0] = -2;
    matrix[1][0] = -1;
    matrix[2][0] = 0;
    matrix[0][1] = -1;
    matrix[1][1] = 1;
    matrix[2][1] = 1;
    matrix[0][2] = 0;
    matrix[1][2] = 1;
    matrix[2][2] = 2;
    return applyFilter(img, matrix, 1, w, h);
  }

  PImage Black_And_White(PImage img) {
    img.filter(GRAY);
    return img;
  }

  PImage Invert(PImage img) {
    img.filter(INVERT);
    return img;
  }

  PImage Rotate(PImage img) {
    PImage img2 = img;
    img = new PImage(img.height, img.width);
    img2.loadPixels();
    img.loadPixels();
    for (int y = 0; y < img2.height; y++) {
      for (int x = 0; x < img2.width; x++) {
        img.pixels[x+img2.width*y] = img2.pixels[(img2.height-y-1)+img2.height*x];
      }
    }
    img.updatePixels();
    return img;
  }

  PImage Mirror_v(PImage img) {
    PImage img2 = img;
    img = new PImage(img.width, img.height);
    img2.loadPixels();
    img.loadPixels();
    for (int y = 0; y < img2.height; y++) {
      for (int x = 0; x < img2.width; x++) {
        img.pixels[x+img2.width*y] = img2.pixels[img2.width*y+(img2.width-1-x)];
      }
    }
    img.updatePixels();
    return img;
  }

  PImage Mirror_h(PImage img) {
    PImage img2 = img;
    img = new PImage(img.width, img.height);
    img2.loadPixels();
    img.loadPixels();
    for (int y = 0; y < img2.height; y++) {
      for (int x = 0; x < img2.width; x++) {
        img.pixels[x+img2.width*y] = img2.pixels[x+img2.width*(img2.height-1-y)];
      }
    }
    img.updatePixels();
    return img;
  }

  private int getZ(int x, int y, int pWidth) {
    return x+y*pWidth;
  }
}
