/* //<>//

 Author: Philipp Schröder aka KnowOneWasTaken
 Version: 1.0.1
 Last time edited: 19.05.2022
 
 [ni]: markers for not written code (not implemented [yet])
 
 List of Buttons:
 Menue: b_Image (switch), b_Pallet (switch), b_Rendering (switch)
 Image: b_Import, b_Match, b_Save1, b_Save2, b_Filter (switch), b_Edit (switch)
 Filter: b_Relief, b_Sharpen, b_Black_And_White, b_Edges, b_Blur
 Edit: b_Rotate, b_Mirror_h, b_Mirror_v
 Pallet: b_Import (again), b_load_img_pallet, b_Save1 (again), b_Clear_Pallet, b_Sort_Colors, b_Pick_Color (switch), b_Switch
 Rendering: b_Grid (switch), b_Pixel_Mode (switch), b_RGB_Mode (switch), b_XY_Mode (switch)
 
 List of TextFields:
 Image: tf_Import, tf_Save, tf_Change
 Pallet: tf_Import (again), tf_Save (again)
 
 */
PImage image = new PImage();
Table colorTable = new Table();
ColorPicture pixelArray;
Button b_m_Image, b_m_Pallet, b_m_Rendering; //menue Buttons
Button b_Pencil; //global Buttons
Button b_Import, b_Match, b_Save, b_Change, b_Filter, b_Edit; //Buttons for Image-Layer
Button b_Relief, b_Sharpen, b_Black_And_White, b_Edges, b_Blur; //Button for Filters in Image-Layer
Button b_Rotate, b_Mirror_h, b_Mirror_v; //Buttons for Edit in Image-Layer
Button b_Img_Pallet, b_Clear_Pallet, b_Sort_Colors, b_Pick_Color, b_Switch; //Buttons for Pallet-Layer
Button b_Grid, b_Pixel_Mode, b_RGB, b_XY; //Buttons for Rendering-Layer

int layer = 0; //int for the shown GUI-Layer: 0 = Image; 1 = Pallet; 2 = Rendering

TextField tf_Import, tf_Save, tf_Change;
PImage I_off_Edit, I_off_Filter, I_off_Grid, I_off_Image, I_off_Pallet, I_off_Pick_Color, I_off_PixelMode, I_off_Rendering, I_off_RGB, I_off_XY, I_on_Edit, I_on_Filter, I_on_Grid, I_on_Image, I_on_Pallet, I_on_Pick_Color, I_on_PixelMode, I_on_Rendering, I_on_RGB, I_on_XY, I_on_Pencil, I_off_Pencil;
PImage I_BlackAndWhite, I_Blur, I_Clear_Pallet, I_Edges, I_Img_Pallet, I_Match, I_Mirror_h, I_Mirror_v, I_Relief, I_Rotate, I_Save, I_Sharpen, I_Sort_Colors, I_Import, I_Switch, I_Change;
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
boolean isPixelMode = true, isGrid = false, isColorPicking = false, isFilter = true, isEdit = true, isRGB = false, isXY = false, isPencil = false;
float GUIScaleW, GUIScaleH;
String Import_0 = "Import Image named: (+.png/.jpg)";
String Save_0 = "Save Image as";
String Change_0 = "Change Size (x;y)";
String Import_1 = "Import Color-Pallet named: (+.csv/.png/.jpg)";
String Save_1 = "Save Pallet as";
String Import_box_0 = "pixelart1.png";
String Save_box_0 = "save";
String Change_box_0 = "64;64";
String Import_box_1 = "colors.csv";
String Save_box_1 = "user-pallet";
PImage highRes;//, highResXY, highResRGB
int oldWidth;
int oldHeight;
Filter Filter = new Filter();
//int resolutionHighRes = 50; //resolution of the highRes image (one pixel width and height

void setup() {
  //size(1920, 1080, P2D);
  fullScreen(P2D);
  frameRate(30);
  surface.setTitle("Picture-Matcher v1.0.1");
  surface.setResizable(true);
  surface.setLocation(0, 0);
  image = createImage(10, 10, RGB);
  loadImages(); //loads all necessary Images

  loadGUI();
  s.scale = 0.125;
  createHighRes();
  oldWidth = width;
  oldHeight = height;
}

void draw() {
  background(17);
  imageMode(CENTER);

  try {
    float zoom = getZoom();

    //prints the image in the middle of the window with offset, if-statement: checks if there is an image; 2:controls zoom to limit it to 2x width/height depending on picture width/height
    if (image != null) {
      drawImage(image, (width/2)+ofset.x+ofsetTemp.x, height/2+ofset.y+ofsetTemp.y, image.width*(zoom/image.height), zoom);
    } else {
      println("No image found!");
    }
  }

  //Debug-Info if the name of the image-file is invalid
  catch(Exception e) {
    textSize(24*GUIScaleW);
    println("[Draw] Error while drawing Image: "+e);
    DebugC = color(255, 0, 0);
    GUIDebug = "Error while drawing Image on sceen!";
    image = createImage(10, 10, RGB);
  }
  imageMode(CORNER);
  //Menue

  try {
    b_m_Image.show2();
    b_m_Pallet.show2();
    b_m_Rendering.show2();
    b_Pencil.show2();

    //Layers
    if (layer == 0) { //[layer draw]
      tf_Import.display();
      tf_Save.display();
      tf_Change.display();
      b_Import.show2();
      b_Match.show2();
      b_Save.show2();
      b_Change.show2();
      b_Filter.show2();
      b_Edit.show2();
      if (isFilter) {
        b_Relief.show2();
        b_Sharpen.show2();
        b_Black_And_White.show2();
        b_Edges.show2();
        b_Blur.show2();
      }
      if (isEdit) {
        b_Rotate.show2();
        b_Mirror_v.show2();
        b_Mirror_h.show2();
      }
    }
    if (layer == 1) {
      tf_Import.display();
      tf_Save.display();
      b_Import.show2();
      b_Save.show2();
      b_Img_Pallet.show2();
      b_Clear_Pallet.show2();
      b_Sort_Colors.show2();
      b_Pick_Color.show2();
      b_Switch.show2();
    }
    if (layer == 2) {
      b_Grid.show2();
      b_Pixel_Mode.show2();
      b_RGB.show2();
      b_XY.show2();
    }
  }
  catch(Exception e) {
    println("[Draw] Error while showing Buttons: "+e);
  }
  s.show();

  //displays the color-pallet
  Pallet.display();
  Pallet.displaySelected();

  //writes the Debug/Info-Text in the bottom left corner and the progress of the match-thread
  textSize(24*GUIScaleW);
  fill(color(0, 255, 0));
  text(loading, 5, height-int(GUIScaleW*30));
  fill(DebugC);
  text(GUIDebug, 5, height-10);

  //tells User if the image is too large for this program
  if (image.width*image.height>=256*256) {
    fill(255, 0, 0);
    String s = "Image is quite big. This could cause lag!";
    textSize(24*GUIScaleW);
    text(s, width-textWidth(s), height-10);
  }

  if (oldWidth != width || oldHeight != height) {
    loadGUI();
    oldWidth = width;
    oldHeight = height;
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
      //if (Pallet.colors.length!=0) {
      //  for (int i = 0; i < Pallet.pallet.length; i++) {
      //    Pallet.colors[i] = new Color(int(red(Pallet.pallet[i])), int(green(Pallet.pallet[i])), int(blue(Pallet.pallet[i])));
      //  }
      //}
      //Color[] c = new Color[colorTable.getRowCount()];
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
      //for (TableRow row : colorTable.rows()) {
      //  c[z] = new Color();
      //  c[z].red = row.getInt("red");
      //  c[z].blue = row.getInt("blue");
      //  c[z].green = row.getInt("green");
      //  z++;
      //}
      //Pallet.addColors(c);
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
  loading = "";
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
  thread("createHighRes");
  DebugC = color(0, 255, 0);
  textSize(24*GUIScaleW);
  GUIDebug = "Successfully matched Picture with pallet";
  loading = "";
}

void mousePressed() {
  //box.pressed(mouseX, mouseY);
  //saveBox.pressed(mouseX, mouseY);
  //palletBox.pressed(mouseX, mouseY);
  //palletSave.pressed(mouseX, mouseY);
  if (layer == 1 || layer == 0) {
    tf_Import.pressed(mouseX, mouseY);
    tf_Save.pressed(mouseX, mouseY);
    if (layer == 0) {
      tf_Change.pressed(mouseX, mouseY);
    }
  }
  s.Pressed();

  //every frame the mouse is pressed, the coordinates of the mouse get stored to calculate the offset while grabbing
  startOfset = new PVector(mouseX, mouseY);
}

void keyPressed() {
  //box.KeyPressed(key, keyCode);
  //saveBox.KeyPressed(key, keyCode);
  //palletBox.KeyPressed(key, keyCode);
  //palletSave.KeyPressed(key, keyCode);
  tf_Import.txtBox.KeyPressed(key, keyCode);
  tf_Save.txtBox.KeyPressed(key, keyCode);
  tf_Change.txtBox.KeyPressed(key, keyCode);
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
  //if (s.selected == false && submit.touch() == false && submit2.touch() == false && match.touch() == false) {
  if (s.selected == false && ((isPencil && Pallet.isOneColorSelected && isInImage()) == false || (key == ' ' && keyPressed))) {
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

void mouseReleased() {
  if (isInImage()) {
    if (isColorPicking) {
      PVector v = getCoordinatesInImage(mouseX, mouseY);
      try {
        ColorPicture pixelArray = new ColorPicture(image);
        Pallet.addColor(pixelArray.getC(floor(v.x), floor(v.y)));

        isColorPicking = !isColorPicking;
        b_Pick_Color.pictureChange();
      }
      catch(Exception e) {
        println("[mouseReleased] Error while adding picked Color of Image: "+e);
      }
    }
    if (isPencil && Pallet.isOneColorSelected&&Pallet.inPallet(mouseX, mouseY)==false&&(key!=' '||keyPressed==false)&&b_Pencil.touch()==false) {
      try {
        image.loadPixels();
        PVector v = getCoordinatesInImage(mouseX, mouseY);
        image.pixels[int(v.x+v.y*image.width)] = Pallet.getPickedColor();
        int resolutionHighRes = int((1f/image.width)*1600); //calculates and stores the width and height of one pixel in highRes-Image
        //PGraphics pg;
        //pg = createGraphics(int(image.width*resolutionHighRes), int(image.height*resolutionHighRes));
        //pg.beginDraw();
        //pg.image(highRes,0,0);
        //pg.fill(Pallet.getPickedColor());
        //pg.noStroke();
        //pg.rect(int(v.x*resolutionHighRes),int(v.y*resolutionHighRes),resolutionHighRes,resolutionHighRes);
        //pg.endDraw();
        //highRes = pg;
        highRes.loadPixels();
        for (int i = 0; i < resolutionHighRes; i++) { //draws changed Pixel onto highRes-Image
          for (int j = 0; j <  resolutionHighRes; j++) {
            highRes.pixels[int(v.x*resolutionHighRes+v.y*image.width*resolutionHighRes*resolutionHighRes)+i*resolutionHighRes*image.width+j] = Pallet.getPickedColor();
          }
        }
        highRes.updatePixels();
        //thread("createHighRes");
      }
      catch(Exception e) {
        println("[mouseReleased] Error while painting on Image: "+e);
      }
    }
  }
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

  if (b_m_Image.touch() && mouseButton == LEFT) { //[layer switch]
    layer = 0;
    b_m_Image.setPicture(1);
    b_m_Pallet.setPicture(2);
    b_m_Rendering.setPicture(2);
    tf_Change.txtBox.isSelected = false;
    tf_Save.txtBox.isSelected = false;
    tf_Import.txtBox.isSelected = false;
    tf_Import.txtBox.replaceText(Import_box_0);
    tf_Save.txtBox.replaceText(Save_box_0);
    tf_Import.text = Import_0;
    tf_Save.text = Save_0;
    setHitbox(1, false);
    setHitbox(0, true);
    setHitbox(2, false);
  }
  if (b_m_Pallet.touch() && mouseButton == LEFT) {
    layer = 1;
    b_m_Image.setPicture(2);
    b_m_Pallet.setPicture(1);
    b_m_Rendering.setPicture(2);
    tf_Change.txtBox.isSelected = false;
    tf_Save.txtBox.isSelected = false;
    tf_Import.txtBox.isSelected = false;
    tf_Import.txtBox.replaceText(Import_box_1);
    tf_Save.txtBox.replaceText(Save_box_1);
    tf_Import.text = Import_1;
    tf_Save.text = Save_1;
    setHitbox(0, false);
    setHitbox(1, true);
    setHitbox(2, false);
  }
  if (b_m_Rendering.touch() && mouseButton == LEFT) {
    layer = 2;
    b_m_Image.setPicture(2);
    b_m_Pallet.setPicture(2);
    b_m_Rendering.setPicture(1);
    tf_Change.txtBox.isSelected = false;
    tf_Save.txtBox.isSelected = false;
    tf_Import.txtBox.isSelected = false;
    setHitbox(0, false);
    setHitbox(1, false);
    setHitbox(2, true);
  }

  if (b_Pencil.touch() && mouseButton == LEFT) {
    b_Pencil.pictureChange();
    isPencil = !isPencil;
    if (isPencil) {
      if (isColorPicking) {
        isColorPicking = !isColorPicking;
        b_Pick_Color.pictureChange();
      }
    }
  }

  if (layer == 0) {//[Button pressed layer 0]

    if (b_Import.touch() && mouseButton == LEFT) {
      try {
        image = loadImage(tf_Import.txtBox.Text);
        //if (image.width > 256 || height > 256) {
        //  if (image.width>image.height) {
        //    image.resize(255, int((image.height/image.width*1f)*255));
        //  } else {
        //    image.resize(int((image.width/image.height*1f)*255),255 );
        //  }
        //}
        DebugC = color(0, 255, 0);
        GUIDebug = "Successfully loaded Picture named: " + tf_Import.txtBox.Text;
        thread("createHighRes");
        println("Picture successfully loaded: "+tf_Import.txtBox.Text);
      }
      catch(Exception e) {
        println("mouseReleased-Function 1: "+e);
        DebugC = color(255, 0, 0);
        GUIDebug = "Invalid name or file not found: " + tf_Import.txtBox.Text;
      }
    }


    if (b_Match.touch()&&mouseButton==LEFT) {
      thread("matchP");
    }


    if (b_Save.touch()&&mouseButton==LEFT) {
      image.save("saved Images/"+tf_Save.txtBox.Text+".png");
      DebugC = color(0, 255, 0);
      GUIDebug = "Successfully stored Picture as: "+tf_Save.txtBox.Text+".png";
      println("Picture successfully saved: "+tf_Save.txtBox.Text+".png");
    }


    if (b_Change.touch() && mouseButton == LEFT) {
      //[ni]
    }


    if (b_Filter.touch() && mouseButton == LEFT) {
      b_Filter.pictureChange();
      isFilter = !isFilter;
      if (isFilter) {
        //hitbox of subordinated buttons on
        setHitbox(-1, true); //activates hitbox of Buttons subordinated to Filter
      } else {
        //hitbox of subordinated buttons off
        setHitbox(-1, false); //deactivates hitbox of Buttons subordinated to Filter
      }
    }


    if (b_Edit.touch() && mouseButton == LEFT) {
      b_Edit.pictureChange();
      isEdit = !isEdit;
      if (isEdit) {
        //hitbox of subordinated buttons of Edit on
        setHitbox(-2, true);
      } else {
        //hitbox of subordinated buttons of Edit off
        setHitbox(-2, false);
      }
    }


    if (b_Relief.touch() && mouseButton == LEFT) { //[Filter Buttons]
      //[ni]
    }


    if (b_Sharpen.touch() && mouseButton == LEFT) {
      //[ni]
    }


    if (b_Black_And_White.touch() && mouseButton == LEFT) {
      //[ni]
    }


    if (b_Edges.touch() && mouseButton == LEFT) {
      image = Filter.edges(image);
      thread("createHighRes");
    }

    if (b_Blur.touch() && mouseButton == LEFT) {
      image = Filter.blur(image, 3, 3);
      thread("createHighRes");
    }



    if (b_Rotate.touch() && mouseButton == LEFT) {//[Edit Buttons]
      //[ni]
    }


    if (b_Mirror_v.touch() && mouseButton == LEFT) {//[Edit Buttons]
      //[ni]
    }


    if (b_Mirror_h.touch() && mouseButton == LEFT) {//[Edit Buttons]
      //[ni]
    }
  }
  if (layer == 1) {//[Button pressed layer 1] [ni]
    if (b_Import.touch() && mouseButton == LEFT) {//[Edit Buttons]
      loadPallet(tf_Import.txtBox.Text);
    }
    if (b_Img_Pallet.touch() && mouseButton == LEFT) {//[Edit Buttons]
      thread("loadPalletWithImage");
    }
    if (b_Save.touch() && mouseButton == LEFT) {//[Edit Buttons]
      savePallet(tf_Save.txtBox.Text, Pallet, image);
    }
    if (b_Clear_Pallet.touch() && mouseButton == LEFT) {//[Edit Buttons]
      Pallet.clearPallet();
      println("Pallet cleard!");
    }
    if (b_Sort_Colors.touch() && mouseButton == LEFT) {//[Edit Buttons]
      //[ni]
    }
    if (b_Pick_Color.touch() && mouseButton == LEFT) {//[Edit Buttons]
      isColorPicking = !isColorPicking;
      b_Pick_Color.pictureChange();
      if (isColorPicking) {
        if (isPencil) {
          b_Pencil.pictureChange();
          isPencil = !isPencil;
        }
      }
    }
    if (b_Switch.touch() && mouseButton == LEFT) {//[Edit Buttons]
      //[ni]
    }
  }
  if (layer == 2) {//[Button pressed layer 2] [ni]
    if (b_Grid.touch() && mouseButton == LEFT) {//[Edit Buttons]
      isGrid = !isGrid;
      b_Grid.pictureChange();
    }
    if (b_Pixel_Mode.touch() && mouseButton == LEFT) {//[Edit Buttons]
      isPixelMode = !isPixelMode;
      b_Pixel_Mode.pictureChange();
    }
    if (b_RGB.touch() && mouseButton == LEFT) {//[Edit Buttons]
      isRGB= !isRGB;
      b_RGB.pictureChange();
      //[ni]
    }
    if (b_XY.touch() && mouseButton == LEFT) {//[Edit Buttons]
      isXY= !isXY;
      b_XY.pictureChange();
      //[ni]
    }
  }
}

//creates a Color-Pallet with an Image, saves it in "color pallets/image-pallet.csv" and then loads it
void loadPalletWithImage() {
  PImage img = image;
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
void drawImage(PImage img, float x, float y, float w, float h) {
  try {
    if (isPixelMode) {
      image(highRes, x, y, w, h);
    } else {
      image(img, x, y, w, h);
    }
  }
  catch(Exception e) {
    println("[drawImage] Error while drawing Images [1]: "+e);
  }
  try {
    x=x-w/2;
    y=y-h/2;
    if (isGrid) {
      strokeWeight(0.5);
      stroke(0);
      fill(0);
      for (int i = 1; i < img.width; i++) {
        line(x+i*(w/img.width), y, x+i*(w/img.width), y+h);
      }
      for (int i = 1; i < img.width; i++) {
        line(x, y+i*(h/img.height), x+w, y+i*(h/img.height));
      }
    }
    ColorPicture CP = new ColorPicture(img);
    if (isXY||isRGB) {
      for (int j = 0; j < img.height; j++) {
        for (int i = 0; i < img.width; i++) {
          color c = CP.getC(i, j).getColor();
          if (brightness(c)>128) {
            fill(0);
          } else {
            fill(255);
          }
          if (isXY) {
            textAlign(CORNER);
            textSize((w/img.width)/5);
            text(i+";"+j, x+i*(w/img.width), y+j*(w/img.height)+(w/img.width)/5);
          }
          if (isRGB) {
            textSize((w/img.width)/7);
            textAlign(CENTER);
            text(int(red(c)), x+i*(w/img.width)+(w/img.width)/2, y+j*(w/img.height)+(w/img.width)/2);
            text(int(green(c)), x+i*(w/img.width)+(w/img.width)/2, y+j*(w/img.height)+(w/img.width)/2+(w/img.width)/6);
            text(int(blue(c)), x+i*(w/img.width)+(w/img.width)/2, y+j*(w/img.height)+(w/img.width)/2+(w/img.width)/3);
          }
        }
      }
      textAlign(CORNER);
    }
  }
  catch(Exception e) {
    println("[drawImage] Error while drawing Overlay [2]: "+e);
  }
}

void createHighRes() {
  int resolutionHighRes = int((1f/image.width)*1600);
  PGraphics pg;
  pg = createGraphics(int(image.width*resolutionHighRes), int(image.height*resolutionHighRes));
  pg.beginDraw();
  pg.image(image, 0, 0, image.width*resolutionHighRes, image.height*resolutionHighRes);
  image.loadPixels();
  pg.noStroke();
  for (int i = 0; i < image.height; i++) {
    for (int j = 0; j < image.width; j++) {
      pg.fill(image.pixels[i*image.width+j]);
      pg.rect(j*(image.width*resolutionHighRes/image.width), i*(image.height*resolutionHighRes/image.height), (image.width*resolutionHighRes/image.width), (image.height*resolutionHighRes/image.height));
      //fill(255-floor(((i*image.width+j)/((image.height*image.width)*1f))*255f), floor(((i*image.width+j)/((image.height*image.width)*1f))*100f), 0);
      loading = "Create high-resolution Image: "+floor(((i*image.width+j)/((image.height*image.width)*1f))*100f)+"%";
    }
  }
  pg.endDraw();

  highRes = pg;
  image.save("auto save/last_session_"+day()+"."+month()+"."+year()+"_"+hour()+".png");
  println("Created High-Resolution Image");
  loading="";
}

void loadImages() {
  try {
    I_off_Edit = loadImage("Buttons/off_Edit.png");
    I_off_Filter = loadImage("Buttons/off_Filter.png");
    I_off_Grid = loadImage("Buttons/off_Grid.png");
    I_off_Image = loadImage("Buttons/off_Image.png");
    I_off_Pick_Color = loadImage("Buttons/off_PickColor.png");
    I_off_PixelMode = loadImage("Buttons/off_PixelMode.png");
    I_off_Rendering = loadImage("Buttons/off_Rendering.png");
    I_off_RGB = loadImage("Buttons/off_RGB.png");
    I_off_XY = loadImage("Buttons/off_XY.png");
    I_off_Pallet = loadImage("Buttons/off_Pallet.png");
    I_off_Pencil = loadImage("Buttons/off_Pencil.png");

    I_on_Edit = loadImage("Buttons/on_Edit.png");
    I_on_Filter = loadImage("Buttons/on_Filter.png");
    I_on_Grid = loadImage("Buttons/on_Grid.png");
    I_on_Image = loadImage("Buttons/on_Image.png");
    I_on_Pick_Color = loadImage("Buttons/on_PickColor.png");
    I_on_PixelMode = loadImage("Buttons/on_PixelMode.png");
    I_on_Rendering = loadImage("Buttons/on_Rendering.png");
    I_on_RGB = loadImage("Buttons/on_RGB.png");
    I_on_XY = loadImage("Buttons/on_XY.png");
    I_on_Pallet = loadImage("Buttons/on_Pallet.png");
    I_on_Pencil = loadImage("Buttons/on_Pencil.png");

    I_BlackAndWhite = loadImage("Buttons/BlackAndWhite.png");
    I_Blur = loadImage("Buttons/Blur.png");
    I_Clear_Pallet = loadImage("Buttons/ClearPallet.png");
    I_Edges = loadImage("Buttons/Edges.png");
    I_Img_Pallet = loadImage("Buttons/ImgPallet.png");
    I_Import = loadImage("Buttons/Import.png");
    I_Match = loadImage("Buttons/Match.png");
    I_Mirror_h = loadImage("Buttons/Mirror_h.png");
    I_Mirror_v = loadImage("Buttons/Mirror_v.png");
    I_Relief = loadImage("Buttons/Relief.png");
    I_Rotate = loadImage("Buttons/Rotate.png");
    I_Save = loadImage("Buttons/Save.png");
    I_Sharpen = loadImage("Buttons/Sharpen.png");
    I_Sort_Colors = loadImage("Buttons/SortColors.png");
    I_Switch = loadImage("Buttons/Switch.png");
    I_Change = loadImage("Buttons/Change.png");
    println("[loadImages] Loaded Images successfully");
  }
  catch(Exception e) {
    println("[loadImages] Error while loading Images: "+e);
  }
}

void setHitbox(int lay, boolean b) {
  if (lay == 0) {
    b_Relief.setHitbox(b);
    b_Sharpen.setHitbox(b);
    b_Black_And_White.setHitbox(b);
    b_Edges.setHitbox(b);
    b_Blur.setHitbox(b);

    b_Rotate.setHitbox(b);
    b_Mirror_v.setHitbox(b);
    b_Mirror_h.setHitbox(b);

    b_Filter.setHitbox(b);
    b_Edit.setHitbox(b);

    b_Match.setHitbox(b);
    b_Change.setHitbox(b);
    b_Save.setHitbox(b);
    b_Import.setHitbox(b);
  }
  if (lay == 1) {
    b_Import.setHitbox(b);
    b_Img_Pallet.setHitbox(b);
    b_Save.setHitbox(b);
    b_Clear_Pallet.setHitbox(b);
    b_Sort_Colors.setHitbox(b);
    b_Pick_Color.setHitbox(b);
    b_Switch.setHitbox(b);
  }
  if (lay == 2) {
    b_Grid.setHitbox(b);
    b_Pixel_Mode.setHitbox(b);
    b_RGB.setHitbox(b);
    b_XY.setHitbox(b);
  }

  if (lay == -1) {//Filter
    b_Relief.setHitbox(b);
    b_Sharpen.setHitbox(b);
    b_Black_And_White.setHitbox(b);
    b_Edges.setHitbox(b);
    b_Blur.setHitbox(b);
  }
  if (lay == -2) {//Edit
    b_Rotate.setHitbox(b);
    b_Mirror_v.setHitbox(b);
    b_Mirror_h.setHitbox(b);
  }
}
boolean isInImage() {
  //drawImage(image, (width/2)+ofset.x+ofsetTemp.x, height/2+ofset.y+ofsetTemp.y, image.width*(zoom/image.height), zoom);
  int w = floor(image.width*(getZoom()/image.height));
  int h = floor(getZoom());
  int pX = floor((width/2)+ofset.x+ofsetTemp.x), pY = floor(height/2+ofset.y+ofsetTemp.y);
  pX = pX-w/2;
  pY = pY-h/2;
  if (mouseX > pX && mouseX < pX+w) {
    if (mouseY > pY && mouseY < pY+h) {
      return true;
    }
  }
  return false;
}
PVector getCoordinatesInImage(int x, int y) {
  if (isInImage()) {
    //drawImage(image, (width/2)+ofset.x+ofsetTemp.x, height/2+ofset.y+ofsetTemp.y, image.width*(zoom/image.height), zoom);
    int w = int(image.width*(getZoom()/image.height));
    int h = int(getZoom());
    int pX = int((width/2)+ofset.x+ofsetTemp.x), pY = int(height/2+ofset.y+ofsetTemp.y);
    pX = pX-w/2;
    pY = pY-h/2;
    return new PVector(floor((1f*x-pX)/(1f*w/image.width)), floor((1f*y-pY)/(1f*h/image.height)));
  }
  println("[PVector getCoordinatesInImage] Error while calculating position of mouse in the image.");
  return new PVector(0, 0);
}

float getZoom() {
  if (width/height<image.width/image.height) {
    return (image.width/image.height)*width*4*s.scale+20;
  } else {
    return (width/height)*height*4*s.scale+20;
  }
}

void loadGUI() {
  GUIScaleW = width/1920f;
  GUIScaleH = height/1080f;

  int i = 0;
  i = (layer == 0) ? 1 : 2;
  b_m_Image = new Button(true, I_on_Image, I_off_Image, false, int(GUIScaleW*10), int(GUIScaleH*10), int(GUIScaleW * 100), int(GUIScaleH * 40), i, false);
  i = (layer == 1) ? 1 : 2;
  b_m_Pallet = new Button(true, I_on_Pallet, I_off_Pallet, false, int(GUIScaleW*120), int(GUIScaleH*10), int(GUIScaleW * 100), int(GUIScaleH * 40), i, false);
  i = (layer == 2) ? 1 : 2;
  b_m_Rendering = new Button(true, I_on_Rendering, I_off_Rendering, false, int(GUIScaleW*230), int(GUIScaleH*10), int(GUIScaleW * 100), int(GUIScaleH * 40), i, false);
  i = isPencil ? 1 : 2;
  b_Pencil = new Button(true, I_on_Pencil, I_off_Pencil, false, int(GUIScaleW*(width-70)), int(GUIScaleH*(height-127)), int(GUIScaleW * 60), int(GUIScaleH * 38), i, false);

  tf_Import = new TextField(Import_0, int(GUIScaleW*20), int(GUIScaleH*50), int(GUIScaleW*200), int(GUIScaleH*60), Import_box_0);
  tf_Save = new TextField(Save_0, int(GUIScaleW*20), int(GUIScaleH*236), int(GUIScaleW*200), int(GUIScaleH*60), Save_box_0);
  tf_Change = new TextField(Change_0, int(GUIScaleW*20), int(GUIScaleH*355), int(GUIScaleW*200), int(GUIScaleH*60), Change_box_0);

  //Image-Layer
  b_Import = new Button(true, I_Import, false, int(GUIScaleW*88), int(GUIScaleH*120), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Match = new Button(true, I_Match, false, int(GUIScaleW*88), int(GUIScaleH*168), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Save = new Button(true, I_Save, false, int(GUIScaleW*88), int(GUIScaleH*306), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Change = new Button(true, I_Change, false, int(GUIScaleW*88), int(GUIScaleH*425), int(GUIScaleW*60), int(GUIScaleH*38), false);

  i = isFilter ? 1 : 2;
  b_Filter = new Button(true, I_on_Filter, I_off_Filter, false, int(GUIScaleW*1720), int(GUIScaleH*10), int(GUIScaleW * 60), int(GUIScaleH * 38), i, false);
  i = isEdit ? 1 : 2;
  b_Edit = new Button(true, I_on_Edit, I_off_Edit, false, int(GUIScaleW*1840), int(GUIScaleH*10), int(GUIScaleW * 60), int(GUIScaleH * 38), i, false);

  b_Relief = new Button(true, I_Relief, false, int(GUIScaleW*1730), int(GUIScaleH*58), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Sharpen = new Button(true, I_Sharpen, false, int(GUIScaleW*1730), int(GUIScaleH*(60+48*1)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Black_And_White = new Button(true, I_BlackAndWhite, false, int(GUIScaleW*1730), int(GUIScaleH*(60+48*2)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Edges = new Button(true, I_Edges, false, int(GUIScaleW*1730), int(GUIScaleH*(60+48*3)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Blur = new Button(true, I_Blur, false, int(GUIScaleW*1730), int(GUIScaleH*(60+48*4)), int(GUIScaleW*60), int(GUIScaleH*38), false);

  b_Rotate = new Button(true, I_Rotate, false, int(GUIScaleW*1850), int(GUIScaleH*(60+48*0)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Mirror_v = new Button(true, I_Mirror_v, false, int(GUIScaleW*1850), int(GUIScaleH*(60+48*1)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Mirror_h = new Button(true, I_Mirror_h, false, int(GUIScaleW*1850), int(GUIScaleH*(60+48*2)), int(GUIScaleW*60), int(GUIScaleH*38), false);

  //Pallet Layer
  b_Img_Pallet = new Button(true, I_Img_Pallet, false, int(GUIScaleW*58), int(GUIScaleH*(168)), int(GUIScaleW*120), int(GUIScaleH*38), false);
  b_Clear_Pallet = new Button(true, I_Clear_Pallet, false, int(GUIScaleW*(20+75*0)), int(GUIScaleH*(363+48*0)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Sort_Colors = new Button(true, I_Sort_Colors, false, int(GUIScaleW*(20+75*1)), int(GUIScaleH*(363+48*0)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Pick_Color = new Button(true, I_on_Pick_Color, I_off_Pick_Color, false, int(GUIScaleW*(20+75*2)), int(GUIScaleH*(363+48*0)), int(GUIScaleW*60), int(GUIScaleH*38), 2, false);
  b_Switch = new Button(true, I_Switch, false, int(GUIScaleW*(20+75*0)), int(GUIScaleH*(363+48*1)), int(GUIScaleW*60), int(GUIScaleH*38), false);

  //Rendering Layer
  i = isGrid ? 1 : 2;
  b_Grid = new Button(true, I_on_Grid, I_off_Grid, false, int(GUIScaleW*(20)), int(GUIScaleH*(72+48*0)), int(GUIScaleW*60), int(GUIScaleH*38), i, false);
  i = isPixelMode ? 1 : 2;
  b_Pixel_Mode = new Button(true, I_on_PixelMode, I_off_PixelMode, false, int(GUIScaleW*(20)), int(GUIScaleH*(72+48*1)), int(GUIScaleW*60), int(GUIScaleH*38), i, false);
  i = isRGB ? 1 : 2;
  b_RGB = new Button(true, I_on_RGB, I_off_RGB, false, int(GUIScaleW*(20)), int(GUIScaleH*(72+48*2)), int(GUIScaleW*60), int(GUIScaleH*38), i, false);
  i = isXY ? 1 : 2;
  b_XY = new Button(true, I_on_XY, I_off_XY, false, int(GUIScaleW*(20)), int(GUIScaleH*(72+48*3)), int(GUIScaleW*60), int(GUIScaleH*38), i, false);

  s=new Slider((width/2)-int(GUIScaleW*250), height-int(GUIScaleH*30), int(GUIScaleW*500), int(GUIScaleH*20));
  loadPallet("colors.csv");
  println("[loadGUI] Loaded GUI");
}
