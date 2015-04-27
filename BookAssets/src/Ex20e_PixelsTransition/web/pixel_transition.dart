part of layer;

class PixelTransition extends Ranger.TransitionScene {

  List<PixelNode> _pixels = new List<PixelNode>();

  double pause = 0.0;
  double _pauseCount = 0.0;
  bool _closing = true;

  // How much time to turn on pixels. Once time is reached
  // We turn on any remaining pixels all at once.
  double pixelWindow = 1.0;
  double _pixelWindowCount = 0.0;

  int _pixelCount = 0;
  int _pixelFadeCount = 0;

  Math.Random _randGen = new Math.Random();

  PixelTransition();

  factory PixelTransition.initWithDurationAndScene(double duration, Ranger.BaseNode scene) {
    PixelTransition tScene = new PixelTransition()
      ..initWithDuration(duration, scene);
    return tScene;
  }

  @override
  void onEnter() {
    super.onEnter();

    int pixelXCount = 25;
    int pixelYCount = 25;

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
      _pixelWindowCount += dt;

      if (_pixelWindowCount > pixelWindow) {
        // Time to turn on the rest of them.
        for(int i = 0; i < _pixelCount; i++) {
          PixelNode p = _pixels[i];
          if (!p.triggered) {
            p.triggered = true;

            double duration = 0.1 + (_randGen.nextDouble() / 4.0);
            UTE.Tween tw = new UTE.Tween.to(p, PixelNode.FADE, duration)
              ..targetValues = [255.0]
              ..callback = _discFadeOutComplete
              ..callbackTriggers = UTE.TweenCallback.COMPLETE
              ..easing = UTE.Sine.IN;
            ranger.animations.add(tw);
          }
        }
      }
      else {
        // Turn a batch of them on.
        for(int i = 0; i < 10; i++) {
          int index = _randGen.nextInt(_pixelCount);
          double duration = 0.1 + (_randGen.nextDouble() / 4.0);
          PixelNode p = _pixels[index];
          if (!p.triggered) {
            p.triggered = true;
            UTE.Tween tw = new UTE.Tween.to(p, PixelNode.FADE, duration)
              ..targetValues = [255.0]
              ..callback = _discFadeOutComplete
              ..callbackTriggers = UTE.TweenCallback.COMPLETE
              ..easing = UTE.Sine.IN;
            ranger.animations.add(tw);
          }
        }
      }

      return;
    }

    _pauseCount += dt;
    // Fade them back in.
    if (_pauseCount > pause) {

      // Time to turn on the rest of them.
      for(int i = 0; i < _pixelCount; i++) {
        PixelNode p = _pixels[i];
        if (!p.triggered) {
          p.triggered = true;

          double duration = 0.1 + (_randGen.nextDouble() / 4.0);
          UTE.Tween tw = new UTE.Tween.to(p, PixelNode.FADE, duration)
            ..targetValues = [0.0]
            ..callback = _discFadeInComplete
            ..callbackTriggers = UTE.TweenCallback.COMPLETE
            ..easing = UTE.Sine.IN;
          ranger.animations.add(tw);
        }
      }
    }
    else {
      // Turn a batch of them on.
      for(int i = 0; i < 10; i++) {
        int index = _randGen.nextInt(_pixelCount);
        double duration = 0.1 + (_randGen.nextDouble() / 4.0);
        PixelNode p = _pixels[index];
        if (!p.triggered) {
          p.triggered = true;
          UTE.Tween tw = new UTE.Tween.to(p, PixelNode.FADE, duration)
            ..targetValues = [0.0]
            ..callback = _discFadeInComplete
            ..callbackTriggers = UTE.TweenCallback.COMPLETE
            ..easing = UTE.Sine.IN;
          ranger.animations.add(tw);
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
        _pixelWindowCount = 0.0;

        _pixels.forEach((PixelNode p) => p.triggered = false);
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