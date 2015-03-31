part of moonlander;

class ResetPopupDialog extends YesNoPopupDialog {
  Ranger.TextNode _line1;
  Ranger.TextNode _line2;
  Ranger.TextNode _line3;
  Ranger.TextNode _line4;
  Ranger.TextNode _line5;
  
  ResetPopupDialog();
 
  factory ResetPopupDialog.withSize([int width, int height]) {
    ResetPopupDialog layer = new ResetPopupDialog()
      ..autoInputs = false
      ..init(width, height);
    return layer;
  }

  @override
  bool init([int width, int height]) {
    if (super.init(width, height)) {
    }
    
    return true;
  }

  void _listenToBus() {
  }
  
  void setMessage(String msg, int line, double scale, double px, double py, Ranger.Color4<int> color) {
    Ranger.TextNode textNode;
    switch (line) {
      case 1: textNode = _line1; break;
      case 2: textNode = _line2; break;
      case 3: textNode = _line3; break;
      case 4: textNode = _line4; break;
      case 5: textNode = _line5; break;
    }

    textNode..text = msg
      ..uniformScale = scale
      ..color = color
      ..setPosition(px, py);
  }
  
  @override
  void _configure() {
    super._configure();
    
    double dw = ranger.designSize.width;
    double dh = ranger.designSize.height;

    double centerOffsetX = -_width / 2.0;
    double centerOffsetY = -_height / 2.0;
    
    _line1 = new Ranger.TextNode.initWith(Ranger.Color4IBlack)
      ..font = "normal 1000 10px Verdana"
      ..uniformScale = 2.0;
    _anchor.addChild(_line1);
    _line2 = new Ranger.TextNode.initWith(Ranger.Color4IBlack)
      ..font = "normal 1000 10px Verdana"
      ..uniformScale = 2.0;
    _anchor.addChild(_line2);
    _line3 = new Ranger.TextNode.initWith(Ranger.Color4IBlack)
      ..font = "normal 1000 10px Verdana"
      ..uniformScale = 2.0;
    _anchor.addChild(_line3);
    _line4 = new Ranger.TextNode.initWith(Ranger.Color4IBlack)
      ..font = "normal 1000 10px Verdana"
      ..uniformScale = 2.0;
    _anchor.addChild(_line4);
    _line5 = new Ranger.TextNode.initWith(Ranger.Color4IBlack)
      ..font = "normal 1000 10px Verdana"
      ..uniformScale = 2.0;
    _anchor.addChild(_line5);
  }
}