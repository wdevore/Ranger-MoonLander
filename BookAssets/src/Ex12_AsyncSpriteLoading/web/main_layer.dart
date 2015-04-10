part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  Ranger.SpriteImage spriteSpinner;

  bool _rotate = true;
  // Once loaded they can't load again.
  bool _loaded = false;
  // Blocks from clicking during loading
  bool _loading = false;

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

    if (!_loaded && !_loading)
      loadImage("EngineRocket3.svg", 235, 245, 1000.0, 500.0, true);

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
  }

  int loadImage(String resource, int width, int height, double px, double py, [bool simulateLoadingDelay = false]) {
    int tg = 0;
    _loading = true;

    // I use a Closure to capture the placebo sprite such that it can
    // be used while the actual image is loading.
    (int ntag) {  // <--------- Closure
      // Start loading image
      // This Template example enables Simulated Loading Delay. You
      // wouldn't do this in production. Just leave the parameter missing
      // as it is optional and defaults to "false/disabled".
      //                                         ^-------v
      _loadImage(resource, width, height, simulateLoadingDelay).then((ImageElement ime) {
        // Image has finally loaded.
        // Terminate placebo's animation.
        _rotateNode();

        // Remove placebo and capture index for insertion of actual image.
        int index = removeChild(spriteSpinner);

        // Now that the image is loaded we can create a sprite from it.
        Ranger.SpriteImage spri = new Ranger.SpriteImage.withElement(ime);
        // Add the image at the place-order of the placebo.
        addChildAt(spri, index, 10, ntag);
        spri.setPosition(px, py);

        _spriteLoaded();
      });
    }(tg);// <---- Immediately execute the Closure.

    return tg;
  }

  Future<ImageElement> _loadImage(String source, int iWidth, int iHeight, [bool simulateLoadingDelay = false]) {
    Ranger.ImageLoader loader = new Ranger.ImageLoader.withResource(source);
    loader.simulateLoadingDelay = simulateLoadingDelay;
    return loader.load(iWidth, iHeight);
  }

}