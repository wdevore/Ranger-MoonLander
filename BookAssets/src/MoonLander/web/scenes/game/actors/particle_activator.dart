part of moonlander;

class ParticleActivator extends Ranger.ParticleActivation {
  Ranger.Variance lifetime = new Ranger.Variance.initWith(0.5, 1.0, 0.5);
  Ranger.Variance speed = new Ranger.Variance.initWith(1.0, 3.0, 2.0);
  Ranger.Variance startScale = new Ranger.Variance.initWith(5.0, 25.0, 10.0);
  Ranger.Variance endScale = new Ranger.Variance.initWith(5.0, 25.0, 10.0);
  Ranger.Variance angle = new Ranger.Variance.initWith(0.0, 1.0, 1.0);
  Ranger.Color4<int> startColor = Ranger.Color4IBlack;
  Ranger.Color4<int> endColor = Ranger.Color4IBlack;

  Math.Random _randGen = new Math.Random();

  void activate(Ranger.Particle particle, int emissionStyle, double posX, double posY) {
    
    activationData.lifespan = lifetime.value;
    activationData.speed = speed.value;
    activationData.startScale = startScale.value;
    activationData.endScale = endScale.value;
    activationData.startColor.setWith(startColor);
    activationData.endColor.setWith(endColor);
    
    switch(emissionStyle) {
      case Ranger.ParticleActivation.VARIANCE_DIRECTIONAL:
        angle.min = -angleVariance;
        angle.max = angleVariance;
        angle.variance = angleVariance / 2.0;
        
        activationData.velocity.directionByDegrees = angleDirection + angle.value;
        break;
      case Ranger.ParticleActivation.OMNI_DIRECTIONAL:
        activationData.velocity.directionByDegrees = _randGen.nextDouble() * 359.0;
        break;
      default:
        throw new Exception("Only VARIANCE_DIRECTIONAL and OMNI_DIRECTIONAL are supported by this Activator.");
        break;
    }

    // Pass the activation data along with the particle about to be
    // activated.
    particle.data = activationData;
    
    // Now that the particle is configured we can finally activate it.
    particle.activateAt(posX, posY);
  }
  
  void deactivate(Ranger.Particle particle) {
    // We have no immediate need to handle this at the moment.
    // Typically you would check if there a callback is defined and then
    // call it.
  }
}