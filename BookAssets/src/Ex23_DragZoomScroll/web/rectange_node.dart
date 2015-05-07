part of layer;

class RectangleNode extends Ranger.Node {
  String fillColor = Ranger.Color4IOrange.toString();
  String strokeColor = Ranger.Color4IBlack.toString();

  bool fill = true;
  bool stroke = false;

  Ranger.MutableRectangle _bbox = new Ranger.MutableRectangle.withP(0.0, 0.0, 1.0, 1.0);

  RectangleNode() {
    init();
  }

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    if (fill) {
      context2D
        ..fillStyle = fillColor
        ..fillRect(_bbox.left, _bbox.bottom, _bbox.width, _bbox.height);
    }

    if (stroke) {
      context2D
        ..strokeStyle = strokeColor
        ..lineWidth = 3.0 / calcUniformScaleComponent()
        ..strokeRect(_bbox.left, _bbox.bottom, _bbox.width, _bbox.height);
    }
  }

}