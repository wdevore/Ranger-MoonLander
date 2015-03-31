part of moonlander;

class TriEngineRocketGearPart extends PhysicsActor {
  RectangleNode _part;

  TriEngineRocketGearPart();

  bool init() {
    _thrust.maxMagnitude = PhysicsActor.THRUST_MAX;
    // Default direction with the vertical
    _thrust.directionByDegrees = PhysicsActor.VISUAL_COORD_SYSTEM;
    
    _momentum.maxMagnitude = 200.0;

    return true;
  }
  
  Ranger.Node get node => _part;

  void constructPart(double width, double height, Ranger.Color4<int> color) {
    _part = new RectangleNode.basic(null);
    _part.fillColor = color.toString();
    _part.scaleTo(width, height);
  }

  void update(double dt) {
    updateThrust(dt);
  }

  @override
  Ranger.MutableRectangle<double> calcAABBox() {
    return null;
  }
}
