part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode rectangle;

  Ranger.TextNode _localSpaceOfRect;
  Ranger.TextNode _parentSpaceOfRect;
  Ranger.TextNode _mouseSpace;


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

    rectangle = new RectangleNode()
      ..init()
      ..setPosition(1000.0, 500.0)  // Near center-ish.
      ..uniformScale = 150.0;

    addChild(rectangle);

    _localSpaceOfRect = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "local:"
      ..font = "normal 900 10px Verdana"
      ..setPosition(500.0, 800.0)
      ..uniformScale = 5.0;
    addChild(_localSpaceOfRect);

    _parentSpaceOfRect = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "parent:"
      ..font = "normal 900 10px Verdana"
      ..setPosition(500.0, 900.0)
      ..uniformScale = 5.0;
    addChild(_parentSpaceOfRect);

    _mouseSpace = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "mouse:"
      ..font = "normal 900 10px Verdana"
      ..setPosition(500.0, 1000.0)
      ..uniformScale = 5.0;
    addChild(_mouseSpace);

    super.onEnter();
  }

  @override
  bool onKeyDown(KeyboardEvent event) {

    switch (event.keyCode) {
      case 49: // 1
        rectangle.uniformScale = rectangle.uniformScale + 10.0;
        break;
      case 50: // 2
        rectangle.uniformScale = rectangle.uniformScale - 10.0;
        break;
      case 51: // 3
        rectangle.rotationByDegrees = rectangle.rotationInDegrees + 5.0;
        break;
      case 52: // 4
        rectangle.rotationByDegrees = rectangle.rotationInDegrees - 5.0;
        break;
      case 53: // 5
        rectangle.positionX = rectangle.position.x - 10.0;
        break;
      case 54: // 6
        rectangle.positionX = rectangle.position.x + 10.0;
        break;
    }
    return true;
  }

  @override
  bool onMouseMove(MouseEvent event) {

    _updateTextNodes(event.offset.x, event.offset.y);

    return true;
  }

  void _updateTextNodes(int x, int y) {

    _mouseSpace.text = "mouse: $x, $y";

    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(rectangle, x, y);
    _localSpaceOfRect.text = "local: ${(nodeP.v.x * rectangle.uniformScale).toStringAsFixed(2)}, ${(nodeP.v.y * rectangle.uniformScale).toStringAsFixed(2)}";
    nodeP.moveToPool();

    nodeP = ranger.drawContext.mapViewToNode(this, x, y);
    _parentSpaceOfRect.text = "parent: ${nodeP.v.x.toStringAsFixed(2)}, ${nodeP.v.y.toStringAsFixed(2)}";
    nodeP.moveToPool();
  }

}