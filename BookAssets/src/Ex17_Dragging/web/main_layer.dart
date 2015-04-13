part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode rectangle;

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
    enableMouse = true;

    rectangle = new RectangleNode()
      ..init()
      ..setPosition(500.0, 500.0)
      ..uniformScale = 150.0;

    addChild(rectangle);

    super.onEnter();
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