part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  GroupDragNode _dragGroup;
  ZoomGroup _zoom;

  RectangleNode yellowRect;
  RectangleNode orangeRect;
  RectangleNode greenYellowRect;

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

    _dragGroup = new GroupDragNode()
      ..width = contentSize.width
      ..height = contentSize.height;
    addChild(_dragGroup);

    _zoom = new ZoomGroup.basic()
      ..setPosition(1000.0, 500.0);
    _dragGroup.addChild(_zoom);

    yellowRect = new RectangleNode()
      ..init()
      ..setPosition(0.0, 0.0)  // Near center-ish.
      ..fillColor = Ranger.color4IFromHex("#f5e1a4").toString()
      ..uniformScale = 150.0;

    _zoom.addChild(yellowRect);

    orangeRect = new RectangleNode()
      ..init()
      ..setPosition(-200.0, 0.0)  // Near center-ish.
      ..fillColor = Ranger.color4IFromHex("#ff7700").toString()
      ..uniformScale = 150.0;

    _zoom.addChild(orangeRect);

    greenYellowRect = new RectangleNode()
      ..init()
      ..setPosition(200.0, 0.0)  // Near center-ish.
      ..fillColor = Ranger.Color4IGreenYellow.toString()
      ..uniformScale = 150.0;

    _zoom.addChild(greenYellowRect);

    Ranger.TextNode text = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "LMB to drag"
      ..font = "normal 900 10px Verdana"
      ..setPosition(300.0, 800.0)
      ..uniformScale = 5.0;
    _dragGroup.addChild(text);

    text = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "Mouse wheel to zoom"
      ..font = "normal 900 10px Verdana"
      ..setPosition(300.0, 900.0)
      ..uniformScale = 5.0;
    _dragGroup.addChild(text);

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
  bool onMouseWheel(WheelEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_zoom, event.offset.x, event.offset.y);

    _zoom.scaleCenter.setValues(nodeP.v.x, nodeP.v.y);

    if (event.wheelDeltaY > 0) {
      // Zoom in
      _zoom.zoomBy(0.02);
    }
    else {
      // Zoom out
      _zoom.zoomBy(-0.02);
    }

    // Keeps browser from handling the event thus preventing a viewport scroll.
    event.preventDefault();

    return true;
  }

  bool onMouseMove(MouseEvent event) {

//    mercury.pointInsideByView(event.offset.x, event.offset.y);

    if (_dragging) {
      Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_dragGroup, event.offset.x, event.offset.y);

      double dx = nodeP.v.x - prevX;
      double dy = nodeP.v.y - prevY;

      // Note: we don't use _zoom's moveByComp() method because we want to
      // use ZoomGroup's internal transform and not the ZoomGroup's inherited Node
      // transform.
      _zoom.translateByComp(dx, dy);

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