class Textbox {
  int textSize = 24;
  color bgSC = color(170, 170, 170, 175); //background-Color if selected
  color border = color(30, 30, 30, 175);
  int x = 0, y = 0, h = 35, w = 200;
  color bgC = color(140, 140, 140, 175); //background color
  color fgC = color(0, 0, 0, 175); //foreground color
  int min_w;
  boolean isNumberBox = false;

  boolean BorderEnabled = true;
  int BorderWeight = 5;

  String Text = "";
  int TextLength = 0;

  boolean isSelected = false;
  boolean expand = true;

  Textbox() {
  }

  Textbox(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    textSize = int(GUIScaleW*24);
    min_w = w;
  }

  Textbox(int x, int y, int w, int h, String s) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    textSize = int(GUIScaleW*24);
    replaceText(s);
    min_w = w;
  }

  void replaceText(String s) {
    Text = s;
    TextLength = s.length();
    //w=int(textWidth(Text)*2+textWidth("Q")*2);
    if (w<min_w) {
      w=min_w;
    }
  }

  void display() {
    if (isSelected) {
      fill(bgSC);
    } else {
      fill(bgC);
    }

    if (BorderEnabled) {
      strokeWeight(BorderWeight);
      stroke(border);
    } else {
      noStroke();
    }
    rect(x, y, w, h);
    fill(fgC);
    textSize(textSize);
    text(Text, x + (textWidth("a") / 2), y + textSize);
  }

  boolean KeyPressed(char Key, int Keycode) {
    if (isSelected) {
      if (Keycode == (int)BACKSPACE) {
        backspace();
      } else if (Keycode == 32) {
        if (!isNumberBox) {
          addText(' ');
        }
      } else if (Keycode == (int)ENTER) {
        isSelected = false;
        return true;
      } else if (!isNumberBox) {
        boolean isKeyCapitalLetter = (Key >= 'A' && Key <= 'Z');
        boolean isKeySmallLetter = (Key >= 'a' && Key <= 'z');
        boolean isKeyNumber = (Key >= '0' && Key <= '9');

        if (isKeyCapitalLetter || isKeySmallLetter || isKeyNumber) {
          addText(Key);
        }
        switch (key) {
        case '?':
          addText('?');
          break;
        case '!':
          addText('!');
          break;
        case '^':
          addText('^');
          break;
        case '°':
          addText('°');
          break;
        case '"':
          addText('"');
          break;
        case '²':
          addText('²');
          break;
        case '§':
          addText('§');
          break;
        case '³':
          addText('³');
          break;
        case '$':
          addText('$');
          break;
        case '%':
          addText('%');
          break;
        case '&':
          addText('&');
          break;
        case '/':
          addText('/');
          break;
        case '{':
          addText('{');
          break;
        case '(':
          addText('(');
        case '[':
          addText('[');
          break;
        case ')':
          addText(')');
          break;
        case ']':
          addText(']');
          break;
        case '=':
          addText('=');
          break;
        case '}':
          addText('}');
          break;
        case 'ß':
          addText('ß');
          break;
        case '´':
          addText('´');
          break;
        case '`':
          addText('`');
          break;
        case '+':
          addText('+');
          break;
        case '*':
          addText('*');
          break;
        case '~':
          addText('~');
          break;
        case '#':
          addText('#');
          break;
        case ',':
          addText(',');
          break;
        case ';':
          addText(';');
          break;
        case '.':
          addText('.');
          break;
        case ':':
          addText(':');
          break;
        case '-':
          addText('-');
          break;
        case '_':
          addText('_');
          break;
        case 'ä':
          addText('ä');
          break;
        case 'ü':
          addText('ü');
          break;
        case 'ö':
          addText('ö');
          break;
        case 'Ä':
          addText('Ä');
          break;
        case 'Ü':
          addText('Ü');
          break;
        case 'Ö':
          addText('Ö');
          break;
        }
      } else {
        boolean isKeyNumber = (Key >= '0' && Key <= '9');

        if (isKeyNumber) {
          addText(Key);
        }
        if (key == ';') {
          addText(';');
        }
      }
    }

    return false;
  }

  private void addText(char text) {
    textSize(textSize);
    if (textWidth(Text + text)+textWidth(text)*4 < w) {
      Text += text;
      TextLength++;
    } else {
      if (expand&&(textWidth(text)*2+w+x)<=width) {
        w=int(textWidth(Text + text)+textWidth(text));
        if (w<min_w) {
          w=min_w;
        }
        Text += text;
        TextLength++;
      }
    }
  }

  private void backspace() {
    textSize(textSize);
    if (TextLength - 1 >= 0) {
      Text = Text.substring(0, TextLength - 1);
      TextLength--;
      w=int(textWidth(Text)+textWidth("Q"));
      if (w<min_w) {
        w=min_w;
      }
    }
  }

  boolean overBox(int mX, int mY) {
    if (mX >= x && mX <= x + w) {
      if (mY >= y && mY <= y + h) {
        return true;
      }
    }

    return false;
  }

  void pressed(int mX, int mY) {
    if (overBox(mX, mY)) {
      isSelected = true;
    } else {
      isSelected = false;
    }
  }
}
