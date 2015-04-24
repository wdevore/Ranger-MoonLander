part of layer;

class BladeTransition extends Ranger.TransitionScene {

  BladeNode _blade;

  double pause = 0.0;
  double _pauseCount = 0.0;
  bool _opening = false;
  bool _closing = true;

  BladeTransition();

  /**
   * [duration] how quickly the chomp occurs: in seconds.
   * [scene] is the [Scene] to transition to.
   */
  factory BladeTransition.initWithDurationAndScene(double duration, Ranger.BaseNode scene) {
    BladeTransition tScene = new BladeTransition()
      ..initWithDuration(duration, scene);
    return tScene;
  }

  @override
  void onEnter() {
    super.onEnter();

    double height = ranger.designSize.height;
    double width = ranger.designSize.width;

    _blade = new BladeNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#ddbcb0").toString()
      ..setPosition(0.0, height)
      ..width = height
      ..height = width;
    addChild(_blade);

    // Hide the incoming scene
    inScene.visible = false;

    // Start an animations

    UTE.Tween bladeDown = new UTE.Tween.to(_blade, BladeNode.ROTATE, duration)
      ..targetRelative = -90.0
      ..easing = UTE.Bounce.OUT
      ..callback = _closeComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE;

    ranger.animations.add(bladeDown);

    scheduleUpdate();
  }

  @override
  void onExit() {
    super.onExit();
    unScheduleUpdate();
  }

  @override
  void update(double dt) {
    if (_closing)
      return;

    _pauseCount += dt;

    if (_pauseCount > pause && !_opening) {
      _opening = true;

      UTE.Tween bladeAway = new UTE.Tween.to(_blade, BladeNode.ROTATE, duration)
        ..targetRelative = 90.0
        ..easing = UTE.Sine.OUT
        ..callback = _openComplete
        ..callbackTriggers = UTE.TweenCallback.COMPLETE;

      ranger.animations.add(bladeAway);
    }
  }

  void _closeComplete(int type, UTE.BaseTween source) {
    if (type == UTE.TweenCallback.COMPLETE) {
      _closing = false;
      _pauseCount = 0.0;
      inScene.visible = true;
    }
  }

  void _openComplete(int type, UTE.BaseTween source) {
    if (type == UTE.TweenCallback.COMPLETE) {
      finish(null);
    }
  }
}