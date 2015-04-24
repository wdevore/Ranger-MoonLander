part of layer;

class SlatNode extends Ranger.Node with Ranger.GroupingBehavior, UTE.Tweenable {
  static const int TRANSLATE_X = 0;
  static const int TRANSLATE_Y = 1;

  RectangleNode rectangle = new RectangleNode();

  double _width = 0.0;
  double _height = 0.0;

  SlatNode() {
    if (init()) {
      initGroupingBehavior(this);
    }
  }

  @override
  bool init() {
    if (super.init()) {
      rectangle.init();
      return true;
    }
    return false;
  }

  @override
  void onEnter() {

    addChild(rectangle);

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
      case TRANSLATE_X:
        returnValues[0] = position.x;
        return 1;
      case TRANSLATE_Y:
        returnValues[0] = position.y;
        return 1;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch (tweenType) {
      case TRANSLATE_Y:
        positionY = newValues[0];
        break;
      case TRANSLATE_X:
        positionX = newValues[0];
        break;
    }
  }

}