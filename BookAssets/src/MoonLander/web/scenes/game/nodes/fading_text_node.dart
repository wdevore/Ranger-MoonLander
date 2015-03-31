part of moonlander;

class FadingTextNode extends Ranger.TextNode with UTE.Tweenable {
  static const int TWEEN_FADE = 2;
  static const int TWEEN_TRANSLATE_Y = 3;

  // ----------------------------------------------------------
  // Poolable support and Factory
  // ----------------------------------------------------------
  FadingTextNode();

  FadingTextNode._();
  factory FadingTextNode.pooled() {
    FadingTextNode poolable = new Ranger.Poolable.of(FadingTextNode, _createPoolable);
    poolable.pooled = true;
    return poolable;
  }

  factory FadingTextNode.initWith(Ranger.Color4<int> fillColor, [Ranger.Color4<int> strokeColor, double fromScale = 1.0]) {
    FadingTextNode poolable = new FadingTextNode.pooled();
    if (poolable.init()) {
      poolable..font = null
        ..shadows = false
        ..visible = true
        ..text = ""
        ..strokeColor = strokeColor
        ..initWithColor(fillColor)
        ..initWithUniformScale(poolable, fromScale);
      return poolable;
    }
    return null;
  }

  static FadingTextNode _createPoolable() => new FadingTextNode._();

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case TWEEN_FADE:
        returnValues[0] = opacity;
        return 1;
      case TWEEN_TRANSLATE_Y:
        returnValues[0] = position.y;
        return 1;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case TWEEN_FADE:
        opacity = newValues[0].toInt();
        break;
      case TWEEN_TRANSLATE_Y:
        positionY = newValues[0];
        break;
    }
  }

}