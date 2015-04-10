part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  Ranger.SpriteImage spriteSpinner;

  bool _rotate = true;
  // Once loaded they can't load again.
  bool _loaded = false;
  // Blocks from clicking during loading
  bool _loading = false;

  Ranger.SpriteSheetImage _gTypeSheet;
  Ranger.CanvasSprite _gTypeSprite;

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

    spriteSpinner = new Ranger.SpriteImage.withElement(spinner)
      ..setPosition(1000.0, 500.0)
      ..uniformScale = 10.0;

    addChild(spriteSpinner);

    UTE.Tween.registerAccessor(Ranger.SpriteImage, ranger.animations);

    super.onEnter();
  }

  @override
  bool onMouseDown(MouseEvent event) {

    if (!_loaded && !_loading) {
      _rotateNode();
      _gTypeSheet = new Ranger.SpriteSheetImage("resources/gtype.json");
      _gTypeSheet.load(_spriteLoaded);
    }

    return true;
  }

  void _rotateNode() {

    ranger.animations.stopAndUntrack(spriteSpinner, Ranger.TweenAnimation.ROTATE);

    if (_rotate) {
      ranger.animations.rotateBy(
          spriteSpinner,
          2.0,
          -360.0,
          UTE.Linear.INOUT, null, false)
        ..repeat(10000, 0.0)
        ..start();

      ranger.animations.track(spriteSpinner, Ranger.TweenAnimation.ROTATE);
    }

    _rotate = !_rotate;
  }

  void _spriteLoaded() {
    print("Sprite loaded");
    _loaded = true;
    _loading = false;

    _rotateNode();
    removeChild(spriteSpinner);

    _gTypeSprite = new Ranger.CanvasSprite.initWith(_gTypeSheet)
      ..uniformScale = 2.0
      ..setPosition(1000.0, 500.0);

    addChild(_gTypeSprite);

    ranger.scheduler.scheduleTimingTarget(_gTypeSprite);

  }


}