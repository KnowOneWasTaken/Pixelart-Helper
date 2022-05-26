/* //<>//

 Author: Philipp Schröder aka KnowOneWasTaken
 Version: 1.1.0
 Last time edited: 26.05.2022
 
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
ColorPicture pixelArray;
Button b_m_Image, b_m_Pallet, b_m_Rendering; //menue Buttons
Button b_Pencil, b_Back; //global Buttons
Button b_Import, b_Match, b_Save, b_Change, b_Filter, b_Edit; //Buttons for Image-Layer
Button b_Relief, b_Sharpen, b_Black_And_White, b_Edges, b_Blur, b_Invert; //Button for Filters in Image-Layer
Button b_Rotate, b_Mirror_h, b_Mirror_v; //Buttons for Edit in Image-Layer
Button b_Img_Pallet, b_Clear_Pallet, b_Sort_Colors, b_Pick_Color, b_Switch; //Buttons for Pallet-Layer
Button b_Grid, b_Pixel_Mode, b_RGB, b_XY; //Buttons for Rendering-Layer

int layer = 0; //int for the shown GUI-Layer: 0 = Image; 1 = Pallet; 2 = Rendering

TextField tf_Import, tf_Save, tf_Change;
PImage I_off_Edit, I_off_Filter, I_off_Grid, I_off_Image, I_off_Pallet, I_off_Pick_Color, I_off_PixelMode, I_off_Rendering, I_off_RGB, I_off_XY, I_on_Edit, I_on_Filter, I_on_Grid, I_on_Image, I_on_Pallet, I_on_Pick_Color, I_on_PixelMode, I_on_Rendering, I_on_RGB, I_on_XY, I_on_Pencil, I_off_Pencil;
PImage I_BlackAndWhite, I_Blur, I_Clear_Pallet, I_Edges, I_Img_Pallet, I_Match, I_Mirror_h, I_Mirror_v, I_Relief, I_Rotate, I_Save, I_Sharpen, I_Sort_Colors, I_Import, I_Switch, I_Change, I_Invert, I_Back;
String GUIDebug = "";
color DebugC = color(0, 255, 0);
ColorPallet Pallet = new ColorPallet();
Slider s;
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
boolean touchGUI = false;
ArrayList<PImage> history = new ArrayList<PImage>();
boolean offSet = false;
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

  try {
    image = loadImage("auto save/last_session.png");
    if (image != null) {
    } else {
      image = createImage(10, 10, RGB);
    }
  }
  catch(Exception e) {
    println("[Setup] Error while loading last sessions Image: "+e);
    image = createImage(10, 10, RGB);
  }
  loadGUI();
  try {
    Pallet.loadPallet("../auto save/last_session.csv");
  }
  catch(Exception e) {
    println("[Setup] Couldn't load last_session.csv");
    Pallet.loadPallet("colors.csv");
  }

  s.scale = 0.125;
  updateHighRes();
  oldWidth = width;
  oldHeight = height;
  println("[Setup] Finished Setup");
  DebugC = color(0, 255, 0);
  GUIDebug = "Launched Program";
}

void draw() {
  background(17);
  imageMode(CENTER);

  setTouchGUI();

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
    GUIDebug = "Error while drawing Image on screen!";
    image = createImage(10, 10, RGB);
  }
  imageMode(CORNER);
  //Menue

  try {
    b_m_Image.show2();
    b_m_Pallet.show2();
    b_m_Rendering.show2();
    b_Pencil.show2();
    b_Back.show2();

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
        b_Invert.show2();
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
    println("[Draw] Error while rendering Buttons: "+e);
    DebugC = color(255, 0, 0);
    GUIDebug = "Error while rendering Buttons";
  }
  try {
    s.show();

    //displays the color-pallet
    Pallet.display();
    Pallet.displaySelected();
  }
  catch(Exception e) {
    println("[Draw] Error while rendering Slider and Pallet: "+e);
    DebugC = color(255, 0, 0);
    GUIDebug = "Error while rendering GUI";
  }

  //writes the Debug/Info-Text in the bottom left corner and the progress of the match-thread
  textSize(24*GUIScaleW);
  fill(color(0, 255, 0));
  fill(DebugC);
  text(GUIDebug, 5, height-10);

  //tells User if the image is too large for this program
  if (image.width*image.height>=256*256) {
    fill(255, 0, 0);
    String s = "Image is quite big. This could cause lag!";
    textSize(24*GUIScaleW);
    text(s, width-textWidth(s), height-10);
  }

  try {
    if (oldWidth != width || oldHeight != height) {
      loadGUI();
      oldWidth = width;
      oldHeight = height;
    }

    if (mousePressed) {
      mouseIsPressed();
    }

    if (history.size()<6) {
      int w = 0;
      for (int i = 0; i < history.size(); i++) {
        if (history.get(i).width>=history.get(i).height) {
          image(history.get(i), GUIScaleW*w, GUIScaleH*950, GUIScaleW*40, (history.get(i).height*1f/history.get(i).width)*GUIScaleH*40);
          w += 40;
        } else {
          image(history.get(i), GUIScaleW*w, GUIScaleH*950, (history.get(i).width*1f/history.get(i).height)*GUIScaleW*40, GUIScaleH*40);
          w += (history.get(i).width*1f/history.get(i).height)*40;
        }
      }
    } else {
      int w = 0;
      for (int i = 0; i < 5; i++) {
        if (history.get(i).width>=history.get(i).height) {
          image(history.get(history.size()-5+i), GUIScaleW*w, GUIScaleH*950, GUIScaleW*40, (history.get(history.size()-5+i).height*1f/history.get(history.size()-5+i).width)*GUIScaleH*40);
          w += 40;
        } else {
          image(history.get(history.size()-5+i), GUIScaleW*w, GUIScaleH*950, (history.get(history.size()-5+i).width*1f/history.get(history.size()-5+i).height)*GUIScaleW*40, GUIScaleH*40);
          w +=(history.get(history.size()-5+i).width*1f/history.get(history.size()-5+i).height)*40;
        }
      }
    }
  }
  catch(Exception e) {
    println("[Draw] Error while calculating oldWidth, mouseIsPressed() and rendering History: "+e);
    DebugC = color(255, 0, 0);
    GUIDebug = "Error while rendering History";
  }
}

//returns an Image that recreates an Image with a Color-pallet (only with specific colors)
PImage matchPicture(PImage img, Color[] pallet) {
  ColorPicture pixelArray = new ColorPicture(img);
  for (int y = 0; y < img.height; y++) {
    for (int x = 0; x < img.width; x++) {
      pixelArray.setC(matchColor(pallet, pixelArray.getC(x, y)), pixelArray.getZ(x, y));
    }
  }
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
  addHistory();
  image = matchPicture(image, Pallet.colors);
  thread("updateHighRes");
  println("[matchP] Matched image with pallet");
  DebugC = color(0, 255, 0);
  GUIDebug = "Matched image";
}

void mousePressed() {
  tf_Import.pressed(mouseX, mouseY);
  tf_Save.pressed(mouseX, mouseY);
  tf_Change.pressed(mouseX, mouseY);

  s.Pressed();

  //every frame the mouse is pressed, the coordinates of the mouse get stored to calculate the offset while grabbing
  if (touchGUI || (isPencil && Pallet.isOneColorSelected&&isInImage())) {
    offSet = false;
  } else {
    offSet = true;
  }
  startOfset = new PVector(mouseX, mouseY);
}

void mouseIsPressed() {
  if (isInImage()) {
    if (isPencil && Pallet.isOneColorSelected&&Pallet.inPallet(mouseX, mouseY)==false &&(key!=' '||keyPressed==false)&& touchGUI == false && s.selected == false) {
      try {
        image.loadPixels();
        PVector v = getCoordinatesInImage(mouseX, mouseY);
        if (image.pixels[int(v.x+v.y*image.width)] != Pallet.getPickedColor()) {
          //println("r: "+red(image.pixels[int(v.x+v.y*image.width)])+" g: "+green(image.pixels[int(v.x+v.y*image.width)])+" b: "+blue(image.pixels[int(v.x+v.y*image.width)]) + " | r: "+red(Pallet.getPickedColor())+" g: "+green(Pallet.getPickedColor())+" b: "+blue(Pallet.getPickedColor()));
          addHistory();
          image.pixels[int(v.x+v.y*image.width)] = Pallet.getPickedColor();
          image.updatePixels();
          //println("set: "+int(v.x)+";"+int(v.y)+" to "+"r: "+red(Pallet.getPickedColor())+" g: "+green(Pallet.getPickedColor())+" b: "+blue(Pallet.getPickedColor()));
          int resolutionHighRes = int((1f/image.width)*1600); //calculates and stores the width and height of one pixel in highRes-Image
          highRes.loadPixels();
          for (int i = 0; i < resolutionHighRes; i++) { //draws changed Pixel onto highRes-Image
            for (int j = 0; j <  resolutionHighRes; j++) {
              highRes.pixels[int(v.x*resolutionHighRes+v.y*image.width*resolutionHighRes*resolutionHighRes)+i*resolutionHighRes*image.width+j] = Pallet.getPickedColor();
            }
          }
          highRes.updatePixels();
          image.save(savePath("auto save/last_session_"+day()+"-"+month()+"-"+year()+"_"+hour()+".png"));
          image.save(savePath("auto save/last_session.png"));
          //thread("updateHighRes");
        }
      }
      catch(Exception e) {
        println("[mouseIsPressed] Error while painting on Image: "+e);
        DebugC = color(255, 0, 0);
        GUIDebug = "Error while painting on image";
      }
    }
  }
}

void keyPressed() {
  tf_Import.txtBox.KeyPressed(key, keyCode);
  tf_Save.txtBox.KeyPressed(key, keyCode);
  tf_Change.txtBox.KeyPressed(key, keyCode);
  if (key == DELETE) {
    if (Pallet.isOneColorSelected) {
      Pallet.deleteColor(Pallet.colorPicked);
    }
  }
}

void mouseDragged() {
  s.Dragged();

  //every frame the mouse gets dragged, a temporary offset gets calculated to add it to offset after mouse gets released

  if (offSet || (key == ' ' && keyPressed)) {
    ofsetTemp = new PVector((mouseX-startOfset.x), (mouseY-startOfset.y));
  } else {
    ofsetTemp = new PVector(0, 0);
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
        Color c = pixelArray.getC(floor(v.x), floor(v.y));
        int i = 0;
        for (Color col : Pallet.colors) {
          if (c.red == col.red && c.green == col.green && c.blue == col.blue) {
            Pallet.deleteColor(i);
          }
          i++;
        }
        Pallet.addColor(c);


        isColorPicking = !isColorPicking;
        b_Pick_Color.pictureChange();
      }
      catch(Exception e) {
        println("[mouseReleased] Error while adding picked Color of Image: "+e);
        DebugC = color(255, 0, 0);
        GUIDebug = "Error while adding picked color of image";
      }
    }
  }
  //adds the temporary Ofset between click and release to offset and clears ofsetTemp
  ofset = new PVector(ofset.x+ofsetTemp.x, ofset.y+ofsetTemp.y);
  ofsetTemp = new PVector(0, 0);

  //sets limits to offset
  if (ofset.x>5*width) {
    ofset.x = 5*width;
  }
  if (ofset.y>5*height) {
    ofset.y = 5*height;
  }
  if (ofset.x<-5*width) {
    ofset.x = -5*width;
  }
  if (ofset.y<-5*height) {
    ofset.y = -5*height;
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

  if (b_Back.touch() && mouseButton == LEFT) {
    if (history.size() > 0) {
      image = history.get(history.size()-1);
      history.remove(history.size()-1);
      thread("updateHighRes");
      DebugC = color(0, 255, 0);
      GUIDebug = "Undo";
    }
  }

  if (layer == 0) {//[Button pressed layer 0]

    if (b_Import.touch() && mouseButton == LEFT) {
      PImage img = image;
      try {
        addHistory();
        image = loadImage(tf_Import.txtBox.Text);
        if (image != null) {
          thread("updateHighRes");
          DebugC = color(0, 255, 0);
          GUIDebug = "Successfully loaded Picture named: " + tf_Import.txtBox.Text;
          println("[MouseReleased] [layer==0] Picture successfully loaded: "+tf_Import.txtBox.Text);
        } else {
          history.remove(history.size()-1);
          image = img;
          DebugC = color(255, 0, 0);
          GUIDebug = "No image found to import named: " + tf_Import.txtBox.Text;
          println("[MouseReleased] [layer==0] No image found to import!");
        }
      }
      catch(Exception e) {
        println("[MouseReleased] [layer==0] Error while importing Image (Button-press): "+e);
        DebugC = color(255, 0, 0);
        GUIDebug = "Error while importing image: " + tf_Import.txtBox.Text;
      }
    }


    if (b_Match.touch()&&mouseButton==LEFT) {
      thread("matchP");
    }


    if (b_Save.touch()&&mouseButton==LEFT) {
      try {
        image.save("saved Images/"+tf_Save.txtBox.Text+".png");
        thread("saveHighRes");
        DebugC = color(0, 255, 0);
        GUIDebug = "Successfully stored Picture as: "+tf_Save.txtBox.Text+".png";
        println("[MouseReleased] [layer==0] Picture successfully saved: "+tf_Save.txtBox.Text+".png");
      }
      catch(Exception e) {
        println("[MouseReleased] [layer==0] Error while saving Image: "+e);
        DebugC = color(255, 0, 0);
        GUIDebug = "Error while saving image";
      }
    }


    if (b_Change.touch() && mouseButton == LEFT) {
      addHistory();

      String s = tf_Change.txtBox.Text;
      int w = int(s.substring(0, s.indexOf(";")));
      int h = int(s.substring(s.indexOf(";")+1, s.length()));
      PGraphics pg = createGraphics(w, h);
      pg.beginDraw();
      pg.image(highRes, 0, 0, w, h);
      pg.endDraw();

      image = pg;
      thread("updateHighRes");
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
      addHistory();
      image = Filter.relief(image);
      thread("updateHighRes");
    }


    if (b_Sharpen.touch() && mouseButton == LEFT) {
      addHistory();
      image = Filter.sharpen(image);
      thread("updateHighRes");
    }


    if (b_Black_And_White.touch() && mouseButton == LEFT) {
      addHistory();
      image = Filter.Black_And_White(image);
      thread("updateHighRes");
    }


    if (b_Edges.touch() && mouseButton == LEFT) {
      addHistory();
      image = Filter.edges(image);
      thread("updateHighRes");
    }

    if (b_Blur.touch() && mouseButton == LEFT) {
      addHistory();
      image = Filter.blur(image, 3, 3);
      thread("updateHighRes");
    }

    if (b_Invert.touch() && mouseButton == LEFT) {
      addHistory();
      image = Filter.Invert(image);
      thread("updateHighRes");
    }


    if (b_Rotate.touch() && mouseButton == LEFT) {//[Edit Buttons]
      addHistory();
      image = Filter.Rotate(image);
      thread("updateHighRes");
    }


    if (b_Mirror_v.touch() && mouseButton == LEFT) {//[Edit Buttons]
      addHistory();
      image = Filter.Mirror_v(image);
      thread("updateHighRes");
    }


    if (b_Mirror_h.touch() && mouseButton == LEFT) {//[Edit Buttons]
      addHistory();
      image = Filter.Mirror_h(image);
      thread("updateHighRes");
    }
  }
  if (layer == 1) {//[Button pressed layer 1] [ni]
    if (b_Import.touch() && mouseButton == LEFT) {//[Edit Buttons]
      Pallet.loadPallet(tf_Import.txtBox.Text);
    }
    if (b_Img_Pallet.touch() && mouseButton == LEFT) {//[Edit Buttons]
      Pallet.loadPalletWithImage(image);
    }
    if (b_Save.touch() && mouseButton == LEFT) {//[Edit Buttons]
      Pallet.savePallet(tf_Save.txtBox.Text, image);
    }
    if (b_Clear_Pallet.touch() && mouseButton == LEFT) {//[Edit Buttons]
      Pallet.clearPallet();
    }
    if (b_Sort_Colors.touch() && mouseButton == LEFT) {//[Edit Buttons]
      Pallet.sortColors();
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
    }
    if (b_XY.touch() && mouseButton == LEFT) {//[Edit Buttons]
      isXY= !isXY;
      b_XY.pictureChange();
    }
  }
}

void saveHighRes() {
  try {
    highRes.save("saved Images/"+tf_Save.txtBox.Text+"-HighRes.png");
    if (isGrid || isRGB || isXY) {
      PImage img = highRes;
      PGraphics pg = createGraphics(img.width, img.height);
      pg.beginDraw();

      pg.image(img, 0, 0);
      if (isGrid) {
        pg.image(drawGrid(image, img.width, img.height), 0, 0);
      }
      if (isXY || isRGB) {
        pg.image(drawXYRGB(image, img.width, img.height), 0, 0);
      }
      pg.endDraw();
      pg.save("saved Images/"+tf_Save.txtBox.Text+"-HighRes-Render.tga");
    }
    println("[saveHighRes] Saved Image in highRes");
  }
  catch(Exception e) {
    println("[saveHighRes] Error while saving HighRes-image: "+e);
    DebugC = color(255, 0, 0);
    GUIDebug = "Error while saving High-Resolution-Image";
  }
}

void addHistory() {
  PGraphics pg = createGraphics(image.width, image.height);
  pg.beginDraw();
  pg.image(image, 0, 0);
  pg.endDraw();
  history.add(pg);
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
    println("[drawImage] highRes = "+highRes);
    println("[drawImage] img = "+img + "; width = "+img.width+"; height = "+img.height);
  }
  try {
    x=x-w/2;
    y=y-h/2;
    if (isGrid && w*1f/img.width > 4) {
      renderGrid(1, img, x, y, w, h);
    } else if (isGrid && w*1f/img.width > 3) {
      renderGrid(2, img, x, y, w, h);
    } else if (isGrid && w*1f/img.width > 2) {
      renderGrid(4, img, x, y, w, h);
    } else if (isGrid && w*1f/img.width > 1) {
      renderGrid(8, img, x, y, w, h);
    } else if (isGrid && w*1f/img.width > 0.5) {
      renderGrid(16, img, x, y, w, h);
    } else if (isGrid) {
      renderGrid(32, img, x, y, w, h);
    }
    ColorPicture CP = new ColorPicture(img);
    if ((isXY||isRGB) && w/img.width > 8) {
      int startX = int((-x*img.width)/w);
      int startY = int((-y*img.height)/h);
      if (startX<1) startX = 0;
      if (startY<1) startY = 0;
      int endX = int((img.width*(width-x))/w)+2;
      int endY = int((img.height*(height-y))/h)+2;
      if (endX > img.width) endX = img.width;
      if (endY > img.height) endY = img.height;
      for (int j = startY; j < endY; j++) {
        for (int i = startX; i < endX; i++) {
          color c = CP.getC(i, j).getColor();
          if (brightness(c)>128) {
            fill(0);
          } else {
            fill(255);
          }
          if (isXY) {
            textAlign(CORNER);
            textSize((w/img.width)/4);
            text(i+";"+j, x+i*(w/img.width), y+j*(h/img.height)+(w/img.width)/5);
          }
          if (isRGB) {
            textSize((w/img.width)/5);
            textAlign(CENTER);
            text(int(red(c)), x+i*(w/img.width)+(w/img.width)/2, y+j*(h/img.height)+(w/img.width)/2);
            text(int(green(c)), x+i*(w/img.width)+(w/img.width)/2, y+j*(h/img.height)+(w/img.width)/2+(w/img.width)/6);
            text(int(blue(c)), x+i*(w/img.width)+(w/img.width)/2, y+j*(h/img.height)+(w/img.width)/2+(w/img.width)/3);
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

void renderGrid(int space, PImage img, float x, float y, float w, float h) {
  strokeWeight(0.5);
  stroke(0);
  fill(0);
  int startX = int((-x*img.width)/w)+1;
  int startY = int((-y*img.height)/h)+1;
  if (startX<1) startX = 1;
  if (startY<1) startY = 1;
  int endX = int((img.width*(width-x))/w)+1;
  int endY = int((img.height*(height-y))/h)+1;
  if (endX > img.width) endX = img.width;
  if (endY > img.height) endY = img.height;
  for (int i = startX; i < endX; i+=space) {
    line(x+i*(w/img.width), y, x+i*(w/img.width), y+h);
  }
  for (int i = startY; i < endY; i+=space) {
    line(x, y+i*(h/img.height), x+w, y+i*(h/img.height));
  }
}

PImage drawGrid(PImage img, float w, float h) {
  try {
    PGraphics pg = createGraphics(int(w), int(h));
    pg.beginDraw();
    pg.strokeWeight(0.5);
    pg.stroke(0);
    pg.fill(0);
    for (int i = 1; i < img.width; i++) {
      pg.line(i*(w/img.width), 0, i*(w/img.width), h);
    }
    for (int i = 1; i < img.width; i++) {
      pg.line(0, i*(h/img.height), w, i*(h/img.height));
    }
    pg.endDraw();
    return pg;
  }
  catch(Exception e) {
    println("[drawGrid] Error while creating Grid-Image: "+e);
    PGraphics pg = createGraphics(int(w), int(h));
    pg.image(img, pg.width, pg.height);
    return pg;
  }
}

PImage drawXYRGB(PImage img, float w, float h) {
  ColorPicture CP = new ColorPicture(img);
  PGraphics pg = createGraphics(int(w), int(h));
  if (isXY || isRGB) {
    pg.beginDraw();
    for (int j = 0; j < img.height; j++) {
      for (int i = 0; i < img.width; i++) {
        color c = CP.getC(i, j).getColor();
        if (brightness(c)>128) {
          pg.fill(0);
        } else {
          pg.fill(255);
        }
        if (isXY) {
          pg.textAlign(CORNER);
          pg.textSize((w/img.width)/4);
          pg.text(i+";"+j, i*(w/img.width), j*(h/img.height)+(w/img.width)/5);
        }
        if (isRGB) {
          pg.textSize((w/img.width)/5);
          pg.textAlign(CENTER);
          pg.text(int(red(c)), i*(w/img.width)+(w/img.width)/2, j*(h/img.height)+(w/img.width)/2);
          pg.text(int(green(c)), i*(w/img.width)+(w/img.width)/2, j*(h/img.height)+(w/img.width)/2+(w/img.width)/6);
          pg.text(int(blue(c)), i*(w/img.width)+(w/img.width)/2, j*(h/img.height)+(w/img.width)/2+(w/img.width)/3);
        }
      }
    }
    pg.endDraw();
  }
  return pg;
}

void updateHighRes() {
  try {
    if (image == null) {
      println("[updateHighRes] No image found to upadte highRes!");
    }
    int resolutionHighRes = int((1f/image.width)*1600);
    highRes = createHighRes(resolutionHighRes);
    image.save(savePath("auto save/last_session_"+day()+"-"+month()+"-"+year()+"_"+hour()+".png"));
    image.save(savePath("auto save/last_session.png"));
  }
  catch(Exception e) {
    println("[updateHighRes] Error while creating a highRes-Image: "+e);
  }
}

PImage createHighRes(int res) {
  PGraphics pg;
  pg = createGraphics(int(image.width*res), int(image.height*res));
  pg.beginDraw();
  pg.image(image, 0, 0, image.width*res, image.height*res);
  image.loadPixels();
  pg.noStroke();
  for (int i = 0; i < image.height; i++) {
    for (int j = 0; j < image.width; j++) {
      pg.fill(image.pixels[i*image.width+j]);
      pg.rect(j*(image.width*res/image.width), i*(image.height*res/image.height), (image.width*res/image.width), (image.height*res/image.height));
      //fill(255-floor(((i*image.width+j)/((image.height*image.width)*1f))*255f), floor(((i*image.width+j)/((image.height*image.width)*1f))*100f), 0);
    }
  }
  pg.endDraw();
  return pg;
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
    I_Back = loadImage("Buttons/Back.png");

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
    I_Invert = loadImage("Buttons/Invert.png");
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
    b_Invert.setHitbox(b);

    b_Rotate.setHitbox(b);
    b_Mirror_v.setHitbox(b);
    b_Mirror_h.setHitbox(b);

    b_Filter.setHitbox(b);
    b_Edit.setHitbox(b);

    b_Match.setHitbox(b);
    b_Change.setHitbox(b);
    b_Save.setHitbox(b);
    b_Import.setHitbox(b);

    tf_Import.setHitbox(b);
    tf_Save.setHitbox(b);
    tf_Change.setHitbox(b);
  }

  if (lay == 1) {
    b_Import.setHitbox(b);
    b_Img_Pallet.setHitbox(b);
    b_Save.setHitbox(b);
    b_Clear_Pallet.setHitbox(b);
    b_Sort_Colors.setHitbox(b);
    b_Pick_Color.setHitbox(b);
    b_Switch.setHitbox(b);
    tf_Import.setHitbox(b);
    tf_Save.setHitbox(b);
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
    b_Invert.setHitbox(b);
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
  if (image.height/image.width<image.width/image.height) {
    return (image.width/image.height)*width*4*(s.scale/16)*image.width*6*s.scale+20;
  } else {
    return (image.height/image.width)*height*4*(s.scale/16)*image.height*6*s.scale+20;
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
  b_Back = new Button(true, I_Back, false, int(GUIScaleW*(width-70)), int(GUIScaleH*(height-127-48)), int(GUIScaleW*60), int(GUIScaleH*38), false);

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
  b_Invert = new Button(true, I_Invert, false, int(GUIScaleW*1730), int(GUIScaleH*(60+48*5)), int(GUIScaleW*60), int(GUIScaleH*38), false);

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
  Pallet = new ColorPallet(Pallet.colors, 0, height-int(GUIScaleH*80), width, int(GUIScaleW*30), false);
  println("[loadGUI] Loaded GUI");
}

void setTouchGUI() {
  touchGUI = false;

  Button[] b = new Button[29];
  b[0] = b_m_Image;
  b[1] = b_m_Pallet;
  b[2] = b_m_Rendering;
  b[3] = b_Pencil;
  b[4] = b_Import;
  b[5] = b_Match;
  b[6] = b_Save;
  b[7] = b_Change;
  b[8] = b_Filter;
  b[9] = b_Edit;
  b[10] = b_Relief;
  b[11] = b_Sharpen;
  b[12] = b_Black_And_White;
  b[13] = b_Edges;
  b[14] = b_Blur;
  b[15] = b_Invert;
  b[16] = b_Rotate;
  b[17] = b_Mirror_h;
  b[18] = b_Mirror_v;
  b[19] = b_Img_Pallet;
  b[20] = b_Clear_Pallet;
  b[21] = b_Sort_Colors;
  b[22] = b_Pick_Color;
  b[23] = b_Switch;
  b[24] = b_Grid;
  b[25] = b_Pixel_Mode;
  b[26] = b_RGB;
  b[27] = b_XY;
  b[28] = b_Back;

  TextField[] tf = new TextField[3];
  tf[0] = tf_Import;
  tf[1] = tf_Save;
  tf[2] = tf_Change;

  for (Button bn : b) {
    if (bn.touch()) {
      touchGUI = true;
    }
  }
  for (TextField tfn : tf) {
    if (tfn.touch()) {
      touchGUI = true;
    }
  }

  if (s.touch()) {
    touchGUI = true;
  }

  if (Pallet.inPallet(mouseX, mouseY)) {
    touchGUI = true;
  }
}
