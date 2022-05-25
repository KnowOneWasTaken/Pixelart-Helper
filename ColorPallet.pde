class ColorPallet {
  Color[] colors = new Color[0];
  color[] pallet = new color[0];
  int displayX, displayY, displayW, displayH;
  int colorPicked = 0;
  float colorWidth;
  float colorHeight;

  boolean isOneColorSelected = false; //represents if a color of the pallet is picked or not
  boolean isVertically;

  ColorPallet() {
  }

  ColorPallet(Color[] col, int x, int y, int w, int h, boolean isVertically) {
    pallet = new color[col.length];
    for (int i = 0; i < col.length; i++) {
      pallet[i] = color(col[i].red, col[i].green, col[i].blue);
      colors = col;
    }
    this.displayX = x;
    this.displayY = y;
    this.displayW = w;
    this.displayH = h;
    this.isVertically = isVertically;
    if (isVertically) {
      colorWidth = w;
      colorHeight = ((displayH*1f)/(pallet.length*1f));
    } else {
      colorWidth = ((displayW*1f)/(pallet.length*1f));
      colorHeight = h;
    }
  }

  color getPickedColor() {
    if (isOneColorSelected) {
      return pallet[colorPicked];
    } else {
      return color(0, 0, 0, 255);
    }
  }

  void display() {
    if (pallet.length!=0) {
      if (isVertically) {
        float heightOne = displayH/(pallet.length);
        for (int i = 0; i < pallet.length; i++) {
          noStroke();
          fill(pallet[i]);
          rect(displayX, displayY+i*heightOne, displayW, heightOne);
        }
      } else {
        float widthOne = (displayW*1f)/(pallet.length*1f);
        for (int i = 0; i < pallet.length; i++) {
          noStroke();
          fill(pallet[i]);
          rect(displayX+i*widthOne, displayY, widthOne, displayH);
        }
      }
    }
  }

  void clearPallet() {
    pallet = new color[0];
    colors = new Color[0];
  }

  boolean inPallet(int x, int y) {
    if (x>=displayX && x <= displayX+ displayW && y>=displayY && y <= displayY+ displayH) {
      return true;
    } else {
      return false;
    }
  }

  void calculateColorPicked(int x, int y) {
    if (inPallet(x, y)) {
      isOneColorSelected = true;
      if (isVertically) {
        if (colorPicked != floor((y-displayY)/colorHeight)) {
          colorPicked = floor((y-displayY)/colorHeight);
        } else {
          colorPicked = 0;
          isOneColorSelected = false;
        }
      } else {
        if (colorPicked != floor((x-displayX)/colorWidth)) {
          colorPicked = floor((x-displayX)/colorWidth);
        } else {
          colorPicked = 0;
          isOneColorSelected = false;
        }
      }
    } else {
      if ((isOneColorSelected && isInImage()) || (touchGUI && isOneColorSelected)) {
        isOneColorSelected = true;
      } else {
        isOneColorSelected = false;
      }
    }
  }

  void displaySelected() {
    if (isOneColorSelected) {
      fill(15, 15, 15, 80);
      stroke(80, 200, 255);
      strokeWeight(3);
      if (!isVertically) {
        rect(displayX+colorPicked*colorWidth, displayY, colorWidth, displayH);
      } else {
        rect(displayX, displayY+colorPicked*colorHeight, displayW, colorHeight);
      }
    }
  }

  void deleteColor(int z) {
    Color[] cl = colors;
    color[] pl = pallet;
    if (pallet.length > 0) {
      colors = new Color[pallet.length-1];
    } else {
      colors = new Color[0];
    }
    pallet = new color[colors.length];
    for (int i = 0; i < pallet.length; i++) {
      if (i>=z) {
        colors[i] = cl[i+1];
        pallet[i] = pl[i+1];
      } else {
        colors[i] = cl[i];
        pallet[i] = pl[i];
      }
      isOneColorSelected = false;
      if (isVertically) {
        colorWidth = displayW;
        colorHeight = ((displayH*1f)/(pallet.length*1f));
      } else {
        colorWidth = ((displayW*1f)/(pallet.length*1f));
        colorHeight = displayH;
      }
    }
  }

  void addColor(Color c) {
    Color[] cl = colors;
    color[] pl = pallet;
    colors = new Color[pallet.length+1];
    pallet = new color[colors.length];
    for (int i = 0; i < pallet.length-1; i++) {
      colors[i] = cl[i];
      pallet[i] = pl[i];
    }
    colors[colors.length-1] = c;
    pallet[pallet.length-1] = c.getColor();
    if (isVertically) {
      colorHeight = ((displayH*1f)/(pallet.length*1f));
    } else {
      colorWidth = ((displayW*1f)/(pallet.length*1f));
    }
  }

  void addColors(Color[] c) {
    Color[] cl = colors;
    color[] pl = pallet;
    colors = new Color[pallet.length+c.length];
    pallet = new color[colors.length];
    for (int i = 0; i < pallet.length-c.length; i++) {
      colors[i] = cl[i];
      pallet[i] = pl[i];
    }
    for (int i = colors.length-c.length; i < colors.length-1; i++) {
      colors[i] = c[i-(colors.length-c.length)];
      pallet[i] = c[i-(colors.length-c.length)].getColor();
    }

    if (isVertically) {
      colorHeight = ((displayH*1f)/(pallet.length*1f));
    } else {
      colorWidth = ((displayW*1f)/(pallet.length*1f));
    }
  }
}
