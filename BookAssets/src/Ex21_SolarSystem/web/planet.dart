part of layer;

class Planet {
  String fillColor = Ranger.Color4IOrange.toString();
  Ranger.GroupNode system;
  String name = "";
  RectangleNode mass;
  double rotationRate = 0.0;
  UTE.Timeline timeline;

  double orbitalRadius = 0.0;
  double radius = 0.0;
  Ranger.Color4<int> orbitPathColor = Ranger.color4IFromHex("ff77000f");

  int _entered = -1;

  CircleNode _ring;

  Ranger.MutableRectangle _bbox = new Ranger.MutableRectangle.withP(-0.5, -0.5, 1.0, 1.0);

  Planet() {
    system = new Ranger.GroupNode.basic();
  }

  void coalesce() {
    mass = new RectangleNode()
      ..init()
      ..positionX = orbitalRadius
      ..uniformScale = radius
      ..fillColor = fillColor;

    _ring = new CircleNode()
      ..uniformScale = orbitalRadius
      ..outlineColor = orbitPathColor;
    system.addChild(_ring);

    system.addChild(mass);

    ranger.animations.rotateBy(
        mass,
        rotationRate,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();
  }

  bool pointInsideByView(int x, int y) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(mass, x, y);

    bool inside = _bbox.containsPointByComp(nodeP.v.x, nodeP.v.y);

    if (inside) {
      if (_entered == -1 || _entered == 0) {
        _entered = 1;
        animateEffect();
      }
    }
    else {
        _entered = 0;
    }

    nodeP.moveToPool();

    return inside;
  }

  void animateEffect() {
    ranger.animations.flush(_ring);

    timeline = new UTE.Timeline.sequence();

    _ring
      ..uniformScale = 0.1
      ..visible = true
      ..outlineColor.a = 16;

    UTE.Tween scaleUp = new UTE.Tween.to(_ring, CircleNode.SCALE, 0.5)
      ..targetValues = mass.position.x
      ..easing = UTE.Cubic.OUT;
    timeline.push(scaleUp);
    ranger.animations.track(_ring, CircleNode.SCALE);

    UTE.Tween fadeBright = new UTE.Tween.to(_ring, CircleNode.ALPHA_OUTLINE, 0.25)
      ..targetValues = 255.0
      ..callback = _discFadeBrightComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE
      ..easing = UTE.Cubic.IN;
    timeline.push(fadeBright);
    ranger.animations.track(_ring, CircleNode.ALPHA_OUTLINE);

    ranger.animations.add(timeline);
  }

  void _discFadeBrightComplete(int type, UTE.BaseTween source) {
    if (type == UTE.TweenCallback.COMPLETE) {
      timeline = new UTE.Timeline.sequence();

      UTE.Tween fadeOut = new UTE.Tween.to(_ring, CircleNode.ALPHA_OUTLINE, 10.0)
        ..targetValues = 16.0
        ..easing = UTE.Cubic.OUT;
      timeline.push(fadeOut);
      ranger.animations.track(_ring, CircleNode.ALPHA_OUTLINE);

      ranger.animations.add(timeline);
    }
  }

}