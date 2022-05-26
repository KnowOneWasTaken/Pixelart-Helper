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

  private void removeLast(int z) {
    Color[] cl = colors;
    color[] pl = pallet;
    colors = new Color[colors.length-z];
    pallet = new color[colors.length];
    for (int i = 0; i < colors.length; i++) {
      colors[i] = cl[i];
      pallet[i] = pl[i];
    }
  }

  private void removeLast() {
    removeLast(1);
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

  private boolean isInPallet(Color c) {
    for (int i = 0; i < colors.length; i++) {
      if (colors[i].equalsTo(c)) {
        return true;
      }
    }
    return false;
  }

  private boolean arrayContainsC(Color c, Color[] cols) {
    for (Color c2 : cols) {
      if (c2.equalsTo(c)) {
        return true;
      }
    }
    return false;
  }

  void addColors(Color[] c) {
    Color[] cl = colors;
    color[] pl = pallet;
    colors = new Color[colors.length+c.length];
    pallet = new color[colors.length];
    int z = 0;
    for (int i = 0; i < cl.length; i++) {
      if (!arrayContainsC(cl[i], c)) {
        colors[z] = cl[i];
        pallet[z] = pl[i];
        z++;
      }
    }
    if (z<cl.length) this.removeLast(cl.length-z);
    for (int i = z; i < colors.length; i++) {
      colors[i] = c[i-z];
      pallet[i] = c[i-z].getColor();
    }
    if (isVertically) {
      colorHeight = ((displayH*1f)/(pallet.length*1f));
    } else {
      colorWidth = ((displayW*1f)/(pallet.length*1f));
    }
  }

  void addTable(Table t) {
    Color[] cols = new Color[t.getRowCount()];
    int i = 0;
    for (TableRow r : t.rows()) {
      cols[i] = new Color(r.getInt("red"), r.getInt("green"), r.getInt("blue"));
      i++;
    }
    addColors(cols);
  }

  //creates a Color-Pallet with an Image, saves it in "color pallets/image-pallet.csv" and then loads it
  void loadPalletWithImage(PImage img) {
    Table t = new Table();
    t.addColumn("red");
    t.addColumn("green");
    t.addColumn("blue");
    img.loadPixels();
    for (Color c : Pallet.colors) {
      TableRow r = t.addRow();
      r.setInt("red", c.red);
      r.setInt("green", c.green);
      r.setInt("blue", c.blue);
    }
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        color c = img.get(i, j);
        TableRow r = t.addRow();
        r.setInt("red", int(red(c)));
        r.setInt("green", int(green(c)));
        r.setInt("blue", int(blue(c)));
      }
    }
    saveTable(t, "color pallets/image-pallet.csv");
    addTable(t);
    println("[loadPalletWithImage] Imported Pallet out of Image-File");
  }

  void loadPallet(String s) {//loads the Color-pallet and stores it in a Array of Colors (Color[] colors) //marker
    //loads Pallet of an Image if it is .png or .jpg
    if (s.substring(s.length()-4, s.length()).equals(".png") || s.substring(s.length()-4, s.length()).equals(".jpg")) {
      PImage img = null;
      try {
        img = loadImage(s);

        if (img == null) {
          img = loadImage("color pallets/"+s);
        }
      }
      catch(Exception e) {
        println("[loadPallet] Error while loading Image to make a .csv-file out of it!");
      }
      if (img != null) {
        loadPalletWithImage(img);
      } else {
        println("[loadPallet] Error: no Image found!");
      }
    }

    //loads a pallet of a csv file, if it fails, it generates a empty one and loads it
    else {
      try {
        Table t = loadTable("/color pallets/"+s, "header");
        Pallet.addTable(t);
        Pallet = new ColorPallet(Pallet.colors, 0, height-int(GUIScaleH*80), width, int(GUIScaleW*30), false);
        println("Pallet successfully loaded: "+s);
        GUIDebug = "Successfully loaded Pallet: "+s;
        DebugC = color(0, 255, 0);
      }

      //prints Error-message and loads an empty color-pallet after it creates it
      catch(Exception e) {
        if (s !="empty-color-pallet.csv") {
          println("Error while loading Color-Pallet named: "+s + " | Error: "+e);
          Table t = new Table();
          t.addColumn("red");
          t.addColumn("green");
          t.addColumn("blue");
          saveTable(t, "color pallets/empty-color-pallet.csv");
          loadPallet("empty-color-pallet.csv");
          GUIDebug = "Error while loading Pallet: "+s;
          DebugC = color(255, 0, 0);
        } else {
          GUIDebug = "Error while loading Pallet: "+s;
          DebugC = color(255, 0, 0);
          println("Error while loading empty Color-Pallet: "+e);
        }
      }
    }
  }
  
  //saves the current Pallet into a .csv file with the name 's' in /color pallets/
void savePallet(String s, ColorPallet p, PImage img) {
  Table t = new Table();
  t.addColumn("red");
  t.addColumn("green");
  t.addColumn("blue");
  img.loadPixels();
  for (int i = 0; i < p.pallet.length; i++) {
    TableRow r = t.addRow();
    r.setInt("red", int(red(p.pallet[i])));
    r.setInt("green", int(green(p.pallet[i])));
    r.setInt("blue", int(blue(p.pallet[i])));
  }
  saveTable(t, "color pallets/"+s+".csv");
  DebugC = color(0, 255, 0);
  GUIDebug ="Successfully saved Pallet: "+"color pallets/"+s+".csv";
  println("Successfully saved Pallet: "+"color pallets/"+s+".csv");
}
}
