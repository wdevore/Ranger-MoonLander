part of moonlander;

class NonUniformRectangleNode extends Ranger.Node {
  String outlineColor;
  String fillColor;
  
  static const double outlineThickness = 3.0;

  double left = 0.0;
  double bottom = 0.0;
  double width = 1.0;
  double height = 1.0;
  
  NonUniformRectangleNode();
  
  factory NonUniformRectangleNode.basic(Ranger.Color4<int> fillColor, [Ranger.Color4<int> outlineColor = null]) {
    NonUniformRectangleNode o = new NonUniformRectangleNode();
    if (o.init()) {
      if (fillColor != null)
        o.fillColor = fillColor.toString();
      if (outlineColor != null)
        o.outlineColor = outlineColor.toString();
      return o;
    }
    
    return null;
  }
  
  @override
  void draw(Ranger.DrawContext context) {
    context.save();
    
    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    if (fillColor != null) {
      context2D.fillStyle = fillColor;
      context2D.fillRect(left, bottom, width, height);
    }

    // Note: strokes can scale to the point that the fill can't be seen.
    // An inverse scale is needed if the Node is scaled.
    if (outlineColor != null) {
      context2D..strokeStyle = outlineColor
        ..lineWidth = outlineThickness / calcUniformScaleComponent();
      context2D.strokeRect(left, bottom, width, height);
    }

    context.restore();
  }
}
