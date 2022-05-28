class ColorPallet {
  Color[] colors = new Color[0];
  color[] pallet = new color[0];
  int displayX, displayY, displayW, displayH;
  int colorPicked = -1;
  float colorWidth;
  float colorHeight;
  String threadLoad ="";
  PImage threadLoadImage = new PImage();

  boolean isOneColorSelected = false; //represents if a color of the pallet is picked or not
  boolean isVertically;

  ColorPallet() {
  }

  ColorPallet(Color[] col, int x, int y, int w, int h, boolean isVertically) {
    pallet = new color[col.length];
    for (int i = 0; i < col.length; i++) {
      pallet[i] = color(col[i].red, col[i].green, col[i].blue, col[i].alpha);
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
    println("[ColorPallet] [clearPallet] Pallet cleard!");
    autoSave("auto save/last_session.csv");
    isOneColorSelected = false;
    colorPicked = -1;
  }

  boolean inPallet(int x, int y) {
    if (x>=displayX && x <= displayX+ displayW && y>=displayY && y <= displayY+ displayH) {
      return true;
    } else {
      return false;
    }
  }

  void calculateColorPicked(int x, int y) {
    if (colors.length > 0) {
      if (inPallet(x, y)) {
        isOneColorSelected = true;
        if (isVertically) {
          if (colorPicked != floor((y-displayY)/colorHeight)) {
            colorPicked = floor((y-displayY)/colorHeight);
          } else {
            colorPicked = -1;
            isOneColorSelected = false;
          }
        } else {
          if (colorPicked != floor((x-displayX)/colorWidth)) {
            colorPicked = floor((x-displayX)/colorWidth);
          } else {
            colorPicked = -1;
            isOneColorSelected = false;
          }
        }
      } else {
        if ((isOneColorSelected && isInImage()) || (touchGUI && isOneColorSelected)) {
          isOneColorSelected = true;
        } else {
          colorPicked = -1;
          isOneColorSelected = false;
        }
      }
    } else {
      colorPicked = -1;
      isOneColorSelected = false;
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
    println("[ColorPallet] [clearPallet] Color deleted: "+z);
    autoSave("auto save/last_session.csv");
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

  Color getColorString(String s) {
    try {
      s = s.toLowerCase();
      s = s.trim();
      String red  = "";
      String green = "";
      String blue = "";
      int redValue = 0;
      int greenValue = 0;
      int blueValue = 0;

      if (s.length() < 12 && s.length() != 4 && s.length() > 0) {
        if (s.indexOf(";") != -1) {

          if (s.substring(0, s.indexOf(";")).length() > 0) {
            red = s.substring(0, s.indexOf(";"));
            if (!isNumber(red)) {
              red = "0";
            }
          } else {
            red = "0";
          }

          String gNb = s.substring(s.indexOf(";")+1);
          if (gNb.indexOf(";") != -1) {
            if (gNb.substring(0, gNb.indexOf(";")).length() > 0) {
              green = gNb.substring(0, gNb.indexOf(";"));
              if (!isNumber(green)) {
                green = "0";
              }
            } else {
              green = "0";
            }

            if (gNb.substring(gNb.indexOf(";")+1).length() > 0) {
              blue = gNb.substring(gNb.indexOf(";")+1);
              if (!isNumber(blue)) {
                blue = "0";
              }
            } else {
              blue = "0";
            }
          } else {
            green = "0";
            blue = "0";
          }
        } else {
          if (s.length() > 0 && s.length() <4) {
            if (isNumber(s)) {
              red = s;
              green = s;
              blue = s;
            } else {
              return new Color(0, 0, 0);
            }
          } else {
            return new Color(0, 0, 0);
          }
        }
        redValue = Integer.parseInt(red);
        greenValue = Integer.parseInt(green);
        blueValue = Integer.parseInt(blue);
        return new Color(redValue, greenValue, blueValue);
      } else {
        return new Color(0, 0, 0);
      }
    }
    catch(Exception e) {
      println("[ColorPallet] [getColorString] Error while calculating Color with String: "+e);
      return new Color(0, 0, 0);
    }
  }

  boolean isNumber(String s) {
    if (s.length() == 1) {
      if (s.equals("0") || s.equals("1") || s.equals("2") || s.equals("3") || s.equals("4") || s.equals("5") || s.equals("6") || s.equals("7") || s.equals("8") || s.equals("9")) {
        return true;
      } else {
        return false;
      }
    } else {
      boolean isInt = true;
      for (int i = 0; i < s.length(); i++) {
        if (!isNumber(s.substring(i, i+1))) {
          isInt = false;
        }
      }
      return isInt;
    }
  }

  void addColor(String s) {
    addColor(getColorString(s));
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
    autoSave("auto save/last_session.csv");
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
    //c = deleteDoubles(c);
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

  Color[] deleteDoubles(Color[] cols) {
    int deleted = 0;
    for (int i = 0; i < cols.length; i++) {
      for (int j = 0; j < i; j++) {
        if (cols[i].red == cols[j].red && cols[i].green == cols[j].green && cols[i].blue == cols[j].blue) {
          cols[j] = null;
          deleted++;
        }
      }
    }
    Color[] cols2 = new Color[cols.length-deleted];
    int z = 0;
    for (int i = 0; i < cols.length; i++) {
      if (cols[i] != null) {
        cols2[z] = cols[i];
        z++;
      }
    }
    return cols2;
  }

  void addTable(Table t) {
    Color[] cols = new Color[t.getRowCount()];
    int i = 0;
    for (TableRow r : t.rows()) {
      cols[i] = new Color(r.getInt("red"), r.getInt("green"), r.getInt("blue"));
      i++;
    }
    addColors(cols);
    autoSave("auto save/last_session.csv");
  }

  //creates a Color-Pallet with an Image, saves it in "color pallets/image-pallet.csv" and then loads it
  void loadPalletWithImage(PImage img) {
    Table t = new Table();
    t.addColumn("red");
    t.addColumn("green");
    t.addColumn("blue");
    img.loadPixels();
    for (Color c : colors) {
      TableRow r = t.addRow();
      r.setInt("red", c.red);
      r.setInt("green", c.green);
      r.setInt("blue", c.blue);
    }
    for (int i = 0; i < img.width; i++) {
      for (int j = 0; j < img.height; j++) {
        boolean isDouble = false;
        color c = img.get(i, j);
        for (TableRow  r : t.rows()) {
          if (r.getInt("red") == red(c) && r.getInt("green") == green(c) && r.getInt("blue") == blue(c)) {
            isDouble = true;
          }
        }
        if (isDouble == false) {
          TableRow r = t.addRow();
          r.setInt("red", int(red(c)));
          r.setInt("green", int(green(c)));
          r.setInt("blue", int(blue(c)));
        }
      }
    }
    saveTable(t, "color pallets/image-pallet.csv");
    addTable(t);
    println("[ColorPallet] [loadPalletWithImage] Imported Pallet out of Image-File");
    GUIDebug = "Imported Pallet out of Image-File";
    DebugC = color(0, 255, 0);
    autoSave("auto save/last_session.csv");
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
        println("[ColorPallet] [loadPallet] Error while loading Image to make a .csv-file out of it!");
        GUIDebug = "Error while loading image for Pallet";
        DebugC = color(255, 0, 0);
      }
      if (img != null) {
        loadPalletWithImage(img);
      } else {
        println("[ColorPallet] [loadPallet] Error: no Image found!");
      }
    }

    //loads a pallet of a csv file, if it fails, it generates a empty one and loads it
    else {
      try {
        Table t = loadTable("/color pallets/"+s, "header");
        addTable(t);
        println("[ColorPallet] [loadPallet] Pallet successfully loaded: "+s);
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
  void savePallet(String s) {
    Table t = new Table();
    t.addColumn("red");
    t.addColumn("green");
    t.addColumn("blue");
    for (int i = 0; i < pallet.length; i++) {
      TableRow r = t.addRow();
      r.setInt("red", int(red(pallet[i])));
      r.setInt("green", int(green(pallet[i])));
      r.setInt("blue", int(blue(pallet[i])));
    }
    saveTable(t, "color pallets/"+s+".csv");
    DebugC = color(0, 255, 0);
    GUIDebug ="Successfully saved Pallet: "+"color pallets/"+s+".csv";
    println("Successfully saved Pallet: "+"color pallets/"+s+".csv");
  }

  Table getTable() {
    Table t = new Table();
    t.addColumn("red");
    t.addColumn("green");
    t.addColumn("blue");
    for (int i = 0; i < pallet.length; i++) {
      TableRow r = t.addRow();
      r.setInt("red", int(red(pallet[i])));
      r.setInt("green", int(green(pallet[i])));
      r.setInt("blue", int(blue(pallet[i])));
    }
    return t;
  }

  void autoSave(String s) {
    saveTable(getTable(), savePath(s));
  }

  void sortColors() {
    float[] values = new float[colors.length];
    int[] positions = new int[colors.length];
    for (int i = 0; i < colors.length; i++) {

      //values[i] = colors[i].red*1 + 10 * colors[i].green + 100 * colors[i].blue;
      //values[i] = brightness(colors[i].getColor());
      //values[i] = -colors[i].red+colors[i].blue-colors[i].green/2+brightness(pallet[i])/2;
      //values[i] = -colors[i].red+colors[i].blue+colors[i].green/2+brightness(pallet[i])/2;
      //values[i] = -colors[i].red+colors[i].blue+brightness(pallet[i])/2;
      values[i] = -sqrt(pow(colors[i].red-255, 2)+pow(colors[i].green, 2)+pow(colors[i].blue, 2)); //+sqrt(pow(colors[i].red, 2)+pow(colors[i].green, 2)+pow(colors[i].blue-255, 2))
      positions[i] = i;
    }
    for (int i = 0; i < colors.length-1; i++) {
      for (int j = 0; j < colors.length-1; j++) {
        if (values[j]<values[j+1]) {
          int pos1 = positions[j];
          int pos2 = positions[j+1];
          float value1 = values[j];
          float value2 = values[j+1];
          values[j] = value2;
          values[j+1] = value1;
          positions[j] = pos2;
          positions[j+1] = pos1;
        }
      }
    }
    Color[] cols = new Color[colors.length];
    color[] pal = new color[colors.length];

    for (int i = 0; i < colors.length; i++) {
      cols[i] = new Color(colors[i].red, colors[i].green, colors[i].blue);
      pal[i] = color(colors[i].red, colors[i].green, colors[i].blue);
    }
    for (int i = 0; i < colors.length; i++) {
      colors[i] = cols[positions[i]];
      pallet[i] = pal[positions[i]];
    }
    autoSave("auto save/last_session.csv");
    DebugC = color(0, 255, 0);
    GUIDebug ="Sorted Colors in Pallet";
    println("[ColorPallet] [sortColors] Sorted Colors in Pallet");
  }
}
