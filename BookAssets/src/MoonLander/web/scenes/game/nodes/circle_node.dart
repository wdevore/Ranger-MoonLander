part of moonlander;

class CircleNode extends Ranger.Node {
  String fillColor;
  String outlineColor;
  
  static const double outlineThickness = 3.0;

  // ----------------------------------------------------------
  // Poolable support and Factory
  // ----------------------------------------------------------
  CircleNode();
  
  CircleNode._();
  factory CircleNode.pooled() {
    CircleNode poolable = new Ranger.Poolable.of(CircleNode, _createPoolable);
    poolable.pooled = true;
    return poolable;
  }

  factory CircleNode.basic([double fromScale = 1.0]) {
    CircleNode poolable = new CircleNode.pooled();
    if (poolable.init()) {
      poolable.initWithUniformScale(poolable, fromScale);
      return poolable;
    }
    return null;
  }
  
  static CircleNode _createPoolable() => new CircleNode._();

  CircleNode clone() {
    CircleNode poolable = new CircleNode.pooled();
    if (poolable.initWith(this)) {
      poolable.initWithUniformScale(poolable, scale.x);
      return poolable;
    }
    
    return null;
  }
  
  @override
  void draw(Ranger.DrawContext context) {
    context.save();

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D..beginPath()
       ..arc(0.0, 0.0, 1.0, 0, Ranger.DrawContext.TPi)
       ..closePath();

    if (fillColor != null) {
      context2D.fillStyle = fillColor;
      context2D.fill();
    }

    if (outlineColor != null) {
      context2D..strokeStyle = outlineColor
               ..lineWidth = outlineThickness / calcUniformScaleComponent();
      context2D.stroke();
    }

    context.restore();
  }

}
