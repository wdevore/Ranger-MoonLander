part of layer;

class MessageData {
  static const int TOTALORBITALS = 1;
  static const int SPEED = 2;
  static const int SCALE = 3;
  static const int RADIUSJITTER = 4;
  static const int HUEJITTER = 5;
  static const int CLEARALPHA = 6;
  static const int TOGGLEORBITALS = 7;
  static const int ORBITALALPHA = 8;
  static const int TOGGLELIGHT = 9;
  static const int LIGHTALPHA = 10;
  static const int RESET = 11;

  static const int UPDATEGUI = 12;

  SpinningStarsNode complex;

  int field = 0;
  String data = "";
}
