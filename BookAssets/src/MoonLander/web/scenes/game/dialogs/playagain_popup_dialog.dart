part of moonlander;

class YesNoChoicePopupDialog extends PopupDialog {
  Ranger.TextNode _line1;
  Ranger.TextNode _line2;
  Ranger.TextNode _line3;
  Ranger.TextNode _line4;
  Ranger.TextNode _line5;

  BasicButton _cancel;
  
  BasicButton _accept;

  String data = "";

  @override
  bool init([int width = 0, int height = 0]) {
    if (super.init(width, height)) {
      _configure();
      _listenToBus();
    }
    
    return true;
  }

  void _listenToBus() {
  }
  
  set acceptCaption(String s) => _accept.caption = s;
  set cancelCaption(String s) => _cancel.caption = s;
  set buttonCaptionSize(double s) {
    _accept.captionNode.uniformScale = s;
    _cancel.captionNode.uniformScale = s;
  }

  void setAcceptTextPosition(double x, double y) => _accept.captionNode.setPosition(x, y);
  void setCancelTextPosition(double x, double y) => _cancel.captionNode.setPosition(x, y);

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
  void onEnter() {
    // For dialogs we don't enable inputs here for two reasons; one we
    // don't need inputs until the dialog is shown and two it would
    // cause duplicate enablement causing multiple events to be generated.
    super.onEnter();

    visible = false;
  }

  @override
  bool onMouseDown(MouseEvent event) {
    
    bool clicked = _cancel.check(event.offset.x, event.offset.y);
    if (clicked) {
      if (clicked) {
        hide();
        gm.playSound(gm.clickSoundId);
        MessageData md = new MessageData();
        md.actionData = MessageData.HIDE;
        md.whatData = MessageData.DIALOG;
        md.data = data;
        md.choice = MessageData.NO;
        ranger.eventBus.fire(md);
        return true;
      }
    }
    
    if (!clicked) {
      clicked = _accept.check(event.offset.x, event.offset.y);
      if (clicked) {
        hide();
        gm.playSound(gm.clickSoundId);
        MessageData md = new MessageData();
        md.actionData = MessageData.HIDE;
        md.whatData = MessageData.DIALOG;
        md.data = data;
        md.choice = MessageData.YES;
        ranger.eventBus.fire(md);
        return true;
      }
    }
    
    return clicked;
  }

  @override
  void _configure() {
    super._configure();

    double centerOffsetX = -_width / 2.0;
    double centerOffsetY = -_height / 2.0;
    
    _cancel = new BasicButton.basic(300.0, 100.0)
      ..backgroundFillColor = Ranger.color4IFromHex("E0E0E0").toString()
      ..backgroundOutlineColor = Ranger.color4IFromHex("616161").toString()
      ..setPosition(centerOffsetX + 550.0, centerOffsetY + 50.0)
      ..captionColor = Ranger.color4IFromHex("424242")
      ..captionOffset.setValues(30.0, 40.0)
      ..construct();
    _anchor.addChild(_cancel);
    
    _accept = new BasicButton.basic(300.0, 100.0)
      ..backgroundFillColor = Ranger.color4IFromHex("616161").toString()
      ..backgroundOutlineColor = Ranger.color4IFromHex("FFFF8D").toString()
      ..setPosition(centerOffsetX + 100.0, centerOffsetY + 50.0)
      ..captionColor = Ranger.Color4IWhite
      ..captionOffset.setValues(30.0, 40.0)
      ..construct();
    _anchor.addChild(_accept);

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