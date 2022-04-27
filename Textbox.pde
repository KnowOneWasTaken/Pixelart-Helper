public class Textbox {
  int X = 0, Y = 0, H = 35, W = 200;
  int TEXTSIZE = 24;
  color bgC = color(140, 140, 140, 175); //background color
  color fgC = color(0, 0, 0, 175); //foreground color
  color bgSC = color(170, 170, 170, 175); //background-Color if selected
  color border = color(30, 30, 30, 175);

  boolean BorderEnabled = false;
  int BorderWeight = 5;

  String Text = "";
  int TextLength = 0;

  boolean isSelected = false;
  boolean expand = true;

  Textbox() {
  }

  Textbox(int x, int y, int w, int h) {
    X = x;
    Y = y;
    W = w;
    H = h;
    TEXTSIZE = int(GUIScaleW*24);
  }
  
  void replaceText(String s) {
    Text = s;
    TextLength = s.length();
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

    rect(X, Y, W+5, H);

    fill(fgC);
    textSize(TEXTSIZE);
    text(Text, X + (textWidth("a") / 2), Y + TEXTSIZE);
  }

  boolean KeyPressed(char Key, int Keycode) {
    if (isSelected) {
      if (Keycode == (int)BACKSPACE) {
        backspace();
      } else if (Keycode == 32) {
        addText(' ');
      } else if (Keycode == (int)ENTER) {
        isSelected = false;
        return true;
      } else {
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
      }
    }

    return false;
  }

  private void addText(char text) {
    if (textWidth(Text + text) < W) {
      Text += text;
      TextLength++;
    } else {
      if (expand&&(textWidth(text)*2+W+X)<=width) {
        W=int(textWidth(text)*2)+W;
        Text += text;
        TextLength++;
      }
    }
  }

  private void backspace() {
    if (TextLength - 1 >= 0) {
      Text = Text.substring(0, TextLength - 1);
      TextLength--;
      W=int(textWidth(Text)+textWidth("Q"));
    }
  }

  private boolean overBox(int x, int y) {
    if (x >= X && x <= X + W) {
      if (y >= Y && y <= Y + H) {
        return true;
      }
    }

    return false;
  }

  void pressed(int x, int y) {
    if (overBox(x, y)) {
      isSelected = true;
    } else {
      isSelected = false;
    }
  }
}
