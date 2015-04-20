part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode orangeRect;

  bool _flip = true;

  MainLayer();

  factory MainLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    MainLayer layer = new MainLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = false
      ..color = backgroundColor;
    return layer;
  }

  @override
  void onEnter() {
    enableKeyboard = true;

    orangeRect = new RectangleNode()
      ..init()
      ..setPosition(1000.0, 500.0)  // Near center-ish.
      ..uniformScale = 150.0;

    addChild(orangeRect);

    Ranger.Color4<int> toColor = Ranger.Color4IGreenYellow;

    UTE.Tween tint = new UTE.Tween.to(orangeRect, RectangleNode.TINT, 1.0)
      ..targetValues = [toColor.r, toColor.g, toColor.b]
      ..easing = UTE.Expo.INOUT
      ..repeatYoyo(100000, 0.0);
    ranger.animations.add(tint);

    UTE.Tween move = new UTE.Tween.to(orangeRect, RectangleNode.MOVE_X, 1.0)
      ..targetRelative = [200.0]
      ..easing = UTE.Sine.INOUT
      ..callback = _moveComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE
      ..repeatYoyo(1, 0.0);
    ranger.animations.add(move);

    super.onEnter();
  }

  void _moveComplete(int type, UTE.BaseTween source) {
    if (type == UTE.TweenCallback.COMPLETE) {
      if (_flip) {

        UTE.Tween move = new UTE.Tween.to(orangeRect, RectangleNode.MOVE_Y, 1.0)
          ..targetRelative = [200.0]
          ..easing = UTE.Sine.INOUT
          ..callback = _moveComplete
          ..callbackTriggers = UTE.TweenCallback.COMPLETE
          ..repeatYoyo(1, 0.0);

        ranger.animations.add(move);
      }
      else {
        UTE.Tween move = new UTE.Tween.to(orangeRect, RectangleNode.MOVE_X, 1.0)
          ..targetRelative = [200.0]
          ..easing = UTE.Sine.INOUT
          ..callback = _moveComplete
          ..callbackTriggers = UTE.TweenCallback.COMPLETE
          ..repeatYoyo(1, 0.0);

        ranger.animations.add(move);
      }
    }

    _flip = !_flip;
  }

}