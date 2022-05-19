class Filter {

  Filter() {
  }

  PImage applyFilter(PImage img, int[][] matrix, float factor, int w, int h) {
    try {
      img.loadPixels();
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
              red = red + red(img.pixels[getZ(pX, pY, img.width)]*matrix[i+(w/2)][j+(h/2)]);
              green = green + green(img.pixels[getZ(pX, pY, img.width)]*matrix[i+(w/2)][j+(h/2)]);
              blue = blue + blue(img.pixels[getZ(pX, pY, img.width)]*matrix[i+(w/2)][j+(h/2)]);
            }
          }
          red = red * factor;
          green = green * factor;
          blue = blue * factor;
          img.pixels[getZ(x, y, img.width)] = color(red, green, blue);
        }
      }
      img.updatePixels();
      return img;
    }
    catch(Exception e) {
      println("[Filter[Filter]] Error while apllying a Filter on the image: "+e);
      return img;
    }
  }

  PImage blur(PImage img, int w, int h) {
    int[][] matrix = new int[w][h];
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
    int[][] matrix = new int[w][h];
    matrix[0][0] = -1;
    matrix[1][0] = -1;
    matrix[2][0] = -1;
    matrix[0][1] = -1;
    matrix[1][1] = 4;
    matrix[2][1] = -1;
    matrix[0][2] = -1;
    matrix[1][2] = -1;
    matrix[2][2] = -1;
    return applyFilter(img, matrix, 0.25f, w, h);
  }

  private int getZ(int x, int y, int pWidth) {
    return x+y*pWidth;
  }
}
