part of layer;

class BlockFadeTransition extends Ranger.TransitionScene {

  List<PixelNode> _pixels = new List<PixelNode>();

  double pause = 0.0;
  double _pauseCount = 0.0;
  bool _closing = true;

  int _pixelCount = 0;
  int _pixelFadeCount = 0;
  int _pixelIndex = 0;

  Math.Random _randGen = new Math.Random();

  BlockFadeTransition();

  factory BlockFadeTransition.initWithDurationAndScene(double duration, Ranger.BaseNode scene) {
    BlockFadeTransition tScene = new BlockFadeTransition()
      ..initWithDuration(duration, scene);
    return tScene;
  }

  @override
  void onEnter() {
    super.onEnter();

    int pixelXCount = 10;
    int pixelYCount = 10;

    double height = ranger.designSize.height;
    double width = ranger.designSize.width;
    double pixelWidth = width / pixelXCount;
    double pixelHeight = height / pixelYCount;
    _pixelCount = pixelYCount * pixelXCount;

    for(double y = pixelHeight / 2.0; y < height; y += pixelHeight) {
      for (double x = pixelWidth / 2.0; x < width; x += pixelWidth) {
        PixelNode p = new PixelNode()
          ..setPosition(x, y)
          ..scaleX = pixelWidth
          ..scaleY = pixelHeight;

        p.fillColor = Ranger.color4IFromHex("#ddbcb000");
        addChild(p);
        _pixels.add(p);
      }
    }

    // Hide the incoming scene
    inScene.visible = false;

    scheduleUpdate();
  }

  @override
  void onExit() {
    super.onExit();
    unScheduleUpdate();
  }

  @override
  void update(double dt) {
    if (_closing) {

      if (_pixelIndex < _pixelCount) {
        for(int i = 0; i < 5; i++) {
          PixelNode p = _pixels[_pixelIndex];
          double duration = 0.1 + (_randGen.nextDouble() / 4.0);
          UTE.Tween tw = new UTE.Tween.to(p, PixelNode.FADE, duration)
            ..targetValues = [255.0]
            ..callback = _discFadeOutComplete
            ..callbackTriggers = UTE.TweenCallback.COMPLETE
            ..easing = UTE.Linear.INOUT;
          ranger.animations.add(tw);
          _pixelIndex++;
        }
      }

      return;
    }

    _pauseCount += dt;
    if (_pauseCount > pause) {
      if (_pixelIndex < _pixelCount) {
        for(int i = 0; i < 5; i++) {
          PixelNode p = _pixels[_pixelIndex];
          double duration = 0.1 + (_randGen.nextDouble() / 4.0);
          UTE.Tween tw = new UTE.Tween.to(p, PixelNode.FADE, duration)
            ..targetValues = [0.0]
            ..callback = _discFadeInComplete
            ..callbackTriggers = UTE.TweenCallback.COMPLETE
            ..easing = UTE.Linear.INOUT;
          ranger.animations.add(tw);
          _pixelIndex++;
        }
      }
    }
  }

  void _discFadeOutComplete(int type, UTE.BaseTween source) {
    if (type == UTE.TweenCallback.COMPLETE) {
      _pixelFadeCount++;

      if (_pixelFadeCount == _pixelCount) {
        _closing = false;
        _pauseCount = 0.0;
        inScene.visible = true;

        // Now begin turning off the pixels.
        _pixelFadeCount = 0;
        _pixelIndex = 0;
      }
    }
  }

  void _discFadeInComplete(int type, UTE.BaseTween source) {
    if (type == UTE.TweenCallback.COMPLETE) {
      _pixelFadeCount++;

      if (_pixelFadeCount == _pixelCount) {
        finish(null);
      }
    }
  }
}