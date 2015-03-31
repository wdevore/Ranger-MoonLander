part of moonlander;

class CircleParticleNode extends Ranger.Node with Ranger.Color4Mixin {
  
  // ----------------------------------------------------------
  // Poolable support and Factory
  // ----------------------------------------------------------
  CircleParticleNode();
  
  CircleParticleNode._();
  factory CircleParticleNode.pooled() {
    CircleParticleNode poolable = new Ranger.Poolable.of(CircleParticleNode, _createPoolable);
    poolable.pooled = true;
    return poolable;
  }

  factory CircleParticleNode.initWith(Ranger.Color4<int> from, [double fromScale = 1.0]) {
    CircleParticleNode poolable = new CircleParticleNode.pooled();
    if (poolable.init()) {
      poolable.initWithColor(from);
      poolable.initWithUniformScale(poolable, fromScale);
      return poolable;
    }
    return null;
  }
  
  static CircleParticleNode _createPoolable() => new CircleParticleNode._();

  CircleParticleNode clone() {
    CircleParticleNode poolable = new CircleParticleNode.pooled();
    if (poolable.initWith(this)) {
      poolable.initWithColor(initialColor);
      poolable.initWithUniformScale(poolable, scale.x);
      return poolable;
    }
    
    return null;
  }
  
  @override
  void draw(Ranger.DrawContext context) {
    context.save();

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D..fillStyle = color.toString()
       ..beginPath()
       ..arc(0.0, 0.0, 1.0, 0, Ranger.DrawContext.TPi)
       ..closePath()
       ..fill();

    context.restore();
  }

}
