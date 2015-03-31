part of moonlander;

abstract class PhysicsActor extends MobileActor {
  static const double THRUST_DAMPING = 0.1;
  static const double THRUST_POWER = 1.0;
  static const double THRUST_MAX = 2.0;

  static const double MASS = 20.0;

  static const double VISUAL_COORD_SYSTEM = 90.0;

  bool _impulseOn = false;
  double _impulseDuration = 0.0;
  double _impulseDurationCount = 0.0;

  double _spinRate = 0.0;   // degree per 1/60 second
  double _power = 0.0;

  double mass = 20.0;

  Ranger.Velocity _thrust = new Ranger.Velocity();
  Ranger.Velocity _momentum = new Ranger.Velocity();

  double get verticalVelocity => _momentum.speed * _momentum.direction.y;
  double get horizontalVelocity => _momentum.speed * _momentum.direction.x;

  Vector2 v = new Vector2.zero();

  Ranger.Node get node;

  void updateThrust(double dt){
    if (_impulseOn) {
      _thrust.speed = _power / mass;
    }

    node.rotationByDegrees = node.rotationInDegrees + _spinRate;

    // Apply Thrust and Gravity
    _momentum.add(_thrust);
    _momentum.add(gm.gravity);

    v.setFrom(node.position);
    _momentum.applyTo(v);
    node.position = v;

    // If there is no thrust being applied then the thrust slowly dies off.
    if (_thrust.speed > 0.0) {
      _thrust.decreaseSpeed(PhysicsActor.THRUST_DAMPING / mass);
    }

    _impulseDurationCount += dt;

    if (_impulseDurationCount > _impulseDuration) {
      _impulseOn = false;
    }
  }

  /**
   * [directionAngle] if positive the CCW or to the left.
   */
  void applyImpulse(double directionAngle, double duration, double spinRate, double power) {
    _impulseOn = true;
    _impulseDurationCount = 0.0;
    _impulseDuration = duration;
    node.rotationByDegrees = directionAngle;
    _spinRate = spinRate;
    _power = power;
    _updateThrustOrientation();
  }

  void _updateThrustOrientation() {
    // The sprite SVG is visually designed as if 90 degrees rotated
    // from the +X axis.
    _thrust.directionByDegrees = node.rotationInDegrees + VISUAL_COORD_SYSTEM;
  }

  void reset() {
    _thrust.speed = 0.0;
    _momentum.speed = 0.0;
  }


}
