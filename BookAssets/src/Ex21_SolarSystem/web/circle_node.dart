part of layer;

class CircleNode extends Ranger.Node with UTE.Tweenable {
  static const int SCALE = 100;
  static const int ALPHA_OUTLINE = 200;
  static const int ALPHA_FILL = 300;

  Ranger.Color4<int> fillColor;
  Ranger.Color4<int> outlineColor = Ranger.Color4IOrange;

  double outlineThickness = 3.0;

  CircleNode() {
    init();
  }

  @override
  void draw(Ranger.DrawContext context) {
    context.save();

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D..beginPath()
      ..arc(0.0, 0.0, 1.0, 0, Ranger.DrawContext.TPi)
      ..closePath();

    if (fillColor != null) {
      context2D
        ..fillStyle = fillColor.toString()
        ..fill();
    }

    if (outlineColor != null) {
      context2D
        ..strokeStyle = outlineColor.toString()
        ..lineWidth = outlineThickness / calcUniformScaleComponent()
        ..stroke();
    }

    context.restore();
  }

  // -----------------------------------------------------------------
  // Tweenable interface
  // -----------------------------------------------------------------
  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case SCALE:
        //print("get($name): $tweenType, $uniformScale SCALE");
        returnValues[0] = uniformScale;
        return 1;
      case ALPHA_OUTLINE:
        //print("get($name): $tweenType, ${outlineColor.alpha} ALPHA_OUTLINE");
        returnValues[0] = outlineColor.alpha;
        return 1;
      case ALPHA_FILL:
        returnValues[0] = fillColor.alpha;
        return 1;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case SCALE:
        //print("set($name): $tweenType, ${newValues[0]} SCALE");
        uniformScale = newValues[0];
        break;
      case ALPHA_OUTLINE:
        //print("set($name): $tweenType, ${newValues[0]} ALPHA_OUTLINE");
        outlineColor.a = newValues[0].ceil();
        break;
      case ALPHA_FILL:
        fillColor.a = newValues[0].ceil();
        break;
    }
  }

}
