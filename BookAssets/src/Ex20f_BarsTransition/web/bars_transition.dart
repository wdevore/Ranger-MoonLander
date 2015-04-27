part of layer;

class BarsTransition extends Ranger.TransitionScene {

  SlatNode _slat1;
  SlatNode _slat2;
  SlatNode _slat3;

  double pause = 0.0;
  double _pauseCount = 0.0;
  bool _opening = false;
  bool _closing = true;

  BarsTransition();

  /**
   * [duration] how quickly the chomp occurs: in seconds.
   * [scene] is the [Scene] to transition to.
   */
  factory BarsTransition.initWithDurationAndScene(double duration, Ranger.BaseNode scene) {
    BarsTransition tScene = new BarsTransition()
      ..initWithDuration(duration, scene);
    return tScene;
  }

  @override
  void onEnter() {
    super.onEnter();

    double height = ranger.designSize.height / 3.0;
    double width = ranger.designSize.width;

    _slat1 = new SlatNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#ddbcb0").toString()
      ..setPosition(-width, height * 2.0)
      ..width = width
      ..height = height;
    addChild(_slat1);

    _slat2 = new SlatNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#ca9a8e").toString()
      ..setPosition(width, height)
      ..width = width
      ..height = height;
    addChild(_slat2);

    _slat3 = new SlatNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#bc8a7e").toString()
      ..setPosition(-width, 0.0)
      ..width = width
      ..height = height;
    addChild(_slat3);

    // Hide the incoming scene
    inScene.visible = false;

    // Start an animations
    UTE.Timeline timeline = new UTE.Timeline.parallel();

    UTE.Tween slatUp = new UTE.Tween.to(_slat1, SlatNode.TRANSLATE_X, duration)
      ..targetRelative = width
      ..easing = UTE.Sine.OUT;
    timeline.push(slatUp);

    slatUp = new UTE.Tween.to(_slat2, SlatNode.TRANSLATE_X, duration)
      ..targetRelative = -width
      ..easing = UTE.Sine.OUT
      ..callback = _closeComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE;
    timeline.push(slatUp);

    ranger.animations.add(timeline);

    slatUp = new UTE.Tween.to(_slat3, SlatNode.TRANSLATE_X, duration)
      ..targetRelative = width
      ..easing = UTE.Sine.OUT;
    ranger.animations.add(slatUp);

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
      UTE.Timeline timeline = new UTE.Timeline.parallel();

      UTE.Tween slatRight = new UTE.Tween.to(_slat1, SlatNode.TRANSLATE_X, duration)
        ..targetRelative = ranger.designSize.width
        ..easing = UTE.Sine.OUT;
      timeline.push(slatRight);

      slatRight = new UTE.Tween.to(_slat2, SlatNode.TRANSLATE_X, duration)
        ..targetRelative = -ranger.designSize.width
        ..easing = UTE.Sine.OUT;
      timeline.push(slatRight);

      ranger.animations.add(timeline);

      slatRight = new UTE.Tween.to(_slat3, SlatNode.TRANSLATE_X, duration)
        ..targetRelative = ranger.designSize.width
        ..easing = UTE.Sine.OUT
        ..callback = _openComplete
        ..callbackTriggers = UTE.TweenCallback.COMPLETE;
      ranger.animations.add(slatRight);

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