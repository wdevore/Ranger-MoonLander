part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode _orangeRect;
  RectangleNode _yellowGreenRect;

  Ranger.TextNode _localSpaceOfRect;
  Ranger.TextNode _parentSpaceOfRect;
  Ranger.TextNode _mouseSpace;

  Ranger.TextNode _localX;
  Ranger.TextNode _localY;
  RectangleNode _localRect;
  LineNode _xLine;
  LineNode _yLine;

  Ranger.TextNode _localYGX;
  Ranger.TextNode _localYGY;
  LineNode _xYGLine;
  LineNode _yYGLine;

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

    UTE.Tween.registerAccessor(RectangleNode, ranger.animations);

    _configureYGRect();

    _configureOrangeRect();

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

  void _configureYGRect() {
    _yellowGreenRect = new RectangleNode()
      ..init()
      ..fillColor = Ranger.Color4IGreenYellow.toString()
      ..setPosition(1500.0, 400.0)  // Near center-ish.
      ..uniformScale = 150.0;
    addChild(_yellowGreenRect);

    _localYGX = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "X"
      ..font = "normal 200 10px Verdana"
      ..setPosition(1.0, 0.0)
      ..uniformScale = 3.0 / _yellowGreenRect.uniformScale;
    _yellowGreenRect.addChild(_localYGX);

    _xYGLine = new LineNode()
      ..strokeColor = Ranger.Color4IBlack.toString();
    _yellowGreenRect.addChild(_xYGLine);
    _yYGLine = new LineNode()
      ..strokeColor = Ranger.Color4IBlack.toString();
    _yellowGreenRect.addChild(_yYGLine);

    LineNode xAxis = new LineNode()
      ..strokeColor = Ranger.Color4IGreen.toString()
      ..ex = 1.0;
    _yellowGreenRect.addChild(xAxis);

    LineNode yAxis = new LineNode()
      ..strokeColor = Ranger.Color4IBlue.toString()
      ..ey = 1.0;
    _yellowGreenRect.addChild(yAxis);

    _localYGY = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "Y"
      ..font = "normal 200 10px Verdana"
      ..setPosition(0.0, 1.0)
      ..uniformScale = 3.0 / _yellowGreenRect.uniformScale;
    _yellowGreenRect.addChild(_localYGY);

  }

  void _configureOrangeRect() {
    _orangeRect = new RectangleNode()
      ..init()
      ..setSize(-1.0, -1.0, 2.0, 2.0)
      ..setPosition(500.0, 500.0)  // Near center-ish.
      ..uniformScale = 100.0;
    addChild(_orangeRect);

    ranger.animations.rotateBy(
        _orangeRect,
        20.0,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(10000, 0.0)
      ..start();

    _localX = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "X"
      ..font = "normal 200 10px Verdana"
      ..setPosition(1.0, 0.0)
      ..uniformScale = 3.0 / _orangeRect.uniformScale;
    _orangeRect.addChild(_localX);

    _xLine = new LineNode()
      ..strokeColor = Ranger.Color4IBlue.toString();
    _orangeRect.addChild(_xLine);
    _yLine = new LineNode()
      ..strokeColor = Ranger.Color4IBlue.toString();
    _orangeRect.addChild(_yLine);

    LineNode xAxis = new LineNode()
      ..strokeColor = Ranger.Color4IGreen.toString()
      ..ex = 1.0;
    _orangeRect.addChild(xAxis);

    LineNode yAxis = new LineNode()
      ..strokeColor = Ranger.Color4IBlue.toString()
      ..ey = 1.0;
    _orangeRect.addChild(yAxis);

    _localY = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "Y"
      ..font = "normal 200 10px Verdana"
      ..setPosition(0.0, 1.0)
      ..uniformScale = 3.0 / _orangeRect.uniformScale;
    _orangeRect.addChild(_localY);

    _localRect = new RectangleNode()
      ..init()
      ..fillColor = Ranger.Color4IRed.toString()
      ..setPosition(0.0, 0.0)  // Near center-ish.
      ..uniformScale = 20.0 / _orangeRect.uniformScale;
    _orangeRect.addChild(_localRect);
  }

  @override
  bool onKeyDown(KeyboardEvent event) {

    switch (event.keyCode) {
      case 49: // 1
        _orangeRect.uniformScale = _orangeRect.uniformScale + 10.0;
        break;
      case 50: // 2
        _orangeRect.uniformScale = _orangeRect.uniformScale - 10.0;
        break;
      case 51: // 3
        _orangeRect.rotationByDegrees = _orangeRect.rotationInDegrees + 5.0;
        break;
      case 52: // 4
        _orangeRect.rotationByDegrees = _orangeRect.rotationInDegrees - 5.0;
        break;
      case 53: // 5
        _orangeRect.positionX = _orangeRect.position.x - 10.0;
        break;
      case 54: // 6
        _orangeRect.positionX = _orangeRect.position.x + 10.0;
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

    Ranger.Vector2P nodeYGP = ranger.drawContext.mapViewToNode(_yellowGreenRect, x, y);

    if (_yellowGreenRect.pointInsideByComp(nodeYGP.v.x, nodeYGP.v.y)) {

      double lx = nodeYGP.v.x;
      double ly = nodeYGP.v.y;

      _xYGLine.by = ly;
      _xYGLine.ey = ly;
      _xYGLine.ex = lx;

      _yYGLine.bx = lx;
      _yYGLine.ex = lx;
      _yYGLine.ey = ly;

      Ranger.AffineTransform at = new Ranger.AffineTransform.IdentityP();
      at.scale(_orangeRect.width, _orangeRect.height);

      Ranger.Vector2P p = Ranger.PointApplyAffineTransform(nodeYGP.v, at);

      lx = p.v.x;
      ly = p.v.y;

      _localRect.setPosition(lx, ly);

      _xLine.by = ly;
      _xLine.ey = ly;
      _xLine.ex = lx;

      _yLine.bx = lx;
      _yLine.ex = lx;
      _yLine.ey = ly;

      nodeYGP.moveToPool();
      at.moveToPool();

      return;
    }

    nodeYGP.moveToPool();
  }

  void _updateTextNodes(int x, int y) {

    _mouseSpace.text = "mouse: $x, $y";

    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_orangeRect, x, y);
    _localSpaceOfRect.text = "local: ${(nodeP.v.x * _orangeRect.uniformScale).toStringAsFixed(2)}, ${(nodeP.v.y * _orangeRect.uniformScale).toStringAsFixed(2)}";
    nodeP.moveToPool();

    nodeP = ranger.drawContext.mapViewToNode(this, x, y);
    _parentSpaceOfRect.text = "parent: ${nodeP.v.x.toStringAsFixed(2)}, ${nodeP.v.y.toStringAsFixed(2)}";
    nodeP.moveToPool();
  }

}