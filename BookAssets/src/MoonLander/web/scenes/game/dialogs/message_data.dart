part of moonlander;

class MessageData {
  static const int UNKNOWN = -1;

  static const int SHOW = 100;
  static const int HIDE = 101;
  static const int TOGGLED_ON = 102;
  static const int TOGGLED_OFF = 103;
  static const int CLICKED = 104;

  static const int DIALOG = 200;
  static const int POPUP = 201;
  static const int BUTTON = 202;

  bool handled = false;
  
  int actionData = UNKNOWN;
  int whatData = UNKNOWN;
  
  String data = "";
  
  static const int YES = 300;
  static const int NO = 301;

  int choice = UNKNOWN;

  @override
  String toString() {
    return "action: ${actionData}, what: ${whatData}, data: ${data}, choice: ${choice}";
  }
}
