part of moonlander;

/**
 *
 */
class SlideOutDialog extends Dialog {
  static const int TWEEN_TRANSLATE_X = 1;
  static const int TWEEN_TRANSLATE_Y = 2;

  static const int FROM_TOP = 0;

  double _width = 0.0;
  double _height = 0.0;

  int direction = FROM_TOP;
  double slideDelta = 0.0;
  double slideInTime = 0.5;
  double slideOutTime = 0.25;

  RoundRectangleNode _background;
  
  Ranger.GroupNode _anchor;

  Ranger.TextNode _text;

  StreamSubscription<MessageData> _busStream;
  String _messageTrigger;

  SlideOutDialog() {
    name = "SlideOutDialog";
  }

  @override
  bool init([int width = 100, int height = 20]) {
    if (super.init(width, height)) {
      _width = width.toDouble();
      _height = height.toDouble();

      transparentBackground = true;

      _configure();
    }
    
    return true;
  }

  void listenToBus(String messageTrigger) {
    _messageTrigger = messageTrigger;

    _busStream = ranger.eventBus.on(MessageData).listen(
      (MessageData md) {
        if (md.handled)
          return;

        switch (md.whatData) {
          case MessageData.DIALOG:
            if (md.actionData == MessageData.SHOW) {
              if (md.data == messageTrigger) {
                direction = md.choice;
                show();
              }
            }
            if (md.actionData == MessageData.HIDE) {
              if (md.data == messageTrigger) {
                direction = md.choice;
                hide();
              }
            }
        }
      });
  }
  
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

  set text(String s) => _text.text = s;
  set textSize(double s) => _text.uniformScale = s;
  set textColor(Ranger.Color4<int> c) => _text.color = c;
  void setTextPosition(double x, double y) => _text.setPosition(x, y);

  @override
  void onEnter() {
    super.onEnter();

    //visible = false;
  }

  @override
  void onExit() {
    super.onExit();
    if (_busStream != null) {
      _busStream.cancel();
    }
  }

  void _configure() {
    //double dw = ranger.designSize.width;
    //double dh = ranger.designSize.height;

    _anchor = new Ranger.GroupNode.basic();
    
    addChild(_anchor);

    _background = new RoundRectangleNode.basic(Ranger.color4IFromHex("#808080"))
      ..cornerRadius = 0.0
      ..outlineColor = Ranger.color4IFromHex("ffffff").toString()
      ..width = _width
      ..height = _height;
    _anchor.addChild(_background);

    _text = new FadingTextNode.initWith(Ranger.Color4IOrange)
      ..text = ""
      ..font = "normal 200 10px Verdana"
      ..shadows = true;
    _anchor.addChild(_text);

  }

  @override
  void focus(bool b) {
    // This dialog has no focus.
  }

  void show() {
    visible = true;

    UTE.Tween moveBy = new UTE.Tween.to(this, TWEEN_TRANSLATE_Y, slideInTime)
      ..targetRelative = [-slideDelta]
      ..easing = UTE.Sine.OUT;
    ranger.animations.add(moveBy);
    //ranger.animations.flush(this);

    ranger.animations.track(this, TWEEN_TRANSLATE_Y);
  }

  void hide() {
    //ranger.animations.flush(this);
    UTE.Tween moveBy = new UTE.Tween.to(this, TWEEN_TRANSLATE_Y, slideOutTime)
      ..targetRelative = [slideDelta]
      ..callback = _hideComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE
      ..easing = UTE.Sine.IN;
    ranger.animations.add(moveBy);
  }

  void _hideComplete(int type, UTE.BaseTween source) {
    visible = false;
  }

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case TWEEN_TRANSLATE_X:
        returnValues[0] = position.x;
        return 1;
      case TWEEN_TRANSLATE_Y:
        returnValues[0] = position.y;
        return 1;
    }
    return 0;
  }
  
  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case TWEEN_TRANSLATE_X:
        positionX = newValues[0];
        break;
      case TWEEN_TRANSLATE_Y:
        positionY = newValues[0];
        break;
    }
  }

  
}