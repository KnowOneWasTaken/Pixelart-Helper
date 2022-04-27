class Button {
  PImage img, img2, img3, img4, storage;
  boolean bigB;
  int picture;
  int x;
  int y;
  int x2;
  int y2;
  int widthB;
  int heightB;
  boolean round;
  boolean help;
  int clicked;
  float groesse = 1;
  float bigTouch = 1.1;
  float bigClick = 0.9;
  float smallTouch=0.95;
  float smallClick=0.85;
  float step = 0.07;
  boolean hitbox = true;
  boolean secondImg = false;
  color c = color(150, 150, 200);

  void show() {
    x = x2;
    y = y2;
    show2();
  }

  void showMove(int xa, int ya) {
    x = xa;
    y = ya;
    show2();
    if (help) {
      println(bl()+"Button shown on: "+x+", "+y);
    }
  }

  void show2() {
    float Touch, Click;
    int w=widthB;
    int h = heightB;
    PImage pic;
    if (bigB) {
      Touch = bigTouch;
      Click = bigClick;
    } else {
      Touch = smallTouch;
      Click = smallClick;
    }
    switch (picture) {
    case 1:
      pic = img;
      break;
    case 2:
      pic = img2;
      break;
    default:
      pic = img;
      break;
    }
    if (touch()) {
      tint(c);
      if (mousePressed) {
        if (groesse<Click) {
          if (groesse+step<Click) {
            groesse+=step;
          } else {
            groesse=Click;
          }
        } else {
          if (groesse>Click) {
            if (groesse-step>Click) {
              groesse-=step;
            } else {
              groesse=Click;
            }
          }
        }
      } else {
        if (groesse<Touch) {
          if (groesse+step<Touch) {
            groesse+=step;
          } else {
            groesse=Touch;
          }
        } else {
          if (groesse>Touch) {
            if (groesse-step>Touch) {
              groesse-=step;
            } else {
              groesse=Touch;
            }
          }
        }
      }
    } else {
      if (groesse<1) {
        if (groesse+step<1) {
          groesse+=step;
        } else {
          groesse=1;
        }
      } else {
        if (groesse>1) {
          if (groesse-step>1) {
            groesse-=step;
          } else {
            groesse=1;
          }
        }
      }
    }
    if (secondImg==false) {
      if (pic!=null) {
        image(pic, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
      } else if(help) {
         println("Error: pic == null: x: " + x+"; y: "+y); 
      }
    } else {
      noTint();
      if (picture==1&&mousePressed==false) {
        image(img, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
      }
      if (picture==1&&mousePressed==true&&touch()) {
        image(img2, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
      }
      if (picture==2&&mousePressed==false) {
        image(img3, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
      }
      if (picture==2&&mousePressed==true&&touch()) {
        image(img4, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
      }
      if (picture==1&&mousePressed==true&&touch()==false) {
        image(img, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
      }
      if (picture==2&&mousePressed==true&&touch()==false) {
        image(img3, x+w*((1-groesse)/2), y+(h*(1-groesse)/2), w-(1-groesse)*w, h-(1-groesse)*h);
      }
    }
    noTint();
  }


  boolean touch() {
    if (hitbox) {
      boolean roundB = round;
      if (roundB==false) {
        int r = x+widthB;
        int b=y+heightB;
        if (mouseX<r && mouseX>x && mouseY<b&& mouseY>y) {
          return true;
        } else {
          return false;
        }
      } else {
        if (dist(mouseX, mouseY, x+widthB/2, y+heightB/2) < widthB/2) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }

  void setImg(PImage Pimage) {
    img = Pimage;
    if (help) {
      println(bl()+"img set to a new PImage");
    }
  }

  PImage getImg() {
    return img;
  }

  PImage getImg2() {
    return img2;
  }
  void setImg2(PImage Pimage) {
    img2 = Pimage;
    if (help) {
      println(bl()+"img2 set to a new PImage");
    }
  }
  void setImg(PImage Pimage, PImage Pimage2) {
    img = Pimage;
    img2 = Pimage2;
    if (help) {
      println(bl()+"img and img2 set to new PImage(s)");
    }
  }

  void setBig(float c, float t) {
    bigClick=c;
    bigTouch=t;
  }

  void setSmall(float c, float t) {
    smallClick=c;
    smallTouch=t;
  }

  void setStep(float c) {
    step=c;
  }

  void setHitbox(boolean b) {//boolean set Hitbox activated or diactivated
    hitbox=b;
  }

  void setXY(int xa, int ya) {
    x = xa;
    y = ya;
    x2=xa;
    y2=ya;
    if (help) {
      println(bl()+"x and y set to: "+x+", "+y);
    }
  }

  int getX() {
    return x;
  }

  int getY() {
    return y;
  }

  void setX(int xa) {
    x = xa;
    x2=xa;
    if (help) {
      println(bl()+"x set to: "+x);
    }
  }

  void setY(int ya) {
    y = ya;
    y2=ya;
    if (help) {
      println(bl()+"y set to: "+y);
    }
  }

  void setW(int w) {
    widthB=w;
    if (help) {
      println(bl()+"width set to: "+w);
    }
  }

  int getW() {
    return widthB;
  }
  void setH(int h) {
    heightB=h;
    if (help) {
      println(bl()+"height set to: "+y);
    }
  }
  int getH() {
    return heightB;
  }

  void setWH(int w, int h) {
    widthB = w;
    heightB = h;
    if (help) {
      println(bl()+"width and height set to: "+w+", "+h);
    }
  }

  void pictureChange() {//switches the picture
    if (picture == 1) {
      picture = 2;
    } else {
      picture = 1;
    }
    if (help) {
      println(bl()+"picture set to: "+picture);
    }
  }

  int getPicture() {
    return picture;
  }

  boolean getBig() {
    return bigB;
  }

  void setBig(boolean b) {
    bigB = b;
    if (help) {
      println(bl()+"bigB set to: "+bigB);
    }
  }

  boolean getRound() {//returns round
    return round;
  }

  void setRound(boolean b) {//sets the variable round to true or false
    round = b;
    if (help) {
      println(bl()+"round set to: "+round);
    }
  }

  void setPicture(int i) {//sets the picture to the integer
    if (i==1||i==2) {
      if ((picture == 1 && i == 1) || (picture == 2 && i ==2)) {
        if (help) {
          println(bl()+"picture didn't changed");
        }
      } else {
        picture = i;
        if (help) {
          println(bl()+"picture set to: "+picture);
        }
      }
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+i+ ", it must be 1 or 2");
      }
    }
  }

  void imgChange() {//switches the pictures
    storage = img;
    img = img2;
    img2=storage;
    if (help) {
      println(bl()+"Images switched");
    }
  }
  void clickedReset() {
    clicked = 0;
  }

  void clicked() {
    println(bl()+"Button clicked "+(clicked+1)+" time(s)");
    clicked++;
  }

  void clicked(boolean b) {
    if (b) {
      println(bl()+"Button clicked "+(clicked+1)+" time(s)");
    }
    clicked++;
  }

  int getClicked() {
    return clicked;
  }

  void setClicked(int i) {
    clicked = i;
  }

  String bl() {
    return "[Button-Libary] ";
  }

  void bl(String t) {
    println(bl()+t);
  }

  void standard() {
    secondImg=false;
    img3=img2;
    img4=img3;
  }

  Button(boolean bigBc, PImage imgc, boolean helpc, int xc, int yc, int widthBc, int heightBc, boolean roundc) {//bigB,standard with width, hight and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    picture = 1;
    bigB = bigBc;
    img2 = img;
    secondImg = false;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }

  Button(boolean bigBc, PImage imgc, PImage img2c, boolean helpc, int xc, int yc, int widthBc, int heightBc, int picturec, boolean roundc) {// bigB,standard with second image, width, height, picture and round
    img = imgc;
    x = xc;
    y = yc;
    widthB= widthBc;
    heightB=heightBc;
    round = roundc;
    if (picturec==1||picturec==2) {
      picture = picturec;
    } else {
      if (help) {
        println(bl()+"The picture can not be changed to "+picturec+ ", it must be 1 or 2");
      }
      picture=1;
    }
    bigB = bigBc;
    img2 = img2c;
    x2 = x;
    y2 =y;
    help = helpc;
    standard();
  }
}
