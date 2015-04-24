part of layer;

class BladeNode extends Ranger.Node with Ranger.GroupingBehavior, UTE.Tweenable {
  static const int ROTATE = 0;

  RectangleNode rectangle = new RectangleNode();

  double _width = 0.0;
  double _height = 0.0;

  Ranger.GroupNode _anchor;

  BladeNode() {
    if (init()) {
      initGroupingBehavior(this);
    }
  }

  @override
  bool init() {
    if (super.init()) {
      rectangle.init();
      _anchor = new Ranger.GroupNode.basic();
      return true;
    }
    return false;
  }

  @override
  void onEnter() {

    _anchor.addChild(rectangle);
    addChild(_anchor);

    super.onEnter();
  }

  set width (double w) {
    _width = w;
    rectangle.scaleX = w;
  }

  double get height => _height;
  set height (double h) {
    _height = h;
    rectangle.scaleY = h;
  }

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch (tweenType) {
      case ROTATE:
        returnValues[0] = rotationInDegrees;
        return 1;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch (tweenType) {
      case ROTATE:
        rotationByDegrees = newValues[0];
        break;
    }
  }

}