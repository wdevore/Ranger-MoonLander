part of layer;

class PixelNode extends Ranger.Node with UTE.Tweenable {
  static const int FADE = 0;

  Ranger.Color4<int> fillColor = Ranger.Color4IOrange;

  bool triggered = false;

  PixelNode() {
    init();
  }

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D..fillStyle = fillColor.toString()
      ..fillRect(-0.5, -0.5, 1.0, 1.0);

  }

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch (tweenType) {
      case FADE:
        returnValues[0] = fillColor.a;
        return 1;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch (tweenType) {
      case FADE:
        fillColor.a = newValues[0].ceil();
        break;
    }
  }

}