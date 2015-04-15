part of layer;

class RectangleNode extends Ranger.Node {
  String fillColor = Ranger.Color4IOrange.toString();
  String strokeColor = Ranger.Color4IBlack.toString();

  bool fill = true;
  bool stroke = false;

  Ranger.MutableRectangle _bbox = new Ranger.MutableRectangle.withP(-0.5, -0.5, 1.0, 1.0);

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    if (fill) {
      context2D
        ..fillStyle = fillColor
        ..fillRect(-0.5, -0.5, 1.0, 1.0);
    }

    if (stroke) {
      context2D
        ..strokeStyle = strokeColor
        ..lineWidth = 3.0 / calcUniformScaleComponent()
        ..strokeRect(-0.5, -0.5, 1.0, 1.0);
    }
  }

  Ranger.MutableRectangle get rect => _bbox;

  @override
  bool pointInsideByComp(double x, double y) {
    return _bbox.containsPointByComp(x, y);
  }

}