class Slider {
  int x, y, w, h;
  PImage bg, off, on;
  boolean selected, useBG, useB, pressed; //useBG: says if a Background-image is used
  float scale;
  float step = 0.001920;

  Slider(int x, int y) {
    this.x=x;
    this.y=y;
  }

  Slider(int x, int y, int w, int h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.useBG=false;
    this.useB=false;
  }

  Slider(int x, int y, int w, int h, PImage bg) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.bg=bg;
    this.useBG=true;
    this.useB=false;
  }

  Slider(PImage on, int x, int y, int w, int h) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.on=on;
    this.useBG=false;
    this.useB=true;
  }

  Slider(int x, int y, int w, int h, PImage bg, PImage on) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.on=on;
    this.bg=bg;
    this.useBG=true;
    this.useB=true;
  }

  void show() {
    color c;
    if (pressed) {
      tint(150, 150, 200);
    } else {
      noTint();
    }

    if (pressed) {
      c=color(150, 150, 200);
    } else {
      c=color(175, 175, 175);
    }

    if (useBG) {
      image(bg, x, y, w, h);
    } else {
      fill(c);
      stroke(c);
      strokeWeight(h);
      line(x, y+h/2, x+w, y+h/2);
      strokeWeight(0);
    }
    if (useB) {
      image(on, x+(w-h)*scale, y, h, h);
    } else {
      fill(0);
      strokeWeight(0);
      ellipse(x+w*scale, y+h/2, h, h);
    }
    noTint();
  }

  boolean touch() {
    if (mouseX>=x-h/2&&mouseX<=x+w+h/2&&mouseY>=y&&mouseY<=y+h) {
      return true;
    }
    return false;
  }

  void Pressed() {
    if (touch()) {
      pressed = true;
    }
    s.Dragged();
  }

  void Released() {
    pressed=false;
  }

  void Dragged() {
    if (touch()) {
      selected = true;
    } else {
      selected = false;
      if (mousePressed&&pressed) {
        selected=true;
      }
    }
    if (selected) {
      if (mouseX<=x) {
        scale=0;
      }
      if (mouseX>=x+w) {
        scale=1;
      }
      if (mouseX>=x&&mouseX<=x+w) {
        float a = mouseX-x;
        scale = a  / w;
        scale = round(scale/step)*step;
      }
    }
  }
}
