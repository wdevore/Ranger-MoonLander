part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode rectangle;

  bool _rotate = true;

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
    enableMouse = true;

    rectangle = new RectangleNode()
      ..init()
      ..setPosition(500.0, 500.0)
      ..uniformScale = 150.0;

    addChild(rectangle);

    UTE.Tween.registerAccessor(RectangleNode, ranger.animations);

    _rotateNode();

    super.onEnter();
  }

  @override
  bool onMouseDown(MouseEvent event) {

    _rotateNode();

    return true;
  }

  void _rotateNode() {

    ranger.animations.stopAndUntrack(rectangle, Ranger.TweenAnimation.ROTATE);

    if (_rotate) {
      ranger.animations.rotateBy(
          rectangle,
          4.0,
          360.0,
          UTE.Linear.INOUT, null, false)
        ..repeat(10000, 0.0)
        ..start();

      ranger.animations.track(rectangle, Ranger.TweenAnimation.ROTATE);
    }

    _rotate = !_rotate;
  }
}