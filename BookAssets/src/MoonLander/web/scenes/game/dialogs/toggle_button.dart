part of moonlander;

class ToggleButton extends Button {
  static const int TWEEN_TRANSLATE_X = 1;
  static const int TWEEN_FADE = 3;

  double _width = 0.0;
  double _height = 0.0;
  double _knobSlideDistance = 0.0;
  double _knobOffPosition = 0.0;
  double _knobOnPosition = 0.0;
  
  String backgroundFillColor;
  String backgroundOutlineColor;
  String trackFillColor;
  String trackOutlineColor;
  String sliderOutlineColor;
  String sliderOnColor;
  String sliderOffColor;
  double sliderRadius = 1.0;
  Ranger.Color4<int> captionColor;
  String caption;
  Vector2 captionOffset = new Vector2.zero();
  
  Ranger.TextNode _stateNode;
  double _stateOffPosition = 0.0;
  double _stateOnPosition = 0.0;
  bool _state = false;
  
  RoundRectangleNode _background;
  RoundRectangleNode _track;
  CircleNode _knob;
  Ranger.TextNode _caption;
  
  ToggleButton();
  
  factory ToggleButton.basic([double width, double height]) {
    ToggleButton b = new ToggleButton();
    b.init(width, height);
    return b;
  }

  bool init([double width, double height]) {
    if (super.init()) {
      initGroupingBehavior(this);
      _width = width;
      _height = height;
    }
    return true;
  }

  void construct() {
    _background = new RoundRectangleNode.basic()
      ..cornerRadius = 30.0
      ..fillColor = backgroundFillColor
      ..outlineColor = backgroundOutlineColor
      ..width = _width
      ..height = _height;
    addChild(_background);

    double dx = _width * 0.3;
    double dy = _height * 0.3;
    double ix = _width - dx;
    double iy = _height - dy;
    
    _track = new RoundRectangleNode.basic()
      ..fillColor = trackFillColor
      ..outlineColor = trackOutlineColor
      ..width = ix
      ..height = iy
      ..setPosition(dx / 2.0, dy / 2.0);
    addChild(_track);

    _stateOffPosition = dx + 30;
    _stateOnPosition = dx - 10;
    _stateNode = new Ranger.TextNode.initWith(captionColor)
        ..text = "Off"
        ..font = "normal 900 10px Verdana"
        ..setPosition(_stateOffPosition, _height / 2.0 - 13.0)
        ..uniformScale = 3.0;
    addChild(_stateNode);

    double gap = sliderRadius * 0.4;
    _knobSlideDistance = _track.width - dx / 2.0;
    _knobOffPosition = dx / 2.0 + sliderRadius - gap;
    _knobOnPosition = _knobOffPosition + _knobSlideDistance;
    _knob = new CircleNode.basic()
      ..uniformScale = sliderRadius
      ..fillColor = sliderOffColor
      ..outlineColor = sliderOutlineColor
      ..setPosition(_knobOffPosition, _height / 2.0);
    addChild(_knob);
      
    _caption = new Ranger.TextNode.initWith(captionColor)
        ..text = caption
        ..font = "normal 900 10px Verdana"
        ..setPosition(captionOffset.x, captionOffset.y)
        ..uniformScale = 5.0;
    addChild(_caption);
  }

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case TWEEN_TRANSLATE_X:
        returnValues[0] = _knob.position.x;
        return 1;
      case TWEEN_FADE:
        returnValues[0] = _stateNode.opacity;
        return 1;
    }
    
    return 0;
  }
  
  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case TWEEN_TRANSLATE_X:
        _knob.setPosition(newValues[0], _knob.position.y);
        break;
      case TWEEN_FADE:
        _stateNode.opacity = newValues[0].toInt();
        break;
    }
  }
  
  @override
  bool check(int x, int y) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_background, x, y);

    if (_background.pointInside(nodeP.v)) {
      nodeP.moveToPool();
      
      _state = !_state;
      
      // Send message indicating this toggle button was clicked.
      MessageData md = new MessageData();
      md.whatData = MessageData.BUTTON;
      if (_state)
        md.actionData = MessageData.TOGGLED_ON;
      else
        md.actionData = MessageData.TOGGLED_OFF;
      md.data = caption;
      ranger.eventBus.fire(md);
      
      _animateText();
      _animateKnob();
      
      return true;
    }
    nodeP.moveToPool();
    
    return false;
  }

  set on(bool b) {
    _state = b;
    if (_state) {
      _stateNode.positionX = _stateOnPosition;
      _stateNode.text = "On";
      _knob.positionX = _knobOnPosition;
    }
    else {
      _stateNode.positionX = _stateOffPosition;
      _stateNode.text = "Off";
      _knob.positionX = _knobOffPosition;
    }
  }
  
  void _animateText() {
    ranger.animations.stopAndUntrack(this, TWEEN_FADE);
    _stateNode.opacity = 0;

    if (_state) {
      // Move to On position which is to the left.
      _stateNode.positionX = _stateOnPosition;
      _stateNode.text = "On";
      UTE.Tween fadeIn = new UTE.Tween.to(this, TWEEN_FADE, 1.0)
        ..targetValues = [255]
        ..easing = UTE.Sine.OUT;
      ranger.animations.add(fadeIn);
    }
    else {
      // Move to Off position which is to the right.
      _stateNode.positionX = _stateOffPosition;
      _stateNode.text = "Off";
      UTE.Tween fadeIn = new UTE.Tween.to(this, TWEEN_FADE, 1.0)
        ..targetValues = [255]
        ..easing = UTE.Sine.OUT;
      ranger.animations.add(fadeIn);
    }
  }
  
  void _animateKnob() {
    ranger.animations.stopAndUntrack(this, TWEEN_TRANSLATE_X);
    
    if (_state) {
      // Reset if animation was stopped mid stride
      _knob.positionX = _knobOffPosition;
      // Move to On position which is to the right.
      UTE.Tween moveBy = new UTE.Tween.to(this, TWEEN_TRANSLATE_X, 0.25)
        ..targetRelative = [_knobSlideDistance]
        ..easing = UTE.Sine.OUT;
      ranger.animations.add(moveBy);
    }
    else {
      _knob.positionX = _knobOnPosition;
      // Move to Off position which is to the left.
      UTE.Tween moveBy = new UTE.Tween.to(this, TWEEN_TRANSLATE_X, 0.25)
        ..targetRelative = [-_knobSlideDistance]
        ..easing = UTE.Sine.OUT;
      ranger.animations.add(moveBy);
    }
    
    ranger.animations.track(this, TWEEN_TRANSLATE_X);
  }
}