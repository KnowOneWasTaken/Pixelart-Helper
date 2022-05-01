/* //<>// //<>//
 Author: Philipp Schröder aka KnowOneWasTaken
 Version: 1.0
 Last time edited: 25.04.2022
 
 [ni]: markers for not written code (not implemented [yet])
 */

PImage image = new PImage();
Table colorTable = new Table();
ColorPicture pixelArray;
Textbox box, saveBox, palletBox, palletSave;
Button submit, match, save, submit2, loadImgPallet, previous, pmMode, gridMode, clearPallet, pickColor, savePallet;
PImage Isubmit, Imatch, Isave, ImgPallet, Iprevious, Itemp, ItempScale, Ion_PM, Ioff_PM, Ion_Grid, Ioff_Grid, IclearPallet, Ioff_pickColor, Ion_pickColor;
String GUIDebug = "";
color DebugC = color(0, 255, 0);
ColorPallet Pallet = new ColorPallet();
Slider s;
int Prozent = 0;
String loading ="";
PVector ofset = new PVector(0, 0);
PVector ofsetTemp = new PVector(0, 0);
PVector startOfset = new PVector(0, 0);
float tempScale; //saves the scale (zoom) of the frame for the next frame: if image and scale are the same, the image of the last frame in pixelMode can be used and does not have to be processed again
boolean isPixelMode = true, isGrid = true, isColorPicking = false;
float GUIScaleW, GUIScaleH;

void setup() {
  size(720, 480);
  //fullScreen();
  frameRate(30);
  surface.setTitle("Picture-Matcher v1.0");
  surface.setResizable(false);
  surface.setLocation(0, 0);
  image = createImage(10, 10, RGB);
  Isave = loadImage("Buttons/Save.png");
  Isubmit = loadImage("Buttons/Submit.png");
  Imatch = loadImage("Buttons/Match.png");
  ImgPallet = loadImage("Buttons/ImgPallet.png");
  Iprevious = loadImage("Buttons/Previous.png");
  Ion_PM = loadImage("Buttons/on_PM.png");
  Ioff_PM = loadImage("Buttons/off_PM.png");
  Ion_Grid = loadImage("Buttons/on_Grid.png");
  Ioff_Grid = loadImage("Buttons/off_Grid.png");
  IclearPallet = loadImage("Buttons/clearPallet.png");
  Ioff_pickColor = loadImage("Buttons/off_pickColor.png");
  Ion_pickColor = loadImage("Buttons/on_pickColor.png");

  GUIScaleW = width/1920f;
  GUIScaleH = height/1080f;

  box = new Textbox(5, 40, 200, 30);
  saveBox = new Textbox(5, 176+50, 200, 30);
  palletBox = new Textbox(5, 260+100, 200, 30);
  palletSave = new Textbox(width-200-10, height-200, 200, 30);

  box = new Textbox(int(5*GUIScaleW), int(GUIScaleH*40), int(GUIScaleW*200), int(GUIScaleH*30));
  saveBox = new Textbox(int(GUIScaleW*5), int(GUIScaleH*(176+50)), int(GUIScaleW*200), int(GUIScaleH*30));
  palletBox = new Textbox(int(GUIScaleW*5), int(GUIScaleH*360), int(GUIScaleW*200), int(GUIScaleH*30));
  palletSave = new Textbox(width+int(GUIScaleW*(-210)), height+int(GUIScaleH*(-200)), int(GUIScaleW*200), int(GUIScaleH*30));
  //GUIScale wrong implemented: only numbers with GUI und nicht width/height
  submit = new Button(true, Isubmit, true, int(GUIScaleW*73), int(GUIScaleH*80), int(GUIScaleW*60), int(GUIScaleH*38), false);
  submit2 = new Button(true, Isubmit, true, int(GUIScaleW*73), int(GUIScaleH*(300+100)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  match = new Button(true, Imatch, true, int(GUIScaleW*73), int(GUIScaleH*128), int(GUIScaleW*60), int(GUIScaleH*38), false);
  save = new Button(true, Isave, true, int(GUIScaleW*73), int(GUIScaleH*(216+50)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  pmMode = new Button(true, Ion_PM, Ioff_PM, true, width+int(GUIScaleW*(-70)), int(GUIScaleH*10), int(GUIScaleW*60), int(GUIScaleH*38), 0, false);
  loadImgPallet = new Button(true, ImgPallet, true, int(GUIScaleW*(73-30)), int(GUIScaleH*(400+38+10)), int(GUIScaleW*120), int(GUIScaleH*38), false);
  previous = new Button(true, Iprevious, true, int(GUIScaleW*(73-30)), int(GUIScaleH*(400+38+10+38+10)), int(GUIScaleW*120), int(GUIScaleH*38), false);
  gridMode = new Button(true, Ion_Grid, Ioff_Grid, true, width+int(GUIScaleW*(-70)), int(GUIScaleH*(10+38+10)), int(GUIScaleW* 60), int(GUIScaleH*38), 0, false);
  clearPallet = new Button(true, IclearPallet, true, width+int(GUIScaleW*(-60-10)), height+int(GUIScaleH*(-348)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  pickColor = new Button(true, Ioff_pickColor, Ion_pickColor, true, int(width-GUIScaleW*(70)), int((height+GUIScaleH*(-348+38+10))), int(GUIScaleW*60), int(GUIScaleH*38), 0, false);
  savePallet = new Button(true, Isave, true, width+int(GUIScaleW*(-135)), height+int(GUIScaleH*(-160)), int(GUIScaleW*60), int(GUIScaleH*38), false);

  s=new Slider((width/2)-int(GUIScaleW*250), height-int(GUIScaleH*30), int(GUIScaleW*500), int(GUIScaleH*20));
  s.scale = 0.125;
  loadPallet("colors.csv");
  //default Text in Text-Boxes
  box.replaceText("pixelart1.png");
  saveBox.replaceText("save");
  palletBox.replaceText("colors.csv");
  palletSave.replaceText("user-pallet");
}

void draw() {
  background(17);
  imageMode(CENTER);

  try {
    float zoom;
    if (width/height<image.width/image.height) {
      zoom = (image.width/image.height)*width*4*s.scale+20;
    } else {
      zoom = (width/height)*height*4*s.scale+20;
    }

    //prints the image in the middle of the window with offset, if-statement: checks if there is an image; 2:controls zoom to limit it to 2x width/height depending on picture width/height
    if (image != null) {
      drawSharpImage(image, (width/2)+ofset.x+ofsetTemp.x, height/2+ofset.y+ofsetTemp.y, image.width*(zoom/image.height), zoom);
    } else {
      println("No picture found!");
    }
  }

  //Debug-Info if the name of the image-file is invalid
  catch(Exception e) {
    println("Draw-Function: "+e);
    DebugC = color(255, 0, 0);
    GUIDebug = "Invalid name or file not found: " + box.Text;
    image = createImage(10, 10, RGB);
  }
  imageMode(CORNER);

  //writes the text
  fill(255);
  textSize(24*GUIScaleW);
  text("Save Pallet as:", width-int(GUIScaleW*210), height-int(GUIScaleH*(205)));
  text("Import Image named: (+.png/.jpg)", int(GUIScaleW*5), int(GUIScaleH*35));
  text("Save Image as:", int(GUIScaleW*5), int(GUIScaleH*216+5));
  text("Import Color-Pallet named: (+.csv/.png/.jpg)", int(GUIScaleW*5), int(GUIScaleH*355));

  //displays all Text-Boyes, buttons and sliders
  box.display();
  saveBox.display();
  palletBox.display();
  palletSave.display();

  submit.show2();
  submit2.show2();
  match.show2();
  save.show2();
  s.show();
  previous.show2();
  loadImgPallet.show2();
  pmMode.show2();
  gridMode.show2();
  pickColor.show2();
  clearPallet.show2();
  savePallet.show2();

  //displays the color-pallet
  Pallet.display();
  Pallet.displaySelected();

  //writes the Debug/Info-Text in the bottom left corner and the progress of the match-thread
  fill(color(0, 255, 0));
  text(loading, 5, height-int(GUIScaleW*30));
  fill(DebugC);
  text(GUIDebug, 5, height-10);

  //tells User if the image is too large for this program
  if (image.width*image.height>512*512) {
    fill(255, 0, 0);
    String s = "Image is quite big. This could cause lag!";
    text(s, width-textWidth(s), height-10);
  }
}

void loadPallet(String s) {//loads the Color-pallet and stores it in a Array of Colors (Color[] colors)

  //loads Pallet of an Image if it is .png or .jpg
  if (s.substring(s.length()-4, s.length()).equals(".png") || s.substring(s.length()-4, s.length()).equals(".jpg")) {
    println("Try to load pallet from picture");
    PImage img = null;
    try {
      img = loadImage(s);

      if (img == null) {
        img = loadImage("color pallets/"+s);
      } else {
        println("Image load complete in data: "+img);
      }
    }
    catch(Exception e) {
      println("Error while loading Image to make a .csv-file out of it!");
    }
    println("Image: "+img);
    if (img != null) {
      thread("loadPalletWithImage");
    }
  }

  //loads a pallet of a csv file, if it fails, it generates a empty one and loads it
  else {
    try {
      colorTable = loadTable("/color pallets/"+s, "header");
      int z = 0;
      Pallet.colors = new Color[colorTable.getRowCount()];
      for (TableRow row : colorTable.rows()) {
        Pallet.colors[z] = new Color();
        Pallet.colors[z].red = row.getInt("red");
        Pallet.colors[z].blue = row.getInt("blue");
        Pallet.colors[z].green = row.getInt("green");
        z++;
      }
      Pallet = new ColorPallet(Pallet.colors, 0, height-int(GUIScaleH*80), width, int(GUIScaleW*30), false);
      println("Pallet successfully loaded: "+s);
      GUIDebug = "Successfully loaded Pallet: "+s;
      DebugC = color(0, 255, 0);
    }

    //prints Error-message and loads an empty color-pallet after it creates it
    catch(Exception e) {
      println("Error while loading Color-Pallet named: "+s);
      Table t = new Table();
      t.addColumn("red");
      t.addColumn("green");
      t.addColumn("blue");
      saveTable(t, "color pallets/empty-color-pallet.csv");
      loadPallet("empty-color-pallet.csv");
      GUIDebug = "Error while loading Pallet: "+s;
      DebugC = color(255, 0, 0);
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
  loading = "";
  loadPallet("image-pallet.csv");
  DebugC = color(0, 255, 0);
  GUIDebug ="Successfully saved Pallet: "+"color pallets/"+s+".csv";
  println("Successfully saved Pallet: "+"color pallets/"+s+".csv");
}

//returns an Image that recreates an Image with a Color-pallet (only with specific colors)
PImage matchPicture(PImage img, Color[] pallet) {
  ColorPicture pixelArray = new ColorPicture(img);
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      pixelArray.setC(matchColor(pallet, pixelArray.getC(x, y)), pixelArray.getZ(x, y));
      Prozent = int((float(y*img.height+y)/float(img.height*img.width))*100f);
      loading = ""+ Prozent+"% finished";
    }
  }
  println("Matched Picture successfully!");
  return pixelArray.convertToImage();
}

//returns a Color of a Color pallet (pallet) that is the nearest to a given Color (c)
Color matchColor(Color[] pallet, Color c) {
  float dis = 1000000000;
  Color best = new Color();
  for (Color col : pallet) {
    if (getCDistance(col, c)<dis) {
      dis = getCDistance(col, c);
      best = col;
    }
  }
  return best;
}

//returns the Distance two Colors have to each other (in 3D-Space (r,g,b))
float getCDistance(Color c1, Color c2) {
  return sqrt(pow(c1.red-c2.red, 2)+pow(c1.green-c2.green, 2)+pow(c1.blue-c2.blue, 2)); //returns the Color - Distance in 3D-Space (r,g,b)
}

//Function to make matchPicture to a thread (gets called as a thread)
void matchP() {
  image = matchPicture(image, Pallet.colors);
  DebugC = color(0, 255, 0);
  GUIDebug = "Successfully matched Picture with pallet";
  loading = "";
}

void mousePressed() {
  box.pressed(mouseX, mouseY);
  saveBox.pressed(mouseX, mouseY);
  palletBox.pressed(mouseX, mouseY);
  palletSave.pressed(mouseX, mouseY);

  s.Pressed();

  //every frame the mouse is pressed, the coordinates of the mouse get stored to calculate the offset while grabbing
  startOfset = new PVector(mouseX, mouseY);
}

void keyPressed() {
  box.KeyPressed(key, keyCode);
  saveBox.KeyPressed(key, keyCode);
  palletBox.KeyPressed(key, keyCode);
  palletSave.KeyPressed(key, keyCode);
  startOfset = new PVector(mouseX, mouseY);
  if (key == DELETE) {
    if (Pallet.isOneColorSelected) {
      Pallet.deleteColor(Pallet.colorPicked);
    }
  }
}

void mouseDragged() {
  s.Dragged();

  //every frame the mouse gets dragged, a temporary offset gets calculated to add it to offset after mouse gets released
  if (s.selected == false && submit.touch() == false && submit2.touch() == false && match.touch() == false) {
    ofsetTemp = new PVector((mouseX-startOfset.x), (mouseY-startOfset.y));
  }
}

void mouseWheel(MouseEvent event) {
  //controls the zoom with the mouseWheel
  float e = event.getCount();
  s.scale = -e*s.step*8+s.scale;
  if (s.scale>1) {
    s.scale=1;
  }
  if (s.scale<0) {
    s.scale=0;
  }
}

void mouseClicked() {

  //(if Button is pressed) tries to load an Image and sends Error-message when it fails
  if (submit.touch()&&mouseButton==LEFT) {
    try {
      image = loadImage(box.Text);
      DebugC = color(0, 255, 0);
      GUIDebug = "Successfully loaded Picture named: " + box.Text;
      println("Picture successfully loaded: "+box.Text);
    }
    catch(Exception e) {
      println("mouseReleased-Function 1: "+e);
      DebugC = color(255, 0, 0);
      GUIDebug = "Invalid name or file not found: " + box.Text;
    }
  }

  //(if Button is pressed) starts a thread to Match the colos of an Image with a pallet
  if (match.touch()&&mouseButton==LEFT) {
    thread("matchP");
  }

  //(if Button is pressed) saves the current Image in /saved Images/ with the name in the Textbox (as .png)
  if (save.touch()&&mouseButton==LEFT) {
    image.save("saved Images/"+saveBox.Text+".png");
    DebugC = color(0, 255, 0);
    GUIDebug = "Successfully stored Picture as: "+saveBox.Text+".png"+ " | in PictureColorMatcher/saved Images";
    println("Picture successfully saved: "+saveBox.Text+".png" + " | in PictureColorMatcher/saved Images");
  }

  //(if Button is pressed) loads the pallet of the current image
  if (loadImgPallet.touch()&&mouseButton==LEFT) {
    thread("loadPalletWithImage");
    println("Pallet from image successfully loaded");
  }

  //(if Button is pressed) loads the image-pallet.csv file, so if a pallet from a Image gets saved, it can be accesed directly in the next boot
  if (previous.touch()&&mouseButton==LEFT) {
    loadPallet("image-pallet.csv");
  }

  //(if Button is pressed) saves the current Pallet (with name of the palletSave-Textbox)
  if (savePallet.touch()&&mouseButton==LEFT) {
    savePallet(palletSave.Text, Pallet, image);
  }

  //(if Button is pressed) saves the current pallet
  if (submit2.touch()&&mouseButton==LEFT) {
    //not implemented yet [ni]
  }

  //(if Button is pressed) switches between rendering-mode of PixelMode on and off (renders clear and sharp pixel-images if it is on)
  //and switches the image of the button (from off to on and vice versa)
  if (pmMode.touch()&&mouseButton==LEFT) {
    isPixelMode = !isPixelMode;
    pmMode.pictureChange();
    println("PixelMode activated: "+isPixelMode);
  }

  //(if Button is pressed) switches between rendering-mode of the Grid and switches the Image/state of the button
  if (gridMode.touch()&&mouseButton==LEFT) {
    isGrid = !isGrid;
    gridMode.pictureChange();
    println("Grid activated: "+isGrid);
  }

  //(if Button is pressed) switches picture of the button
  //isColorPicking is not implemented yet: it should allow the user to pick a color (of a pixel) of the current image and add it to the curtrent pallet
  //[ni]
  if (pickColor.touch()&&mouseButton==LEFT) {
    isColorPicking = !isColorPicking;
    pickColor.pictureChange();
  }

  //(if Button is pressed) clears/empties the current color-pallet
  if (clearPallet.touch()&&mouseButton==LEFT) {
    Pallet.clearPallet();
    println("Pallet cleard!");
  }
}

void mouseReleased() {
  //adds the temporary Ofset between click and release to offset and clears ofsetTemp
  ofset = new PVector(ofset.x+ofsetTemp.x, ofset.y+ofsetTemp.y);
  ofsetTemp = new PVector(0, 0);

  //sets limits to offset
  if (ofset.x>1.5*width) {
    ofset.x = 1.5*width;
  }
  if (ofset.y>1.5*height) {
    ofset.y = 1.5*height;
  }
  if (ofset.x<-1.5*width) {
    ofset.x = -1.5*width;
  }
  if (ofset.y<-1.5*height) {
    ofset.y = -1.5*height;
  }
  Pallet.calculateColorPicked(mouseX, mouseY);
  s.Released();
}

//creates a Color-Pallet with an Image, saves it in "color pallets/image-pallet.csv" and then loads it
void loadPalletWithImage() {
  PImage img = image;
  Table t = new Table();
  t.addColumn("red");
  t.addColumn("green");
  t.addColumn("blue");
  img.loadPixels();
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
      Prozent = int((float(i*img.height+j)/float(img.height*img.width))*100f);
      loading = ""+ Prozent+"% finished";
    }
  }
  saveTable(t, "color pallets/image-pallet.csv");
  loading = "";
  loadPallet("image-pallet.csv");
}

//renders Image with the correct rendering-modes (isPixelMode: sharp pixels; isGrid: Grid of Pixels)
void drawSharpImage(PImage img, float x, float y, float w, float h) {
  if (isPixelMode) {
    if (Itemp != img || s.scale != tempScale) {
      tempScale = s.scale;
      Itemp = img;
      PGraphics pg;
      pg = createGraphics(int(w), int(h));
      pg.beginDraw();
      pg.image(img, 0, 0, w, h);
      img.loadPixels();
      pg.noStroke();
      for (int i = 0; i < img.height; i++) {
        for (int j = 0; j < img.width; j++) {
          pg.fill(img.pixels[i*img.width+j]);
          pg.rect(j*(w/img.width), i*(h/img.height), (w/img.width), (h/img.height));
        }
      }
      pg.endDraw();
      ItempScale = pg;
      image(ItempScale, x, y, w, h);
    } else {
      image(ItempScale, x, y, w, h);
    }
  } else {
    image(img, x, y, w, h);
  }
  if (isGrid) {
    strokeWeight(0.25);
    stroke(0);
    fill(0);
    x=x-w/2;
    y=y-h/2;
    for (int i = 1; i < img.width; i++) {
      line(x+i*(w/img.width), y, x+i*(w/img.width), y+h);
    }
    for (int i = 1; i < img.width; i++) {
      line(x, y+i*(h/img.height), x+w, y+i*(h/img.height));
    }
  }
}
