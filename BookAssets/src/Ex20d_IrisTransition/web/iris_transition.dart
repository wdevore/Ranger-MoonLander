part of layer;

class IrisTransition extends Ranger.TransitionScene {

  IrisNode _irisLeft;
  IrisNode _irisTop;
  IrisNode _irisRight;
  IrisNode _irisBottom;

  double pause = 0.0;
  double _pauseCount = 0.0;
  bool _opening = false;
  bool _closing = true;

  IrisTransition();

  /**
   * [duration] how quickly the chomp occurs: in seconds.
   * [scene] is the [Scene] to transition to.
   */
  factory IrisTransition.initWithDurationAndScene(double duration, Ranger.BaseNode scene) {
    IrisTransition tScene = new IrisTransition()
      ..initWithDuration(duration, scene);
    return tScene;
  }

  @override
  void onEnter() {
    super.onEnter();

    double height = ranger.designSize.height;
    double width = ranger.designSize.width;

    _irisLeft = new IrisNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#ddbcb0").toString()
      ..setPosition(-width / 2.0, 0.0)
      ..width = width / 2.0
      ..height = height;
    addChild(_irisLeft);

    _irisTop = new IrisNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#ddbcb0").toString()
      ..setPosition(0.0, height)
      ..width = width
      ..height = height / 2.0;
    addChild(_irisTop);

    _irisRight = new IrisNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#ddbcb0").toString()
      ..setPosition(width, 0.0)
      ..width = width / 2.0
      ..height = height;
    addChild(_irisRight);

    _irisBottom = new IrisNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#ddbcb0").toString()
      ..setPosition(0.0, -height / 2.0)
      ..width = width
      ..height = height / 2.0;
    addChild(_irisBottom);

    // Hide the incoming scene
    inScene.visible = false;

    UTE.Timeline timeline = new UTE.Timeline.parallel();

    UTE.Tween twLeft = new UTE.Tween.to(_irisLeft, IrisNode.TRANSLATE_X, duration)
      ..targetRelative = width / 2.0
      ..easing = UTE.Cubic.IN;
    timeline.push(twLeft);

    UTE.Tween twTop = new UTE.Tween.to(_irisTop, IrisNode.TRANSLATE_Y, duration)
      ..targetRelative = -height / 2.0
      ..easing = UTE.Cubic.IN;
    timeline.push(twTop);

    UTE.Tween twRight = new UTE.Tween.to(_irisRight, IrisNode.TRANSLATE_X, duration)
      ..targetRelative = -width / 2.0
      ..easing = UTE.Cubic.IN;
    timeline.push(twRight);

    UTE.Tween twBottom = new UTE.Tween.to(_irisBottom, IrisNode.TRANSLATE_Y, duration)
      ..targetRelative = height / 2.0
      ..easing = UTE.Cubic.IN
      ..callback = _closeComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE;
    timeline.push(twBottom);

    ranger.animations.add(timeline);

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

      double height = ranger.designSize.height;
      double width = ranger.designSize.width;

      UTE.Timeline timeline = new UTE.Timeline.parallel();

      UTE.Tween twLeft = new UTE.Tween.to(_irisLeft, IrisNode.TRANSLATE_X, duration)
        ..targetRelative = -width / 2.0
        ..easing = UTE.Sine.OUT;
      timeline.push(twLeft);

      UTE.Tween twTop = new UTE.Tween.to(_irisTop, IrisNode.TRANSLATE_Y, duration)
        ..targetRelative = height / 2.0
        ..easing = UTE.Sine.OUT;
      timeline.push(twTop);

      UTE.Tween twRight = new UTE.Tween.to(_irisRight, IrisNode.TRANSLATE_X, duration)
        ..targetRelative = width / 2.0
        ..easing = UTE.Sine.OUT;
      timeline.push(twRight);

      UTE.Tween twBottom = new UTE.Tween.to(_irisBottom, IrisNode.TRANSLATE_Y, duration)
        ..targetRelative = -height / 2.0
        ..easing = UTE.Sine.OUT
        ..callback = _openComplete
        ..callbackTriggers = UTE.TweenCallback.COMPLETE;
      timeline.push(twBottom);

      ranger.animations.add(timeline);

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