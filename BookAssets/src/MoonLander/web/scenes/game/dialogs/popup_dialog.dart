part of moonlander;

abstract class PopupDialog extends Dialog {
  static const int TWEEN_SCALE = 1;

  double _width = 0.0;
  double _height = 0.0;
  
  RoundRectangleNode _background;
  
  Ranger.GroupNode _anchor;
  
  @override
  bool init([int width = 0, int height = 0]) {
    if (super.init(width, height)) {
      _width = width.toDouble();
      _height = height.toDouble();

      transparentBackground = true;
    }
    
    return true;
  }

  void _listenToBus() {
  }

  Ranger.GroupNode get node => _anchor;

  set width(double v) {
    _width = v;
    _background.width = _width;
  }
  double get width => _width;

  set height(double v) {
    _height = v;
    _background.height = _height;
  }
  double get height => _height;
  
  set backgroundColor(Ranger.Color4<int> c) => _background.fillColor = c.toString();
  set outlineColor(Ranger.Color4<int> c) => _background.outlineColor = c.toString();
  set cornerRadius(double r) => _background.cornerRadius = r;

  @override
  void onEnter() {
    // For dialogs we don't enable inputs here for two reasons; one we
    // don't need inputs until the dialog is shown and two it would
    // cause duplicate enablement causing multiple events to be generated.
    super.onEnter();

    visible = false;
  }

  void _configure() {
    double dw = ranger.designSize.width;
    double dh = ranger.designSize.height;

    _anchor = new Ranger.GroupNode.basic();
    
    addChild(_anchor);

    double centerOffsetX = -_width / 2.0;
    double centerOffsetY = -_height / 2.0;
    
    _background = new RoundRectangleNode.basic(Ranger.color4IFromHex("#866761"))
      ..outlineColor = Ranger.color4IFromHex("B2FF59").toString()
      ..width = _width
      ..height = _height
      ..setPosition(centerOffsetX, centerOffsetY);
    _anchor.addChild(_background);
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
    // Let anyone else know we are showing this dialog
    MessageData md = new MessageData()
      ..actionData = MessageData.SHOW
      ..whatData = MessageData.DIALOG
      ..data = "VerifyQuit";
    ranger.eventBus.fire(md);

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
    visible = false;
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