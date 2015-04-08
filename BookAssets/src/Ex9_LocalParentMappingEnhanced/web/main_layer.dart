part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode _rectangle;

  Ranger.TextNode _localSpaceOfRect;
  Ranger.TextNode _parentSpaceOfRect;
  Ranger.TextNode _mouseSpace;

  Ranger.TextNode _localX;
  Ranger.TextNode _localY;
  RectangleNode _localRect;
  LineNode _xLine;
  LineNode _yLine;

  int currentMouseX = 0;
  int currentMouseY = 0;

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

    _rectangle = new RectangleNode()
      ..init()
      ..setPosition(1000.0, 500.0)  // Near center-ish.
      ..uniformScale = 150.0;

    addChild(_rectangle);

    // Remember transform propagate to the children which means we needs
    // negate the scale from the parent by dividing by the rectangle.uniformScale
    _localX = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "X"
      ..font = "normal 200 10px Verdana"
      ..setPosition(1.0, 0.0)
      ..uniformScale = 3.0 / _rectangle.uniformScale;
    _rectangle.addChild(_localX);

    _xLine = new LineNode()
      ..strokeColor = Ranger.Color4IBlue.toString();
    _rectangle.addChild(_xLine);
    _yLine = new LineNode()
      ..strokeColor = Ranger.Color4IBlue.toString();
    _rectangle.addChild(_yLine);

    LineNode xAxis = new LineNode()
      ..strokeColor = Ranger.Color4IGreen.toString()
      ..ex = 1.0;
    _rectangle.addChild(xAxis);

    LineNode yAxis = new LineNode()
      ..strokeColor = Ranger.Color4IBlue.toString()
      ..ey = 1.0;
    _rectangle.addChild(yAxis);

    _localY = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "Y"
      ..font = "normal 200 10px Verdana"
      ..setPosition(0.0, 1.0)
      ..uniformScale = 3.0 / _rectangle.uniformScale;
    _rectangle.addChild(_localY);

    _localRect = new RectangleNode()
      ..init()
      ..fillColor = Ranger.Color4IRed.toString()
      ..setPosition(0.0, 0.0)  // Near center-ish.
      ..uniformScale = 20.0 / _rectangle.uniformScale;
    _rectangle.addChild(_localRect);




    _localSpaceOfRect = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "local:"
      ..font = "normal 900 10px Verdana"
      ..setPosition(100.0, 800.0)
      ..uniformScale = 5.0;
    addChild(_localSpaceOfRect);

    _parentSpaceOfRect = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "parent:"
      ..font = "normal 900 10px Verdana"
      ..setPosition(100.0, 900.0)
      ..uniformScale = 5.0;
    addChild(_parentSpaceOfRect);

    _mouseSpace = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "mouse:"
      ..font = "normal 900 10px Verdana"
      ..setPosition(100.0, 1000.0)
      ..uniformScale = 5.0;
    addChild(_mouseSpace);

    super.onEnter();
  }

  @override
  bool onKeyDown(KeyboardEvent event) {

    switch (event.keyCode) {
      case 49: // 1
        _rectangle.uniformScale = _rectangle.uniformScale + 10.0;
        break;
      case 50: // 2
        _rectangle.uniformScale = _rectangle.uniformScale - 10.0;
        break;
      case 51: // 3
        _rectangle.rotationByDegrees = _rectangle.rotationInDegrees + 5.0;
        break;
      case 52: // 4
        _rectangle.rotationByDegrees = _rectangle.rotationInDegrees - 5.0;
        break;
      case 53: // 5
        _rectangle.positionX = _rectangle.position.x - 10.0;
        break;
      case 54: // 6
        _rectangle.positionX = _rectangle.position.x + 10.0;
        break;
    }

    _updateDisplay();

    return true;
  }

  @override
  bool onMouseMove(MouseEvent event) {

    currentMouseX = event.offset.x;
    currentMouseY = event.offset.y;

    _updateDisplay();

    return true;
  }

  void _updateDisplay() {
    _updateTextNodes(currentMouseX, currentMouseY);
    _updateAxis(currentMouseX, currentMouseY);
  }

  void _updateAxis(int x, int y) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_rectangle, x, y);
    _localRect.setPosition(nodeP.v.x, nodeP.v.y);
    _xLine.by = nodeP.v.y;
    _xLine.ey = nodeP.v.y;
    _xLine.ex = nodeP.v.x;

    _yLine.bx = nodeP.v.x;
    _yLine.ex = nodeP.v.x;
    _yLine.ey = nodeP.v.y;
    nodeP.moveToPool();
  }

  void _updateTextNodes(int x, int y) {

    _mouseSpace.text = "mouse: $x, $y";

    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_rectangle, x, y);
    _localSpaceOfRect.text = "local: ${(nodeP.v.x * _rectangle.uniformScale).toStringAsFixed(2)}, ${(nodeP.v.y * _rectangle.uniformScale).toStringAsFixed(2)}";
    nodeP.moveToPool();

    nodeP = ranger.drawContext.mapViewToNode(this, x, y);
    _parentSpaceOfRect.text = "parent: ${nodeP.v.x.toStringAsFixed(2)}, ${nodeP.v.y.toStringAsFixed(2)}";
    nodeP.moveToPool();
  }

}