part of moonlander;

class AnimatableCircleNode extends Ranger.Node with UTE.Tweenable {
  static const int SCALE = 10;
  static const int ALPHA_OUTLINE = 20;
  static const int ALPHA_FILL = 30;

  Ranger.Color4<int> fillColor;
  Ranger.Color4<int> outlineColor;
  
  double outlineThickness = 3.0;

  // ----------------------------------------------------------
  // Poolable support and Factory
  // ----------------------------------------------------------
  AnimatableCircleNode();
  
  AnimatableCircleNode._();
  factory AnimatableCircleNode.pooled() {
    AnimatableCircleNode poolable = new Ranger.Poolable.of(AnimatableCircleNode, _createPoolable);
    poolable.pooled = true;
    return poolable;
  }

  factory AnimatableCircleNode.basic([double fromScale = 1.0]) {
    AnimatableCircleNode poolable = new AnimatableCircleNode.pooled();
    if (poolable.init()) {
      poolable.initWithUniformScale(poolable, fromScale);
      return poolable;
    }
    return null;
  }
  
  static AnimatableCircleNode _createPoolable() => new AnimatableCircleNode._();

  AnimatableCircleNode clone() {
    AnimatableCircleNode poolable = new AnimatableCircleNode.pooled();
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
      context2D.fillStyle = fillColor.toString();
      context2D.fill();
    }

    if (outlineColor != null) {
      context2D..strokeStyle = outlineColor.toString()
               ..lineWidth = outlineThickness / calcUniformScaleComponent();
      context2D.stroke();
    }

    context.restore();
  }

  // -----------------------------------------------------------------
  // Tweenable interface
  // -----------------------------------------------------------------
  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case SCALE:
        returnValues[0] = uniformScale;
        return 1;
      case ALPHA_OUTLINE:
        returnValues[0] = outlineColor.alpha;
        return 1;
      case ALPHA_FILL:
        returnValues[0] = fillColor.alpha;
        return 1;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case SCALE:
        uniformScale = newValues[0];
        break;
      case ALPHA_OUTLINE:
        outlineColor.a = newValues[0];
        break;
      case ALPHA_FILL:
        fillColor.a = newValues[0];
        break;
    }
  }

}
