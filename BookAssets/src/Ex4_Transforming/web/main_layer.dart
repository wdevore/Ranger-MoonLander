part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode rectangle;

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

    rectangle = new RectangleNode()
      ..init()
      ..setPosition(1000.0, 500.0)  // Near center-ish.
      ..uniformScale = 150.0;

    addChild(rectangle);

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

}