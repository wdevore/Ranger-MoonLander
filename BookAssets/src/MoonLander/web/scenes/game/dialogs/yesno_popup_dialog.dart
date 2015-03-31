part of moonlander;

abstract class YesNoPopupDialog extends Dialog {
  static const int TWEEN_SCALE = 1;

  double _width = 0.0;
  double _height = 0.0;
  
  RoundRectangleNode _background;
  
  // "Let's rethink this"
  BasicButton _cancel;  // chicken
  
  // "Life's short"
  BasicButton _accept;  // Nuke
  
  Ranger.GroupNode _anchor;
  
  @override
  bool init([int width, int height]) {
    if (super.init(width, height)) {
      _width = width.toDouble();
      _height = height.toDouble();

      transparentBackground = true;
      tag = 1001;
      
      _configure();
      _listenToBus();
    }
    
    return true;
  }

  void _listenToBus() {
  }
  
  set width(double v) => _width = v;
  double get width => _width;
  
  set height(double v) => _height = v;
  double get height => _height;
  
  set backgroundColor(Ranger.Color4<int> c) => _background.fillColor = c.toString();
  set outlineColor(Ranger.Color4<int> c) => _background.outlineColor = c.toString();
  set cornerRadius(double r) => _background.cornerRadius = r;
  set acceptCaption(String s) => _accept.caption = s;
  set cancelCaption(String s) => _cancel.caption = s;
  
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
        gm.playSound(gm.clickSoundId);
        MessageData md = new MessageData();
        md.actionData = MessageData.HIDE;
        md.whatData = MessageData.DIALOG;
        md.data = "ConfirmReset";
        md.choice = MessageData.NO;
        ranger.eventBus.fire(md);
        return true;
      }
    }
    
    if (!clicked) {
      clicked = _accept.check(event.offset.x, event.offset.y);
      if (clicked) {
        gm.playSound(gm.clickSoundId);
        MessageData md = new MessageData();
        md.actionData = MessageData.HIDE;
        md.whatData = MessageData.DIALOG;
        md.data = "ConfirmReset";
        md.choice = MessageData.YES;
        ranger.eventBus.fire(md);
        return true;
      }
    }
    
    return clicked;
  }

  void _configure() {
    double dw = ranger.designSize.width;
    double dh = ranger.designSize.height;

    _anchor = new Ranger.GroupNode();
    
    addChild(_anchor);
    _anchor.setPosition(dw / 2.0, dh / 2.0);

    double centerOffsetX = -_width / 2.0;
    double centerOffsetY = -_height / 2.0;
    
    _background = new RoundRectangleNode.basic(Ranger.color4IFromHex("#866761"))
      ..outlineColor = Ranger.color4IFromHex("B2FF59").toString()
      ..width = _width
      ..height = _height
      ..setPosition(centerOffsetX, centerOffsetY);
    _anchor.addChild(_background);
    
    Ranger.SpriteImage chicken = new Ranger.SpriteImage.withElement(gm.resources.chicken)
      ..uniformScale = 0.8;
    _cancel = new BasicButton.basic(300.0, 100.0)
      ..backgroundFillColor = Ranger.color4IFromHex("E0E0E0").toString()
      ..backgroundOutlineColor = Ranger.color4IFromHex("616161").toString()
      ..setPosition(centerOffsetX + 550.0, centerOffsetY + 50.0)
      ..captionColor = Ranger.color4IFromHex("424242")
      ..captionOffset.setValues(30.0, 40.0)
      ..setIcon(chicken, 250.0, 50.0)
      ..construct();
    _anchor.addChild(_cancel);
    
    Ranger.SpriteImage nuke = new Ranger.SpriteImage.withElement(gm.resources.nuke)
      ..uniformScale = 1.5;
    _accept = new BasicButton.basic(300.0, 100.0)
      ..backgroundFillColor = Ranger.color4IFromHex("616161").toString()
      ..backgroundOutlineColor = Ranger.color4IFromHex("FFFF8D").toString()
      ..setPosition(centerOffsetX + 100.0, centerOffsetY + 50.0)
      ..captionColor = Ranger.Color4IWhite
      ..captionOffset.setValues(30.0, 40.0)
      ..setIcon(nuke, 200.0, 50.0)
      ..construct();
    _anchor.addChild(_accept);
  }
  
  void focus(bool b) {
    if (b) {
      enableMouse = true;
      enableInputs();
    }
    else {
      disableInputs();
    }
  }
  
  void show() {
    // We enable mouse here instead of the onEnter method as we don't
    // want inputs enabled until the dialog is shown not when it is
    // created.
    focus(true);
    
    visible = true;
    
    _anchor.uniformScale = 0.25;

    ranger.animations.flush(this);

    UTE.Tween scaleUp = new UTE.Tween.to(this, TWEEN_SCALE, 1.0)
      ..targetValues = [1.0]
      ..easing = UTE.Elastic.OUT;
    ranger.animations.add(scaleUp);
    ranger.animations.track(this, TWEEN_SCALE);
  }

  void hide() {
    focus(false);
    ranger.animations.flush(this);
  }

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case TWEEN_SCALE:
        returnValues[0] = _anchor.uniformScale;
        return 1;
    }
    return 0;
  }
  
  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case TWEEN_SCALE:
        _anchor.uniformScale = newValues[0];
        break;
    }
  }

  
}