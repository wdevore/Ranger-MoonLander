part of layer;

class LineNode extends Ranger.Node {
  String strokeColor = Ranger.Color4IBlack.toString();

  double sx = 0.0;
  double sy = 0.0;
  double ex = 0.0;
  double ey = 0.0;

  LineNode() {
    init();
  }

  @override
  void draw(Ranger.DrawContext context) {
    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D
      ..strokeStyle = strokeColor
      ..lineWidth = 3.0 / calcUniformScaleComponent()
      ..beginPath()
      ..moveTo(sx, sy)
      ..lineTo(ex, ey)
      ..stroke();
  }

}