part of layer;

/**
 * This may be converted to a mixin.
 */
class ZoomGroup extends Ranger.GroupNode with UTE.Tweenable {
  static const int TWEEN_SCALE = 1;
  static const int TRANSLATE_XY = 3;

  bool _zoomDirty = true;
  Vector2 scaleCenter = new Vector2.zero();
  bool zoomIconVisible = false;

  Ranger.AffineTransform atSCTransform = new Ranger.AffineTransform.Identity();
  Ranger.AffineTransform zoomCenter = new Ranger.AffineTransform.Identity();
  Ranger.AffineTransform scaleTransform = new Ranger.AffineTransform.Identity();
  Ranger.AffineTransform negScaleCenter = new Ranger.AffineTransform.Identity();
  Ranger.AffineTransform atTransform = new Ranger.AffineTransform.Identity();

  ZoomGroup._();

  factory ZoomGroup.basic() {
    ZoomGroup poolable = new ZoomGroup.pooled();
    if (poolable.init()) {
      poolable.initGroupingBehavior(poolable);
      poolable.atSCTransform.toIdentity();
      poolable._updateMatrix();
      poolable.tag = 606;
      // Setting dirty=false is very important for this Node because this
      // Node manages its own matrix. Setting it to True will cause the
      // transform stack to overlay it--not good.
      poolable.dirty = false;
      poolable.managedTransform = true;
      return poolable;
    }
    return null;
  }

  factory ZoomGroup.pooled() {
    ZoomGroup poolable = new Ranger.Poolable.of(ZoomGroup, _createPoolable);
    poolable.pooled = true;
    return poolable;
  }

  static ZoomGroup _createPoolable() => new ZoomGroup._();

  void _updateMatrix() {
    if (_zoomDirty) {
      zoomCenter.setToTranslate(scaleCenter.x, scaleCenter.y);
      scaleTransform.setToScale(scale.x, scale.y);
      negScaleCenter.setToTranslate(-scaleCenter.x, -scaleCenter.y);

      // Accumulate zoom transformations.
      // atSCTransform is an intermediate accumulative matrix used for tracking the current zoom target.
      Ranger.affineTransformMultiplyTo(zoomCenter, atSCTransform);
      Ranger.affineTransformMultiplyTo(scaleTransform, atSCTransform);
      Ranger.affineTransformMultiplyTo(negScaleCenter, atSCTransform);

      // We reset Scale because atSCTransform is accumulative.
      scale.setValues(1.0, 1.0);

      // Tack on translation. Note: we don't append it, but concat it into a separate matrix.
      // We want to leave atSCTransform solely responsible for zooming.
      atTransform.setToTranslate(position.x, position.y);

      // "transform" is the final matrix for this node.
      transform.multiply(atSCTransform, atTransform);

      // Now that we have rebuilt the transform matrix is it no longer dirty.
      _zoomDirty = false;
    }
  }

  /**
   * A relative zoom.
   * [delta] is a delta relative to the current scale/zoom.
   */
  void zoomBy(double delta) {
    scale.setValues(scale.x + delta, scale.y + delta);
    _zoomDirty = true;
    ranger.eventBus.fire(this);

    _updateMatrix();
  }

  /**
   * Not typically used unless you want to translate the layer. Typically
   * you would set the [scaleCenter] instead of this position.
   * It is provide simply for convienience.
   */
  void translateBy(Vector2 delta) {
    position.add(delta);
    _zoomDirty = true;
    _updateMatrix();
  }

  void translateByComp(double dx, double dy) {
    position.x += dx;
    position.y += dy;
    _zoomDirty = true;
    _updateMatrix();
  }

  /**
   * Overrides [PositionalBehavior]'s setter
   * Not typically used unless you want to translate the layer. Typically
   * you would set the [scaleCenter] instead of this position.
   * It is provide simply for convienience.
   */
  @override
  set position(Vector2 pos) {
    position.setFrom(pos);
    _zoomDirty = true;
    _updateMatrix();
  }

  /**
   * Set the zoom value absolutely. If you want to zoom relative use
   * [zoomBy]
   */
  set currentScale(double newScale) {
    // We use dimensional anaylsis to set the scale. Remember we can't
    // just set the scale absolutely because atSCTransform is an accumulating matrix.
    // We have to take its current value and compute a new value based
    // on the passed in value.

    // Also, I can use atSCTransform.a because I don't allow rotation on this
    // layer so the diagonal components correctly represent the matrix's current scale.
    // And because I only perform uniform scaling I can safely use just the "a" element.
    double scaleFactor = newScale / atSCTransform.a;

    scale.setValues(scaleFactor, scaleFactor);

    _zoomDirty = true;
    ranger.eventBus.fire(this);

    _updateMatrix();
  }

  double get currentScale => atSCTransform.a;

  // ---------------------------------------------------------------
  // Tweenable implementation
  // ---------------------------------------------------------------
  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case TWEEN_SCALE:
        returnValues[0] = currentScale;
        return 1;
      case TRANSLATE_XY:
        returnValues[0] = position.x;
        returnValues[1] = position.y;
        return 2;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case TWEEN_SCALE:
        currentScale = newValues[0];
        break;
      case TRANSLATE_XY:
        position.x = newValues[0];
        position.y = newValues[1];
        dirty = true;
        break;
    }
  }

  // ---------------------------------------------------------------
  // Rendering
  // ---------------------------------------------------------------
  @override
  void draw(Ranger.DrawContext context) {
    super.draw(context);
    if (zoomIconVisible) {
      context.save();
      context.drawColor = Ranger.Color4IWhite.toString();

      double invScale = 3.0 / calcUniformScaleComponent();
      context.lineWidth = invScale;

      context.drawLineByComp(-1.0 * iconScale + scaleCenter.x, scaleCenter.y, 1.0 * iconScale + scaleCenter.x, scaleCenter.y);
      context.drawLineByComp(scaleCenter.x, -1.0 * iconScale + scaleCenter.y, scaleCenter.x, 1.0 * iconScale + scaleCenter.y);

      context.restore();
    }
  }
}