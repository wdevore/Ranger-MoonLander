part of moonlander;

class TriEngineGear extends UTE.Tweenable {
  static const int JOINT_ROTATE = 1;
  static const int TOE_ROTATE = 2;

  TriEngineRocket rocket;
  Ranger.GroupNode _joint;
  RectangleNode _leg;
  RectangleNode _toe;
  
  double legExtendOrientation = 0.0;
  double legRetractOrientation = 0.0;
  double toeExtendOrientation = 0.0;
  double toeRetractOrientation = 0.0;
  
  Ranger.MutableRectangle<double> rect = new Ranger.MutableRectangle<double>(0.0, 0.0, 0.0, 0.0);

  TriEngineGear();
  
  factory TriEngineGear.basic() {
    TriEngineGear o = new TriEngineGear();
    
    if (o.init())
      return o;
    
    return null;
  }
  
  Ranger.Node get node => _joint;
  Ranger.Node get toe => _toe;
  Ranger.Node get leg => _leg;
  
  void setRotation(double r) {
    _joint.rotationByDegrees = r;
  }
  
  void setPosition(double x, double y) {
    _joint.setPosition(x, y);
  }
  
  bool init() {
    _joint = new Ranger.GroupNode();
    _joint.tag = 300001;
    
    double sx = 80.0;
    double xOff = sx / 2.0;
    _leg = new RectangleNode.basic(Ranger.Color4IGoldYellow)
      ..scaleTo(sx, 10.0)
      ..positionX = xOff
      ..tag = 300002;

    _joint.addChild(_leg);
    
    double tsx = 30.0;
    xOff = sx;  
    _toe = new RectangleNode.basic(Ranger.Color4IGreyBlue)
      ..scaleTo(tsx, 10.0)
      ..positionX = xOff
      ..rotationByDegrees = 0.0
      ..tag = 300003;
    _joint.addChild(_toe);
    
    return true;
  }
  
  void retract() {
    ranger.animations.tweenMan.killTarget(this, JOINT_ROTATE);
    ranger.animations.tweenMan.killTarget(this, TOE_ROTATE);
    
    UTE.Timeline par = new UTE.Timeline.parallel();

    UTE.Tween rotateTo = new UTE.Tween.to(this, JOINT_ROTATE, 2.0)
      ..targetValues = [legRetractOrientation]
      ..callback = _retractComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE
      ..userData = node
      ..easing = UTE.Linear.INOUT;
    par.push(rotateTo);

    UTE.Tween rotateToeTo = new UTE.Tween.to(this, TOE_ROTATE, 1.0)
      ..targetValues = [toeRetractOrientation]
      ..easing = UTE.Bounce.OUT;
    par.push(rotateToeTo);

    ranger.animations.add(par);
  }
  
  void _retractComplete(int type, UTE.BaseTween source) {
    Ranger.GroupNode joint = source.userData as Ranger.GroupNode;
    joint.visible = false;
  }

  void extend() {
    ranger.animations.tweenMan.killTarget(this, JOINT_ROTATE);
    ranger.animations.tweenMan.killTarget(this, TOE_ROTATE);

    node.visible = true;
    UTE.Timeline par = new UTE.Timeline.parallel();
    
    UTE.Tween rotateTo = new UTE.Tween.to(this, JOINT_ROTATE, 2.0)
      ..callback = _extendComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE
      ..targetValues = [legExtendOrientation]
      ..easing = UTE.Expo.OUT;
    par.push(rotateTo);

    UTE.Timeline seq = new UTE.Timeline.sequence();

    UTE.Tween rotateToeTo = new UTE.Tween.to(this, TOE_ROTATE, 1.0)
      ..targetValues = [toeExtendOrientation]
      ..easing = UTE.Bounce.OUT;
    seq.pushPause(0.5);
    seq.push(rotateToeTo);
    par.push(seq);

    ranger.animations.add(par);
  }

  void _extendComplete(int type, UTE.BaseTween source) {
    if (type == UTE.TweenCallback.COMPLETE)
      rocket.gearsRetracted = false;
  }

  Ranger.MutableRectangle<double> calcAABBox() {
    // Use only the leg's transform. We could form an accumulative transform but the leg is good enough.
    Ranger.AffineTransform at = _leg.calcTransform();

    Ranger.MutableRectangle<double> localB = _leg.localBounds;
    
    // Take this node's aabbox and transform it
    Ranger.RectApplyAffineTransformTo(localB, rect, at);

    return rect;
  }

  // -----------------------------------------------------------------
  // Tweenable interface
  // -----------------------------------------------------------------
  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case JOINT_ROTATE:
        returnValues[0] = node.rotationInDegrees;
        return 1;
      case TOE_ROTATE:
        returnValues[0] = _toe.rotationInDegrees;
        return 1;
    }
    
    return 0;
  }
  
  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case JOINT_ROTATE:
        node.rotationByDegrees = newValues[0];
        break;
      case TOE_ROTATE:
        _toe.rotationByDegrees = newValues[0];
        break;
    }
  }

}