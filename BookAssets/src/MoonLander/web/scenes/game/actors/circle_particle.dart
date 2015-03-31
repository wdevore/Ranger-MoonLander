part of moonlander;

class CircleParticle extends Ranger.PositionalParticle with Ranger.ParticleScaleBehavior, Ranger.ParticleColorBehavior {
  Ranger.Color4Mixin _colorMix;
  
  CircleParticle();

  factory CircleParticle.withNode(Ranger.Node node) {
    CircleParticle p = new CircleParticle._poolable();
    p._colorMix = node as Ranger.Color4Mixin;
    p.initWithNode(node);
    return p;
  }

  factory CircleParticle._poolable() {
    CircleParticle poolable = new Ranger.Poolable.of(CircleParticle, _createPoolable);
    poolable.pooled = true;
    return poolable;
  }

  static CircleParticle _createPoolable() => new CircleParticle();
  
  CircleParticle clone() {
    // First clone the visual
    Ranger.Node nodeClone = node.clone();
    
    // Now create a new particle from the clone.
    CircleParticle p = new CircleParticle.withNode(nodeClone);
    
    // Copy the properties from this particle to the cloned version.
    p.initWithColor(fromColor, toColor);
    
    p.initWithScale(fromScale, toScale);
    
    return p;
  }

  @override
  void activateAt(double x, double y) {
    if (data != null) {
      Ranger.ActivationData pd = data as Ranger.ActivationData;

      fromColor.setWith(pd.startColor);
      toColor.setWith(pd.endColor);
      
      fromScale = pd.startScale;
      toScale = pd.endScale;
      
      velocity.speed = pd.speed;
      
      activateWithVelocityAndLife(pd.velocity, pd.lifespan);
    }
    else {
      throw new Exception("Particle's Data not present.");
    }

    super.activateAt(x, y);
  }

  @override
  void step(double time) {
    velocity.applyTo(node.position);
    
    stepColorBehavior(time);
    _colorMix.color.setWith(color);

    stepScaleBehavior(time);
    node.uniformScale = scale;
  }
}