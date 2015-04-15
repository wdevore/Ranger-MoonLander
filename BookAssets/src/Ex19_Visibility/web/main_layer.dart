part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode rectangle;
  RectangleNode tracker;
  ViewPortNode _viewPort;

  bool _dragging = false;
  double prevX = 0.0;
  double prevY = 0.0;

  Ranger.MutableRectangle wVRect;

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

    rectangle = new RectangleNode()
      ..init()
      ..setPosition(300.0, 500.0)
      ..stroke = false
      ..fill = true
      ..visible = false
      ..uniformScale = 150.0;
    addChild(rectangle);

    tracker = new RectangleNode()
      ..init()
      ..setPosition(300.0, 500.0)
      ..stroke = true
      ..fill = false
      ..uniformScale = 150.0;
    addChild(tracker);

    _viewPort = new ViewPortNode()
      ..init()
      ..setPosition(500.0, 250.0)
      ..scaleTo(1000.0, 500.0)
      ..stroke = true;
    addChild(_viewPort);

    wVRect = _viewPort.convertRectToWorldSpace(_viewPort.rect);

    super.onEnter();
  }

  @override
  bool onMouseDown(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(tracker, event.offset.x, event.offset.y);

    if (tracker.pointInsideByComp(nodeP.v.x, nodeP.v.y)) {
      nodeP.moveToPool();

      // Translations are almost always relative to the a Node's parent, in this case
      // the rectangle's parent is "this" MainLayer.
      nodeP = ranger.drawContext.mapViewToNode(this, event.offset.x, event.offset.y);

      prevX = nodeP.v.x;
      prevY = nodeP.v.y;

      nodeP.moveToPool();
      _dragging = true;

      _checkIntersect();

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
      tracker.moveByComp(dx, dy);

      prevX = nodeP.v.x;
      prevY = nodeP.v.y;

      _checkIntersect();

      nodeP.moveToPool();
    }

    return true;
  }

  @override
  bool onMouseUp(MouseEvent event) {
    _dragging = false;
    return true;
  }

  void _checkIntersect() {
    Ranger.MutableRectangle wRect = rectangle.convertRectToWorldSpace(rectangle.rect);

    bool intersect = wRect.intersects(wVRect);

    if (intersect) {
      rectangle.visible = true;
    }
    else {
      rectangle.visible = false;
    }

    wRect.moveToPool();
  }
}