part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  GroupDragNode _dragGroup;
  Ranger.GroupNode _system;

  RectangleNode sun;
  Planet mercury;
  Planet venus;
  Planet earth;
  Planet moon;
  Planet mars;
  Planet saturn;
  Planet jupiter;
  Planet uranus;
  Planet neptune;

  bool _dragging = false;
  double prevX = 0.0;
  double prevY = 0.0;

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
    enableKeyboard = true;
    enableMouse = true;

    super.onEnter();

    UTE.Tween.registerAccessor(RectangleNode, ranger.animations);
    UTE.Tween.registerAccessor(Ranger.GroupNode, ranger.animations);

    _dragGroup = new GroupDragNode()
      ..width = contentSize.width
      ..height = contentSize.height;
    addChild(_dragGroup);

    _system = new Ranger.GroupNode.basic()
      ..setPosition(1000.0, 500.0);
    _dragGroup.addChild(_system);

    sun = new RectangleNode()
      ..init()
      ..setPosition(0.0, 0.0)  // Near center-ish.
      ..fillColor = Ranger.color4IFromHex("#f5e1a4").toString()
      ..uniformScale = 150.0;

    ranger.animations.rotateBy(
        sun,
        20.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();

    _system.addChild(sun);

    _mercury();
    _venus();
    _earth();
    _mars();
    _jupiter();
    _saturn();
    _uranus();
    _neptune();

  }

  void _mercury() {
    mercury = new Planet()
      ..name = "mercury"
      ..orbitalRadius = 150.0
      ..radius = 15.0
      ..rotationRate = 10.0
      ..fillColor = Ranger.color4IFromHex("#8b634b").toString()
      ..coalesce();

    _system.addChild(mercury.system);

    ranger.animations.rotateBy(
        mercury.system,
        10.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();
  }

  void _venus() {
    venus = new Planet()
      ..name = "venus"
      ..orbitalRadius = 200.0
      ..radius = 25.0
      ..rotationRate = 20.0
      ..fillColor = Ranger.color4IFromHex("#e4d5d3").toString()
      ..coalesce();

    _system.addChild(venus.system);
    ranger.animations.rotateBy(
        venus.system,
        20.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();
  }

  void _earth() {
    earth = new Planet()
      ..name = "earth"
      ..orbitalRadius = 250.0
      ..radius = 30.0
      ..rotationRate = 20.0
      ..fillColor = Ranger.color4IFromHex("#7ba4db").toString()
      ..orbitPathColor = Ranger.color4IFromHex("ffaa0066")
      ..coalesce();

    moon = new Planet()
      ..name = "moon"
      ..system.setPosition(earth.orbitalRadius, 0.0)
      ..orbitalRadius = earth.radius
      ..radius = 10.0
      ..rotationRate = 5.0
      ..fillColor = Ranger.color4IFromHex("#dddddd").toString()
      ..orbitPathColor = Ranger.color4IFromHex("ffaa0066")
      ..coalesce();
    earth.system.addChild(moon.system);
    ranger.animations.rotateBy(
        moon.system,
        10.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();

    _system.addChild(earth.system);
    ranger.animations.rotateBy(
        earth.system,
        30.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();
  }

  void _mars() {
    mars = new Planet()
      ..name = "mars"
      ..orbitalRadius = 350.0
      ..radius = 20.0
      ..rotationRate = 20.0
      ..fillColor = Ranger.color4IFromHex("#8f3237").toString()
      ..coalesce();

    _system.addChild(mars.system);
    ranger.animations.rotateBy(
        mars.system,
        40.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();
  }

  void _jupiter() {
    jupiter = new Planet()
      ..name = "jupiter"
      ..orbitalRadius = 500.0
      ..radius = 100.0
      ..rotationRate = 30.0
      ..fillColor = Ranger.color4IFromHex("#7a7256").toString()
      ..coalesce();

    _system.addChild(jupiter.system);
    ranger.animations.rotateBy(
        jupiter.system,
        60.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();
  }

  void _saturn() {
    saturn = new Planet()
      ..name = "saturn"
      ..orbitalRadius = 650.0
      ..radius = 90.0
      ..rotationRate = 30.0
      ..fillColor = Ranger.color4IFromHex("#a08629").toString()
      ..coalesce();

    _system.addChild(saturn.system);
    ranger.animations.rotateBy(
        saturn.system,
        80.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();
  }

  void _uranus() {
    uranus = new Planet()
      ..name = "uranus"
      ..orbitalRadius = 750.0
      ..radius = 60.0
      ..rotationRate = 30.0
      ..fillColor = Ranger.color4IFromHex("#99d6ea").toString()
      ..coalesce();

    _system.addChild(uranus.system);
    ranger.animations.rotateBy(
        uranus.system,
        80.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();
  }

  void _neptune() {
    neptune = new Planet()
      ..name = "neptune"
      ..orbitalRadius = 900.0
      ..radius = 60.0
      ..rotationRate = 40.0
      ..fillColor = Ranger.color4IFromHex("#0077c8").toString()
      ..coalesce();

    _system.addChild(neptune.system);
    ranger.animations.rotateBy(
        neptune.system,
        100.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(100000, 0.0)
      ..start();
  }

  @override
  bool onMouseDown(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_dragGroup, event.offset.x, event.offset.y);

    if (_dragGroup.pointInsideByComp(nodeP.v.x, nodeP.v.y)) {
      nodeP.moveToPool();

      // Translations are almost always relative to the a Node's parent, in this case
      // the rectangle's parent is "this" MainLayer.
      nodeP = ranger.drawContext.mapViewToNode(this, event.offset.x, event.offset.y);

      prevX = nodeP.v.x;
      prevY = nodeP.v.y;

      nodeP.moveToPool();
      _dragging = true;

      return true;
    }
    nodeP.moveToPool();

    return true;
  }

  @override
  bool onMouseMove(MouseEvent event) {

    mercury.pointInsideByView(event.offset.x, event.offset.y);
    venus.pointInsideByView(event.offset.x, event.offset.y);
    moon.pointInsideByView(event.offset.x, event.offset.y);
    earth.pointInsideByView(event.offset.x, event.offset.y);
    mars.pointInsideByView(event.offset.x, event.offset.y);
    jupiter.pointInsideByView(event.offset.x, event.offset.y);
    saturn.pointInsideByView(event.offset.x, event.offset.y);
    uranus.pointInsideByView(event.offset.x, event.offset.y);
    neptune.pointInsideByView(event.offset.x, event.offset.y);

    if (_dragging) {
      Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_dragGroup, event.offset.x, event.offset.y);

      double dx = nodeP.v.x - prevX;
      double dy = nodeP.v.y - prevY;

      _system.moveByComp(dx, dy);

      prevX = nodeP.v.x;
      prevY = nodeP.v.y;

      nodeP.moveToPool();
    }

    return false;
  }

  @override
  bool onMouseUp(MouseEvent event) {

    _dragging = false;
    return false;
  }

  @override
  bool onKeyDown(KeyboardEvent event) {

    switch (event.keyCode) {
      case KeyCode.ONE:
        // stop
        break;
    }
    return true;
  }

}