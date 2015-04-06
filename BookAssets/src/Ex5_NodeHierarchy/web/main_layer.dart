part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode orangeRect;
  RectangleNode blueRect;
  RectangleNode greenYellowRect;

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

    orangeRect = new RectangleNode()
      ..init()
      ..setPosition(1000.0, 500.0)  // Near center-ish.
      ..uniformScale = 150.0;

    addChild(orangeRect);

    blueRect = new RectangleNode()
      ..init()
      ..fillColor = Ranger.Color4IBlue.toString()
      ..setPosition(1.0, 0.0)
      ..uniformScale = 1.0;

    orangeRect.addChild(blueRect);

    greenYellowRect = new RectangleNode()
      ..init()
      ..fillColor = Ranger.Color4IGreenYellow.toString()
      ..setPosition(1.0, 0.0)
      ..uniformScale = 1.0;

    blueRect.addChild(greenYellowRect);

    super.onEnter();
  }

  @override
  bool onKeyDown(KeyboardEvent event) {

    switch (event.keyCode) {
      case KeyCode.ONE:
        orangeRect.rotationByDegrees = orangeRect.rotationInDegrees + 5.0;
        break;
      case KeyCode.TWO:
        orangeRect.rotationByDegrees = orangeRect.rotationInDegrees - 5.0;
        break;
      case KeyCode.THREE:
        blueRect.rotationByDegrees = blueRect.rotationInDegrees + 5.0;
        break;
      case KeyCode.FOUR:
        blueRect.rotationByDegrees = blueRect.rotationInDegrees - 5.0;
        break;
      case KeyCode.FIVE:
        greenYellowRect.rotationByDegrees = greenYellowRect.rotationInDegrees + 5.0;
        break;
      case KeyCode.SIX:
        greenYellowRect.rotationByDegrees = greenYellowRect.rotationInDegrees - 5.0;
        break;
      case KeyCode.SEVEN:
        orangeRect.uniformScale = orangeRect.uniformScale + 10.0;
        break;
      case KeyCode.EIGHT:
        orangeRect.uniformScale = orangeRect.uniformScale - 10.0;
        break;
      case KeyCode.A:
        blueRect.positionX = blueRect.position.x - 1.0;
        break;
      case KeyCode.S:
        blueRect.positionX = blueRect.position.x + 1.0;
        break;
      case KeyCode.Z:
        blueRect.positionX = blueRect.position.x - (10.0 / orangeRect.uniformScale);
        break;
      case KeyCode.X:
        blueRect.positionX = blueRect.position.x + (10.0 / orangeRect.uniformScale);
        break;
    }
    return true;
  }

}