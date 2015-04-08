part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  Ranger.SpriteImage sprite;

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

    ImageElement spinner = new ImageElement(
        src: Ranger.BaseResources.svgMimeHeader + Ranger.BaseResources.spinner,
        width: 32, height: 32);

    sprite = new Ranger.SpriteImage.withElement(spinner)
      ..setPosition(1000.0, 500.0)
      ..uniformScale = 10.0;

    addChild(sprite);

    UTE.Tween.registerAccessor(Ranger.SpriteImage, ranger.animations);

    _rotateNode();

    super.onEnter();
  }

  @override
  bool onMouseDown(MouseEvent event) {

    _rotateNode();

    return true;
  }

  void _rotateNode() {

    ranger.animations.stopAndUntrack(sprite, Ranger.TweenAnimation.ROTATE);

    if (_rotate) {
      ranger.animations.rotateBy(
          sprite,
          2.0,
          -360.0,
          UTE.Linear.INOUT, null, false)
        ..repeat(10000, 0.0)
        ..start();

      ranger.animations.track(sprite, Ranger.TweenAnimation.ROTATE);
    }

    _rotate = !_rotate;
  }
}