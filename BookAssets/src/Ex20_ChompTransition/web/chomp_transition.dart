part of layer;

class ChompTransition extends Ranger.TransitionScene {

  DoorNode _upperDoor;
  DoorNode _lowerDoor;
  double pause = 0.0;
  double _pauseCount = 0.0;
  bool _opening = false;
  bool _closing = true;

  ChompTransition();

  /**
   * [duration] how quickly the chomp occurs: in seconds.
   * [scene] is the [Scene] to transition to.
   */
  factory ChompTransition.initWithDurationAndScene(double duration, Ranger.BaseNode scene) {
    ChompTransition tScene = new ChompTransition()
      ..initWithDuration(duration, scene);
    return tScene;
  }

  @override
  void onEnter() {
    super.onEnter();

    double buckleSize = 200.0;

    _upperDoor = new DoorNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#fcc89b").toString()
      ..setPosition(0.0, ranger.designSize.height)
      ..width = ranger.designSize.width
      ..height = ranger.designSize.height / 2.0
      ..buckle.setPosition(ranger.designSize.width / 2.0 - buckleSize /2.0, 0.0)
      ..buckle.fillColor = Ranger.color4IFromHex("#674736").toString()
      ..buckle.uniformScale = buckleSize;
    addChild(_upperDoor);

    _lowerDoor = new DoorNode()
      ..rectangle.fillColor = Ranger.color4IFromHex("#fdbe87").toString()
      ..setPosition(0.0, -ranger.designSize.height / 2.0)
      ..width = ranger.designSize.width
      ..height = ranger.designSize.height / 2.0
      ..buckle.setPosition(ranger.designSize.width / 2.0 - buckleSize /2.0, ranger.designSize.height / 2.0 - buckleSize)
      ..buckle.fillColor = Ranger.color4IFromHex("#674736").toString()
      ..buckle.uniformScale = buckleSize;
    addChild(_lowerDoor);

    // Hide the incoming scene
    inScene.visible = false;

    // Start an animation that animates two rectangles that are half the size of
    // the design size.
    UTE.Tween doorDown = new UTE.Tween.to(_upperDoor, DoorNode.TRANSLATE_Y, duration)
      ..targetRelative = -_upperDoor.height
      ..easing = UTE.Sine.OUT
      ..callback = _closeComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE;
    ranger.animations.add(doorDown);

    UTE.Tween doorUp = new UTE.Tween.to(_lowerDoor, DoorNode.TRANSLATE_Y, duration)
      ..targetRelative = _lowerDoor.height
      ..easing = UTE.Sine.OUT;
    ranger.animations.add(doorUp);

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
      UTE.Tween doorDown = new UTE.Tween.to(_upperDoor, DoorNode.TRANSLATE_Y, duration)
        ..targetRelative = _upperDoor.height
        ..easing = UTE.Sine.IN
        ..callback = _openComplete
        ..callbackTriggers = UTE.TweenCallback.COMPLETE;
      ranger.animations.add(doorDown);

      UTE.Tween doorUp = new UTE.Tween.to(_lowerDoor, DoorNode.TRANSLATE_Y, duration)
        ..targetRelative = -_lowerDoor.height
        ..easing = UTE.Sine.IN;
      ranger.animations.add(doorUp);
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