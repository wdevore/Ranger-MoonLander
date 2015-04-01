part of scene;

class RectangleNode extends Ranger.Node {
  String fillColor = Ranger.Color4IBlue.toString();

  @override
  void draw(Ranger.DrawContext context) {
    context.save();

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D..fillStyle = fillColor
      ..fillRect(-0.5, -0.5, 1.0, 1.0);

    context.restore();
  }
}