part of layer;

class SecondLayer extends Ranger.BackgroundLayer {
  RectangleNode rectangle;

  bool _rotate = true;

  SecondLayer();

  factory SecondLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    SecondLayer layer = new SecondLayer()
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
      ..fillColor = Ranger.Color4IGreenYellow.toString()
      ..setPosition(1500.0, 500.0)
      ..uniformScale = 250.0;

    addChild(rectangle);

    UTE.Tween.registerAccessor(RectangleNode, ranger.animations);

    super.onEnter();
  }

  @override
  void onEnterTransitionDidFinish() {
    super.onEnterTransitionDidFinish();
    _rotateNode();
  }

  @override
  void onExit() {
    disableInputs();

    ranger.animations.flushAll();

    super.onExit();
  }

  @override
  bool onMouseDown(MouseEvent event) {

    // Transition to the second scene
    MainScene inComingScene = new MainScene();

    BarsTransition transition = new BarsTransition.initWithDurationAndScene(0.2, inComingScene)
      ..pause = 0.25;

    ranger.sceneManager.replaceScene(transition);

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