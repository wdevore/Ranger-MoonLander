part of moonlander;

class TriEngineRocketPart extends PhysicsActor {
  Ranger.SpriteImage _part;

  TriEngineRocketPart();

  bool init() {
    _thrust.maxMagnitude = PhysicsActor.THRUST_MAX;
    // Default direction with the vertical
    _thrust.directionByDegrees = PhysicsActor.VISUAL_COORD_SYSTEM;
    
    _momentum.maxMagnitude = 200.0;

    return true;
  }
  
  Ranger.Node get node => _part;

  set enableBBoxVisual(bool b) => _part.aabboxVisible = b;

  void constructPart(ImageElement image) {
    _part = new Ranger.SpriteImage.basic(image);
    _part.tag = 100096;
  }

  void update(double dt) {
    updateThrust(dt);
  }

  @override
  Ranger.MutableRectangle<double> calcAABBox() {
    return null;
  }
}
