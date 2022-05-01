class TextField {
  Textbox txtBox;
  String text;
  int x, y, w, h;
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
    txtBox = new Textbox(x, y+w/2, w, h/2);
    txtBox.replaceText(box_text);
  }

  void display() {
    textSize(h/2.5);
    fill(255);
    text(text, x, y+h/2);
    txtBox.display();
  }

  void replaceText(String s) {
    txtBox.replaceText(s);
  }
}