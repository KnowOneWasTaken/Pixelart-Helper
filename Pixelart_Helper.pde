/* //<>// //<>//
 Author: Philipp Schröder aka KnowOneWasTaken
 Version: 1.0
 Last time edited: 25.04.2022
 
 [ni]: markers for not written code (not implemented [yet])
 */

/*
To do:
 -import new Images
 -initilize new buttons and TextFields
 -maybe do a GUI_Layer class
 
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
//Textbox box, saveBox, palletBox, palletSave;
Button b_m_Image, b_m_Pallet, b_m_Rendering; //menue Buttons
Button b_Import, b_Match, b_Save, b_Change, b_Filter, b_Edit; //Buttons for Image-Layer
Button b_Relief, b_Sharpen, b_Black_And_White, b_Edges, b_Blur; //Button for Filters in Image-Layer
Button b_Rotate, b_Mirror_h, b_Mirror_v; //Buttons for Edit in Image-Layer
Button b_load_img_pallet, b_Clear_Pallet, b_Sort_Colors, b_Pick_Color, b_Switch; //Buttons for Pallet-Layer
Button b_Grid, b_Pixel_Mode, b_RGM_Mode, b_XY_Mode; //Buttons for Rendering-Layer

int layer = 0; //int for the shown GUI-Layer: 0 = Image; 1 = Pallet; 2 = Rendering

TextField tf_Import, tf_Save, tf_Change;
//Button submit, match, save, submit2, loadImgPallet, previous, pmMode, gridMode, clearPallet, pickColor, savePallet;
PImage Itemp, ItempScale;
PImage I_off_Edit, I_off_Filter, I_off_Grid, I_off_Image, I_off_Pallet, I_off_PickColor, I_off_PixelMode, I_off_Rendering, I_off_RGB, I_off_XY, I_on_Edit, I_on_Filter, I_on_Grid, I_on_Image, I_on_Pallet, I_on_PickColor, I_on_PixelMode, I_on_Rendering, I_on_RGB, I_on_XY;
PImage I_BlackAndWhite, I_Blur, I_ClearPallet, I_Edges, I_ImgPallet, I_Match, I_Mirror_h, I_Mirror_v, I_Relief, I_Rotate, I_Save, I_Sharpen, I_SortColors, I_Import, I_Switch, I_Change;
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
boolean isPixelMode = true, isGrid = true, isColorPicking = false, isFilter = true, isEdit = true;
float GUIScaleW, GUIScaleH;
String Import_0 = "Import Image named: (+.png/.jpg)";
String Save_0 = "Save Image as";
String Change_0 = "Change Size (x;y)";
String Import_1 = "Import Color-Pallet named: (+.csv/.png/.jpg)";
String Save_1 = "Save Pallet as";
String Import_box_0 = "pixelart1.png";
String Save_box_0 = "save";
String Change_box_0 = "100;200";
String Import_box_1 = "colors.csv";
String Save_box_1 = "user-pallet";

void setup() {
  //size(720, 480);
  fullScreen();
  frameRate(30);
  surface.setTitle("Picture-Matcher v1.0");
  surface.setResizable(false);
  surface.setLocation(0, 0);
  image = createImage(10, 10, RGB);
  loadImages(); //loads all necessary Images

  GUIScaleW = width/1920f;
  GUIScaleH = height/1080f;

  b_m_Image = new Button(true, I_on_Image, I_off_Image, false, int(GUIScaleW*10), int(GUIScaleH*10), int(GUIScaleW * 100), int(GUIScaleH * 40), 1, false);
  b_m_Pallet = new Button(true, I_on_Pallet, I_off_Pallet, false, int(GUIScaleW*120), int(GUIScaleH*10), int(GUIScaleW * 100), int(GUIScaleH * 40), 2, false);
  b_m_Rendering = new Button(true, I_on_Rendering, I_off_Rendering, false, int(GUIScaleW*230), int(GUIScaleH*10), int(GUIScaleW * 100), int(GUIScaleH * 40), 2, false);

  tf_Import = new TextField(Import_0, int(GUIScaleW*20), int(GUIScaleH*50), int(GUIScaleW*200), int(GUIScaleH*60), Import_box_0);
  tf_Save = new TextField(Save_0, int(GUIScaleW*20), int(GUIScaleH*236), int(GUIScaleW*200), int(GUIScaleH*60), Save_box_0);
  tf_Change = new TextField(Change_0, int(GUIScaleW*20), int(GUIScaleH*355), int(GUIScaleW*200), int(GUIScaleH*60), Change_box_0);

  //Image-Layer
  b_Import = new Button(true, I_Import, false, int(GUIScaleW*88), int(GUIScaleH*120), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Match = new Button(true, I_Match, false, int(GUIScaleW*88), int(GUIScaleH*168), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Save = new Button(true, I_Save, false, int(GUIScaleW*88), int(GUIScaleH*306), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Change = new Button(true, I_Change, false, int(GUIScaleW*88), int(GUIScaleH*425), int(GUIScaleW*60), int(GUIScaleH*38), false);

  b_Filter = new Button(true, I_on_Filter, I_off_Filter, false, int(GUIScaleW*1720), int(GUIScaleH*10), int(GUIScaleW * 60), int(GUIScaleH * 38), 1, false);
  b_Edit = new Button(true, I_on_Edit, I_off_Edit, false, int(GUIScaleW*1840), int(GUIScaleH*10), int(GUIScaleW * 60), int(GUIScaleH * 38), 1, false);

  b_Relief = new Button(true, I_Relief, false, int(GUIScaleW*1730), int(GUIScaleH*58), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Sharpen = new Button(true, I_Sharpen, false, int(GUIScaleW*1730), int(GUIScaleH*(60+48*1)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Black_And_White = new Button(true, I_BlackAndWhite, false, int(GUIScaleW*1730), int(GUIScaleH*(60+48*2)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Edges = new Button(true, I_Edges, false, int(GUIScaleW*1730), int(GUIScaleH*(60+48*3)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Blur = new Button(true, I_Blur, false, int(GUIScaleW*1730), int(GUIScaleH*(60+48*4)), int(GUIScaleW*60), int(GUIScaleH*38), false);

  b_Rotate = new Button(true, I_Rotate, false, int(GUIScaleW*1850), int(GUIScaleH*(60+48*0)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Mirror_v = new Button(true, I_Mirror_v, false, int(GUIScaleW*1850), int(GUIScaleH*(60+48*1)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  b_Mirror_h = new Button(true, I_Mirror_h, false, int(GUIScaleW*1850), int(GUIScaleH*(60+48*2)), int(GUIScaleW*60), int(GUIScaleH*38), false);

  //b_m_image = new Button();
  //box = new Textbox(5, 40, 200, 30);
  //saveBox = new Textbox(5, 176+50, 200, 30);
  //palletBox = new Textbox(5, 260+100, 200, 30);
  //palletSave = new Textbox(width-200-10, height-200, 200, 30);

  //box = new Textbox(int(5*GUIScaleW), int(GUIScaleH*40), int(GUIScaleW*200), int(GUIScaleH*30));
  //saveBox = new Textbox(int(GUIScaleW*5), int(GUIScaleH*(176+50)), int(GUIScaleW*200), int(GUIScaleH*30));
  //palletBox = new Textbox(int(GUIScaleW*5), int(GUIScaleH*360), int(GUIScaleW*200), int(GUIScaleH*30));
  //palletSave = new Textbox(width+int(GUIScaleW*(-210)), height+int(GUIScaleH*(-200)), int(GUIScaleW*200), int(GUIScaleH*30));
  ////GUIScale wrong implemented: only numbers with GUI und nicht width/height
  //submit = new Button(true, Isubmit, true, int(GUIScaleW*73), int(GUIScaleH*80), int(GUIScaleW*60), int(GUIScaleH*38), false);
  //submit2 = new Button(true, Isubmit, true, int(GUIScaleW*73), int(GUIScaleH*(300+100)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  //match = new Button(true, Imatch, true, int(GUIScaleW*73), int(GUIScaleH*128), int(GUIScaleW*60), int(GUIScaleH*38), false);
  //save = new Button(true, Isave, true, int(GUIScaleW*73), int(GUIScaleH*(216+50)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  //pmMode = new Button(true, Ion_PM, Ioff_PM, true, width+int(GUIScaleW*(-70)), int(GUIScaleH*10), int(GUIScaleW*60), int(GUIScaleH*38), 0, false);
  //loadImgPallet = new Button(true, ImgPallet, true, int(GUIScaleW*(73-30)), int(GUIScaleH*(400+38+10)), int(GUIScaleW*120), int(GUIScaleH*38), false);
  //previous = new Button(true, Iprevious, true, int(GUIScaleW*(73-30)), int(GUIScaleH*(400+38+10+38+10)), int(GUIScaleW*120), int(GUIScaleH*38), false);
  //gridMode = new Button(true, Ion_Grid, Ioff_Grid, true, width+int(GUIScaleW*(-70)), int(GUIScaleH*(10+38+10)), int(GUIScaleW* 60), int(GUIScaleH*38), 0, false);
  //clearPallet = new Button(true, IclearPallet, true, width+int(GUIScaleW*(-60-10)), height+int(GUIScaleH*(-348)), int(GUIScaleW*60), int(GUIScaleH*38), false);
  //pickColor = new Button(true, Ioff_pickColor, Ion_pickColor, true, int(width-GUIScaleW*(70)), int((height+GUIScaleH*(-348+38+10))), int(GUIScaleW*60), int(GUIScaleH*38), 0, false);
  //savePallet = new Button(true, Isave, true, width+int(GUIScaleW*(-135)), height+int(GUIScaleH*(-160)), int(GUIScaleW*60), int(GUIScaleH*38), false);

  s=new Slider((width/2)-int(GUIScaleW*250), height-int(GUIScaleH*30), int(GUIScaleW*500), int(GUIScaleH*20));
  s.scale = 0.125;
  loadPallet("colors.csv");
  //default Text in Text-Boxes
  //box.replaceText("pixelart1.png");
  //saveBox.replaceText("save");
  //palletBox.replaceText("colors.csv");
  //palletSave.replaceText("user-pallet");
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
    //GUIDebug = "Invalid name or file not found: " + box.Text;
    image = createImage(10, 10, RGB);
  }
  imageMode(CORNER);
  //Menue
  b_m_Image.show2();
  b_m_Pallet.show2();
  b_m_Rendering.show2();

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
  }
  if (layer == 2) {
  }
  s.show();

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
  if (s.selected == false) {
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

  ////(if Button is pressed) loads the pallet of the current image
  //if (loadImgPallet.touch()&&mouseButton==LEFT) {
  //  thread("loadPalletWithImage");
  //  println("Pallet from image successfully loaded");
  //}

  ////(if Button is pressed) loads the image-pallet.csv file, so if a pallet from a Image gets saved, it can be accesed directly in the next boot
  //if (previous.touch()&&mouseButton==LEFT) {
  //  loadPallet("image-pallet.csv");
  //}

  ////(if Button is pressed) saves the current Pallet (with name of the palletSave-Textbox)
  //if (savePallet.touch()&&mouseButton==LEFT) {
  //  savePallet(palletSave.Text, Pallet, image);
  //}

  ////(if Button is pressed) saves the current pallet
  //if (submit2.touch()&&mouseButton==LEFT) {
  //  //not implemented yet [ni]
  //}

  ////(if Button is pressed) switches between rendering-mode of PixelMode on and off (renders clear and sharp pixel-images if it is on)
  ////and switches the image of the button (from off to on and vice versa)
  //if (pmMode.touch()&&mouseButton==LEFT) {
  //  isPixelMode = !isPixelMode;
  //  pmMode.pictureChange();
  //  println("PixelMode activated: "+isPixelMode);
  //}

  ////(if Button is pressed) switches between rendering-mode of the Grid and switches the Image/state of the button
  //if (gridMode.touch()&&mouseButton==LEFT) {
  //  isGrid = !isGrid;
  //  gridMode.pictureChange();
  //  println("Grid activated: "+isGrid);
  //}

  ////(if Button is pressed) switches picture of the button
  ////isColorPicking is not implemented yet: it should allow the user to pick a color (of a pixel) of the current image and add it to the curtrent pallet
  ////[ni]
  //if (pickColor.touch()&&mouseButton==LEFT) {
  //  isColorPicking = !isColorPicking;
  //  pickColor.pictureChange();
  //}

  ////(if Button is pressed) clears/empties the current color-pallet
  //if (clearPallet.touch()&&mouseButton==LEFT) {
  //  Pallet.clearPallet();
  //  println("Pallet cleard!");
  //}
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

  if (layer == 0) {//[Button pressed layer 0]

    if (b_Import.touch() && mouseButton == LEFT) {
      try {
        image = loadImage(tf_Import.txtBox.Text);
        DebugC = color(0, 255, 0);
        GUIDebug = "Successfully loaded Picture named: " + tf_Import.txtBox.Text;
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
        b_Relief.setHitbox(true);
        b_Sharpen.setHitbox(true);
        b_Black_And_White.setHitbox(true);
        b_Edges.setHitbox(true);
        b_Blur.setHitbox(true);
      } else {
        //hitbox of subordinated buttons off
        b_Relief.setHitbox(false);
        b_Sharpen.setHitbox(false);
        b_Black_And_White.setHitbox(false);
        b_Edges.setHitbox(false);
        b_Blur.setHitbox(false);
      }
    }
    if (b_Edit.touch() && mouseButton == LEFT) {
      b_Edit.pictureChange();
      isEdit = !isEdit;
      if (isEdit) {
        //hitbox of subordinated buttons on
        b_Rotate.setHitbox(true);
        b_Mirror_v.setHitbox(true);
        b_Mirror_h.setHitbox(true);
      } else {
        //hitbox of subordinated buttons off
        b_Rotate.setHitbox(false);
        b_Mirror_v.setHitbox(false);
        b_Mirror_h.setHitbox(false);
      }
    }
  }
  if (layer == 1) {//[Button pressed layer 1] [ni]
  }
  if (layer == 2) {//[Button pressed layer 2] [ni]
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

void loadImages() {
  I_off_Edit = loadImage("Buttons/off_Edit.png");
  I_off_Filter = loadImage("Buttons/off_Filter.png");
  I_off_Grid = loadImage("Buttons/off_Grid.png");
  I_off_Image = loadImage("Buttons/off_Image.png");
  I_off_PickColor = loadImage("Buttons/off_PickColor.png");
  I_off_PixelMode = loadImage("Buttons/off_PixelMode.png");
  I_off_Rendering = loadImage("Buttons/off_Rendering.png");
  I_off_RGB = loadImage("Buttons/off_RGB.png");
  I_off_XY = loadImage("Buttons/off_XY.png");
  I_off_Pallet = loadImage("Buttons/off_Pallet.png");

  I_on_Edit = loadImage("Buttons/on_Edit.png");
  I_on_Filter = loadImage("Buttons/on_Filter.png");
  I_on_Grid = loadImage("Buttons/on_Grid.png");
  I_on_Image = loadImage("Buttons/on_Image.png");
  I_on_PickColor = loadImage("Buttons/on_PickColor.png");
  I_on_PixelMode = loadImage("Buttons/on_PixelMode.png");
  I_on_Rendering = loadImage("Buttons/on_Rendering.png");
  I_on_RGB = loadImage("Buttons/on_RGB.png");
  I_on_XY = loadImage("Buttons/on_XY.png");
  I_on_Pallet = loadImage("Buttons/on_Pallet.png");

  I_BlackAndWhite = loadImage("Buttons/BlackAndWhite.png");
  I_Blur = loadImage("Buttons/Blur.png");
  I_ClearPallet = loadImage("Buttons/ClearPallet.png");
  I_Edges = loadImage("Buttons/Edges.png");
  I_ImgPallet = loadImage("Buttons/ImgPallet.png");
  I_Import = loadImage("Buttons/Import.png");
  I_Match = loadImage("Buttons/Match.png");
  I_Mirror_h = loadImage("Buttons/Mirror_h.png");
  I_Mirror_v = loadImage("Buttons/Mirror_v.png");
  I_Relief = loadImage("Buttons/Relief.png");
  I_Rotate = loadImage("Buttons/Rotate.png");
  I_Save = loadImage("Buttons/Save.png");
  I_Sharpen = loadImage("Buttons/Sharpen.png");
  I_SortColors = loadImage("Buttons/SortColors.png");
  I_Switch = loadImage("Buttons/Switch.png");
  I_Change = loadImage("Buttons/Change.png");
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
    //[ni]
  }
  if (lay == 2) {
    //[ni]
  }
}
