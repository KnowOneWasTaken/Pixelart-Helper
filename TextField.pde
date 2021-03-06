class TextField {
  Textbox txtBox;
  String text;
  int x, y, w, h;
  private boolean hitbox = true;
  TextField(String text, int x, int y, int w, int h) {
    this.text = text;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    txtBox = new Textbox(x, y+h/2, w, h/2);
  }
  TextField(String text, int x, int y, int w, int h, String box_text) {
    this.text = text;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    txtBox = new Textbox(x, y+h/2, w, h/2, box_text);
  }

  void display() {
    textSize(h/2.5);
    fill(50, 50, 50, 100);
    noStroke();
    rect(x-GUIScaleW*3, y, textWidth(text + ' '), h/2+GUIScaleH*2);
    fill(255);
    text(text, x, y+h/2-h/12);
    txtBox.display();
  }

  void replaceText(String s) {
    txtBox.replaceText(s);
  }

  void pressed(int mX, int mY) {
    if (hitbox) {
      txtBox.pressed(mX, mY);
    }
  }

  void setHitbox(boolean b) {
    hitbox = b;
  }

  boolean getHitbox() {
    return hitbox;
  }

  boolean touch() {
    if (hitbox && txtBox.overBox(mouseX, mouseY)) {
      return true;
    } else {
      return false;
    }
  }
}
