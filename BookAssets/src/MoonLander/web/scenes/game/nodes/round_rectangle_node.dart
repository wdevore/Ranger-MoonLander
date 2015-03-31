part of moonlander;

class RoundRectangleNode extends Ranger.Node {
  String outlineColor;
  String fillColor;
  
  double cornerRadius = 15.0;
  double width;
  double height;
  double cornerX = 0.0;
  double cornerY = 0.0;

  static const double outlineThickness = 3.0;

  Aabb2 _aabbox = new Aabb2();

  RoundRectangleNode();
  
  factory RoundRectangleNode.basic([Ranger.Color4<int> fillColor, Ranger.Color4<int> outlineColor = null]) {
    RoundRectangleNode o = new RoundRectangleNode();
    if (o.init()) {
      if (fillColor != null)
        o.fillColor = fillColor.toString();
      if (outlineColor != null)
        o.outlineColor = outlineColor.toString();
      return o;
    }
    
    return null;
  }
  
  /**
   * [p] should be in node's local-space.
   */
  @override
  bool pointInside(Vector2 p) {
    return localBounds.containsVector2(p);
  }

  Aabb2 get localBounds {
    _aabbox.min.setValues(cornerX, cornerY);
    _aabbox.max.setValues(cornerX + width, cornerY + height);
    return _aabbox;
  }

  void _roundedRect(CanvasRenderingContext2D context, num cornerX, num cornerY, num width, num height, num cornerRadius) {
    // Forgetting to use beginPath/closePath will leads to serious
    // memory consumption because this code is called on every frame which
    // means the path keeps growing eventually eating all memory!
    context.beginPath();
    if (width > 0) 
      context.moveTo(cornerX + cornerRadius, cornerY); 
    else
      context.moveTo(cornerX - cornerRadius, cornerY);
    
    context.arcTo(cornerX + width, cornerY, cornerX + width, cornerY + height, cornerRadius); 
    context.arcTo(cornerX + width, cornerY + height, cornerX, cornerY + height, cornerRadius); 
    context.arcTo(cornerX, cornerY + height, cornerX, cornerY, cornerRadius);
    
    if (width > 0) { 
      context.arcTo(cornerX, cornerY, cornerX + cornerRadius, cornerY, cornerRadius);
    } 
    else { 
      context.arcTo(cornerX, cornerY, cornerX - cornerRadius, cornerY, cornerRadius);
    }
    context.closePath();
  }

  @override
  void draw(Ranger.DrawContext context) {
    context.save();
    
    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    _roundedRect(context2D, cornerX, cornerY, width, height, cornerRadius);

    if (fillColor != null) {
      context2D.fillStyle = fillColor;
      context2D.fill();
    }

    // Note: strokes can scale to the point that the fill can't be seen.
    // An inverse scale is needed if the Node is scaled.
    if (outlineColor != null) {
      context2D..strokeStyle = outlineColor
               ..lineWidth = outlineThickness / calcUniformScaleComponent();
      context2D.stroke();
    }

    context.restore();
  }
}
