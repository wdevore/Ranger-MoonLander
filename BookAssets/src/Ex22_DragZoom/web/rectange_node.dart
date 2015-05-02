part of layer;

class RectangleNode extends Ranger.Node with Ranger.GroupingBehavior {
  String fillColor = Ranger.Color4IOrange.toString();

  RectangleNode() {
    initGroupingBehavior(this);
  }

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D..fillStyle = fillColor
      ..fillRect(-0.5, -0.5, 1.0, 1.0);

  }

}