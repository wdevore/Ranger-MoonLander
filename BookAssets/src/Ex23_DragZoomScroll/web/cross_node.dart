part of layer;

class CrossNode extends Ranger.Node {
  String strokeColor = Ranger.Color4IBlack.toString();

  CrossNode() {
    init();
  }

  @override
  void draw(Ranger.DrawContext context) {
    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D
      ..strokeStyle = strokeColor
      ..lineWidth = 2.0 / calcUniformScaleComponent()
      ..beginPath()
      ..moveTo(-0.5, 0.0)
      ..lineTo(0.5, 0.0)
      ..moveTo(0.0, -0.5)
      ..lineTo(0.0, 0.5)
      ..stroke();
  }

}