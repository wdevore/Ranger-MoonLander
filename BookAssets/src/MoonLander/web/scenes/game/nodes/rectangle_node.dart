part of moonlander;

class RectangleNode extends Ranger.Node {
  String outlineColor;
  String fillColor;
  
  static const double outlineThickness = 3.0;

  bool centered = true;
  Aabb2 _aabbox = new Aabb2();

  RectangleNode();
  
  factory RectangleNode.basic(Ranger.Color4<int> fillColor, [Ranger.Color4<int> outlineColor = null]) {
    RectangleNode o = new RectangleNode();
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
      if (centered)
        context2D.fillRect(-0.5, -0.5, 1.0, 1.0);
      else
        context2D.fillRect(0.0, -0.5, 1.0, 1.0); // vertical centered only
    }

    // Note: strokes can scale to the point that the fill can't be seen.
    // An inverse scale is needed if the Node is scaled.
    if (outlineColor != null) {
      context2D..strokeStyle = outlineColor
        ..lineWidth = outlineThickness / calcUniformScaleComponent();
      
      if (centered)
        context2D.strokeRect(-0.5, -0.5, 1.0, 1.0);
      else
        context2D.strokeRect(0.0, -0.5, 1.0, 1.0); // vertical centered only
    }

    context.restore();
  }
  
  Ranger.MutableRectangle<double> get localBounds {
    if (centered) {
      rect.bottom = -0.5;
      rect.left = -0.5;
    }
    else {
      rect.bottom = 0.0;
      rect.left = -0.5;
    }
    rect.width = 1.0;
    rect.height = 1.0;
    return rect;
  }

}
