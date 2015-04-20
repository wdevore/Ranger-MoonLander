part of layer;

class RectangleNode extends Ranger.Node with UTE.Tweenable {
  static const int TINT = 0;
  static const int MOVE_X = 1;
  static const int MOVE_Y = 2;

  Ranger.Color4<int> fillColor = Ranger.Color4IOrange;

  RectangleNode();

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D..fillStyle = fillColor.toString()
      ..fillRect(-0.5, -0.5, 1.0, 1.0);

  }

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch (tweenType) {
      case TINT:
        returnValues[0] = fillColor.r;
        returnValues[1] = fillColor.g;
        returnValues[2] = fillColor.b;
        return 3;
      case MOVE_X:
        returnValues[0] = position.x;
        return 1;
      case MOVE_Y:
        returnValues[0] = position.y;
        return 1;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch (tweenType) {
      case TINT:
        fillColor.r = newValues[0].ceil();
        fillColor.g = newValues[1].ceil();
        fillColor.b = newValues[2].ceil();
        break;
      case MOVE_X:
        positionX = newValues[0];
        break;
      case MOVE_Y:
        positionY = newValues[0];
        break;
    }
  }

}