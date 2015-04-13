part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode rectangle;

  bool _dragging = false;
  double prevX = 0.0;
  double prevY = 0.0;

  DualRangeZone _zoneRotate;
  DualRangeZone _zoneScale;

  StreamSubscription<DualRangeZone> _busStream;

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

    UTE.Tween.registerAccessor(RectangleNode, ranger.animations);

    rectangle = new RectangleNode()
      ..init()
      ..setPosition(1000.0, 800.0)
      ..uniformScale = 150.0;

    addChild(rectangle);

    Ranger.TextNode text = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "Rotate"
      ..font = "normal 900 10px Verdana"
      ..setPosition(400.0, 500.0)
      ..uniformScale = 5.0;
    addChild(text);

    text = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "Scale"
      ..font = "normal 900 10px Verdana"
      ..setPosition(1400.0, 500.0)
      ..uniformScale = 5.0;
    addChild(text);

    text = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "Drag rectangle into Zones."
      ..font = "normal 900 10px Verdana"
      ..setPosition(500.0, 1000.0)
      ..uniformScale = 5.0;
    addChild(text);

    _zoneRotate = new DualRangeZone.initWith(
        Ranger.color4IFromHex("#ffaa00"),
        Ranger.color4IFromHex("#ffaa77"),
        200.0, 300.0)
      ..positionX = 500.0
      ..positionY = 500.0
      ..iconsVisible = true
      ..zoneId = 1;
    addChild(_zoneRotate);

    _zoneScale = new DualRangeZone.initWith(
        Ranger.color4IFromHex("#aa00aa"),
        Ranger.color4IFromHex("#0077aa"),
        200.0, 300.0)
      ..positionX = 1500.0
      ..positionY = 500.0
      ..iconsVisible = true
      ..zoneId = 2;
    addChild(_zoneScale);

    _busStream = ranger.eventBus.on(DualRangeZone).listen(
      (DualRangeZone zone) {
        _dualRangeZoneAction(zone);
      });

    super.onEnter();
  }

  @override
  void onExit() {
    if (_busStream != null)
      _busStream.cancel();
  }

  void _dualRangeZoneAction(DualRangeZone zone) {
    switch (zone.zoneId) {
      case 1:
        switch (zone.action) {
          case DualRangeZone.ZONE_INWARD_ACTION:
            // Start rotating
            ranger.animations.rotateBy(
                rectangle,
                2.0,
                360.0,
                UTE.Linear.INOUT, null, false)
              ..repeat(10000, 0.0)
              ..start();
            break;
          case DualRangeZone.ZONE_OUTWARD_ACTION:
            // Stop rotating.
            ranger.animations.stopAndUntrack(rectangle, Ranger.TweenAnimation.ROTATE);
            break;
        }
        break;
      case 2:
        switch (zone.action) {
          case DualRangeZone.ZONE_INWARD_ACTION:
            ranger.animations.scaleBy(
                rectangle,
                0.25,
                75.0, 75.0,
                UTE.Linear.INOUT,
                Ranger.TweenAnimation.SCALE_XY, Ranger.TweenAnimation.MULTIPLY,
                null, false)
              ..repeatYoyo(10000, 0.0)
              ..start();
            break;
          case DualRangeZone.ZONE_OUTWARD_ACTION:
            ranger.animations.stopAndUntrack(rectangle, Ranger.TweenAnimation.SCALE_XY);
            rectangle.uniformScale = 150.0;
            break;
        }
        break;
    }
  }

  @override
  bool onMouseDown(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(rectangle, event.offset.x, event.offset.y);

    if (rectangle.pointInsideByComp(nodeP.v.x, nodeP.v.y)) {
      nodeP.moveToPool();

      // Translations are almost always relative to the a Node's parent, in this case
      // the rectangle's parent is "this" MainLayer.
      nodeP = ranger.drawContext.mapViewToNode(this, event.offset.x, event.offset.y);

      prevX = nodeP.v.x;
      prevY = nodeP.v.y;

      _zoneRotate.updateState(prevX, prevY);
      _zoneScale.updateState(prevX, prevY);

      nodeP.moveToPool();
      _dragging = true;

      return true;
    }
    nodeP.moveToPool();

    return true;
  }

  @override
  bool onMouseMove(MouseEvent event) {
    if (_dragging) {
      Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(this, event.offset.x, event.offset.y);

      double dx = nodeP.v.x - prevX;
      double dy = nodeP.v.y - prevY;

      rectangle.moveByComp(dx, dy);

      _zoneRotate.updateState(prevX, prevY);
      _zoneScale.updateState(prevX, prevY);

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

}