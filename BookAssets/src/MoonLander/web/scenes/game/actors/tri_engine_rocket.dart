part of moonlander;

class TriEngineRocket extends PhysicsActor with UTE.Tweenable {
  static const int HULL_ROTATE = 10;
  static const int TWEEN_TRANSLATE_Y = 20;

  Ranger.GroupNode _centroid;
  Ranger.SpriteImage _rocket;
  TriEngineGear _rightGear;
  TriEngineGear _leftGear;
  
  static const double VISUAL_COORD_SYSTEM = 90.0;

  // Degrees per frame rate.
  static const double PITCH_RATE = 1.5;
  static const double GEAR_EXTENDED_PITCH_RATE = 0.5;

  bool _pitchingLeft = false;
  bool _pitchingRight = false;
  bool _thrustOn = false;
  
  Vector2 v = new Vector2.zero();
  
  bool gearsRetracted = true;
  
  static const double MAX_FUEL = 200.0;
  static const double BURN_RATE = 0.05;
  double fuel = MAX_FUEL;
  
  Ranger.EmptyNode _exhaust1;
  Ranger.EmptyNode _exhaust2;
  Ranger.EmptyNode _exhaust3;
  
  Ranger.ParticleSystem _exhaustPS;
  int _engineIndex = 0;
  
  ZoomGroup _particleEmissionSpace;

  Ranger.MutableRectangle<double> accum = new Ranger.MutableRectangle<double>(0.0, 0.0, 0.0, 0.0);

  bool controlsEnabled = true;
  bool ignoreGravity = false;

  bool _paused = false;

  TriEngineRocket();

  bool init() {
    _centroid = new Ranger.GroupNode();
    _centroid.tag = 200001;
    
    _rocket = new Ranger.SpriteImage.basic(gm.resources.engineRocket3);
    _rocket.tag = 400001;
    //_rocket.visible = false;
       
    _rightGear = new TriEngineGear.basic();
    _rightGear..setRotation(180.0)
      ..rocket = this
      ..legRetractOrientation = 180.0
      ..legExtendOrientation = _rightGear.legRetractOrientation + 115.0
      ..toeRetractOrientation = 0.0
      ..toeExtendOrientation = 65.0
      ..setPosition(40.0, -50.0)
      ..node.uniformScale = 1.25;
    _centroid.addChild(_rightGear.node);

    _leftGear = new TriEngineGear.basic();
    _leftGear..legRetractOrientation = 0.0
      ..rocket = this
      ..legExtendOrientation = -115.0
      ..toeRetractOrientation = 0.0
      ..toeExtendOrientation = -65.0
      ..setRotation(0.0)
      ..setPosition(-40.0, -50.0)
      ..node.uniformScale = 1.25;
    _centroid.addChild(_leftGear.node);

    _centroid.addChild(_rocket);

    _thrust.maxMagnitude = PhysicsActor.THRUST_MAX;
    // Default direction with the vertical
    _thrust.directionByDegrees = VISUAL_COORD_SYSTEM;
    
    _momentum.maxMagnitude = 20.0;

    _exhaust1 = new Ranger.EmptyNode();
    _exhaust1.uniformScale = 250.0;
    _exhaust1.setPosition(-90.0, -80.0);
    _exhaust1.drawColor = Ranger.Color3IWhite.toString();
    //_exhaust1.iconVisible = true;
    _centroid.addChild(_exhaust1);
    
    _exhaust2 = new Ranger.EmptyNode();
    _exhaust2.uniformScale = 250.0;
    _exhaust2.setPosition(0.0, -100.0);
    _exhaust2.drawColor = Ranger.Color3IWhite.toString();
    //_exhaust2.iconVisible = true;
    _centroid.addChild(_exhaust2);
    
    _exhaust3 = new Ranger.EmptyNode();
    _exhaust3.uniformScale = 250.0;
    _exhaust3.setPosition(90.0, -80.0);
    _exhaust3.drawColor = Ranger.Color3IWhite.toString();
    //_exhaust3.iconVisible = true;
    _centroid.addChild(_exhaust3);
    
    return true;
  }
  
  Ranger.Node get node => _centroid;
  double get verticalVelocity => _momentum.speed * _momentum.direction.y;
  double get horizontalVelocity => _momentum.speed * _momentum.direction.x;
  TriEngineGear get landingGear => _leftGear;

  void reset() {
    node.rotationByDegrees = 0.0;
    // TODO deactivate particles.
  }

  set enableBBoxVisual(bool b) => _rocket.aabboxVisible = b;
  
  set particleEmissionSpace(ZoomGroup n) {
    _particleEmissionSpace = n;
    // At this point the Lander hasn't been added to the Scene Graph
    // yet. So the exhaust particles will automatically appear underneath
    // the Lander as intended.
    _constructExhaust();
  }
  
  void pitchLeft(bool on) {
    _pitchingLeft = on;
  }
  
  void pitchRight(bool on) {
    _pitchingRight = on;
  }
  
  void thrust(bool on) {
    _thrustOn = on;
  }

  void cutThrust() {
    _thrust.speed = 0.0;
    _momentum.speed = 0.0;
  }

  void pause(bool p) {
    _paused = p;
  }

  void alignUpright() {
    // Align lander vertically

    UTE.Tween rotateTo = new UTE.Tween.to(this, HULL_ROTATE, 1.0)
      ..targetValues = [0.0]
      ..easing = UTE.Expo.OUT;

    ranger.animations.add(rotateTo);
  }

  void restHull() {
    // Animate main hull to drop a bit as if resting.

    UTE.Tween dropBy = new UTE.Tween.to(this, TWEEN_TRANSLATE_Y, 2.0)
      ..targetRelative = [-10.0]
      ..easing = UTE.Bounce.OUT;

    ranger.animations.add(dropBy);
  }

  void liftHull() {
    _rocket.positionY = 0.0;
  }

  void explode() {
    _exhaustPS.explodeByStyle(Ranger.ParticleActivation.OMNI_DIRECTIONAL);
  }

  // -----------------------------------------------------------------
  // Tweenable interface
  // -----------------------------------------------------------------
  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case HULL_ROTATE:
        returnValues[0] = _centroid.rotationInDegrees;
        return 1;
      case TWEEN_TRANSLATE_Y:
        returnValues[0] = _rocket.position.y;
        return 1;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case HULL_ROTATE:
        _centroid.rotationByDegrees = newValues[0];
        break;
      case TWEEN_TRANSLATE_Y:
        _rocket.positionY = newValues[0];
        break;
    }
  }

  @override
  Ranger.MutableRectangle<double> calcAABBox() {
    // ----------------------------------------------------------------------------------
    // First get aabbox of main lander hull.
    // ----------------------------------------------------------------------------------
    Ranger.AffineTransform at = new Ranger.AffineTransform.withAffineTransformP(node.calcTransform());

    _rocket.getLocalBounds(); // Set node's rect data

    // Take this node's aabbox and transform it
    Ranger.RectApplyAffineTransformTo(_rocket.rect, rect, at);

    accum.setWith(rect);

    Ranger.AffineTransform cat = new Ranger.AffineTransform.IdentityP();

    // ----------------------------------------------------------------------------------
    // Get aabbox of left gear leg
    // ----------------------------------------------------------------------------------
    Ranger.MutableRectangle<double> lgRect = _leftGear.calcAABBox();
    Ranger.AffineTransform atlg = _leftGear.node.calcTransform();
    cat.multiply(atlg, at);
    Ranger.RectApplyAffineTransformTo(lgRect, rect, cat);
    
    accum.union(rect);
    
    // ----------------------------------------------------------------------------------
    // Get aabbox of right gear leg
    // ----------------------------------------------------------------------------------
    lgRect = _rightGear.calcAABBox();
    atlg = _rightGear.node.calcTransform();
    cat.multiply(atlg, at);
    Ranger.RectApplyAffineTransformTo(lgRect, rect, cat);

    accum.union(rect);

    // Return transforms to pool
    cat.moveToPool();
    at.moveToPool();

    gm.aabbox.bottom = accum.bottom;
    gm.aabbox.left = accum.left;
    gm.aabbox.width = accum.width;
    gm.aabbox.height = accum.height;

    return accum;
  }

  void update(double dt) {
    if (_paused)
      return;

    if (_pitchingLeft && !_pitchingRight && controlsEnabled) {
      if (gearsRetracted)
        node.rotationByDegrees = node.rotationInDegrees + PITCH_RATE;
      else
        node.rotationByDegrees = node.rotationInDegrees + GEAR_EXTENDED_PITCH_RATE;

      _updateThrustOrientation();
    }
    else if (!_pitchingLeft && _pitchingRight && controlsEnabled) {
      if (gearsRetracted)
        node.rotationByDegrees = node.rotationInDegrees - PITCH_RATE;
      else
        node.rotationByDegrees = node.rotationInDegrees - GEAR_EXTENDED_PITCH_RATE;
      _updateThrustOrientation();
    }
    
    if (_thrustOn && controlsEnabled) {
      _thrust.speed = PhysicsActor.THRUST_POWER / PhysicsActor.MASS;
      fuel -= BURN_RATE;
      fuel = fuel.clamp(0.0, MAX_FUEL);
      _exhaustPS.activateByStyle(Ranger.ParticleActivation.VARIANCE_DIRECTIONAL);
    }

    // The exhaust port is an empty place holder used to track a location.
    // In this case we use it to track the position at the end of the ship.
    // Convert the exhaust port's local-space to world-space.
    // Then convert it into GameLayer-space because the exhaust particle
    // system is in that space.
    _engineIndex = (_engineIndex + 1) % 3;
    Vector2 port = _exhaust1.position;
    if (_engineIndex == 1)
      port = _exhaust2.position;
    else if (_engineIndex == 2)
      port = _exhaust3.position;
    
    Vector2 gs = _convertToEmissionSpace(port);
    _exhaustPS.setPosition(gs.x, gs.y);

    // Apply Thrust and Gravity
    _momentum.add(_thrust);

    if (!ignoreGravity)
      _momentum.add(gm.gravity);

    v.setFrom(node.position);
    _momentum.applyTo(v);
    node.position = v;

    // If there is no thrust being applied then the thrust slowly dies off.
    if (_thrust.speed > 0.0) {
      _thrust.decreaseSpeed(PhysicsActor.THRUST_DAMPING / PhysicsActor.MASS);
      fuel -= BURN_RATE / 10.0;
    }
    
    _exhaustPS.update(dt);
    
    calcAABBox();
  }
  
  void _updateThrustOrientation() {
    // The sprite SVG is visually designed as if 90 degrees rotated
    // from the +X axis.
    _thrust.directionByDegrees = node.rotationInDegrees + VISUAL_COORD_SYSTEM;
    if (_exhaustPS != null)
      // Why is the exhaust particles' direction opposite that of the thrust?
      // Because the thrust is a vector in the direction of the ship (aka additive).
      _exhaustPS.particleActivation.angleDirection = _thrust.asAngleInDegrees + 180.0;
  }
  
  Vector2 _convertToEmissionSpace(Vector2 location) {
    Ranger.Vector2P ws = _centroid.convertToWorldSpace(location);
    Ranger.Vector2P ns = _particleEmissionSpace.convertWorldToNodeSpace(ws.v);

    // Clean up.
    ns.moveToPool();
    ws.moveToPool();
    
    return ns.v;
  }

  void toggleGears() {
    if (gearsRetracted) {
      extendGears();
    }
    else {
      retractGears();
    }
  }

  void extendGears() {
    _leftGear.extend();
    _rightGear.extend();
    // The gear will set the retract flag.
  }

  void retractGears() {
    _leftGear.retract();
    _rightGear.retract();
    gearsRetracted = true;
  }

  void _constructExhaust() {
    _exhaustPS = new Ranger.BasicParticleSystem.initWith(30);
    
    ParticleActivator pa = _constructActivator();
    pa.angleDirection = _thrust.asAngleInDegrees + 180.0;
    
    _exhaustPS.particleActivation = pa;

    // Construct Exhaust Particles
    _populateParticleSystem(_exhaustPS);
    _exhaustPS.active = true;
  }

  ParticleActivator _constructActivator() {
    ParticleActivator pa = new ParticleActivator();
    pa.lifetime.min = 0.2;
    pa.lifetime.max = 0.5;
    pa.lifetime.variance = 0.2;
    
    pa.activationData.velocity.setSpeedRange(2.0, 3.0);
    pa.activationData.velocity.limitMagnitude = false;
    pa.speed.min = pa.activationData.velocity.minMagnitude;
    pa.speed.max = pa.activationData.velocity.maxMagnitude;
    pa.speed.variance = 1.0;

    pa.startScale.min = 8.5;
    pa.startScale.max = 10.5;
    pa.startScale.variance = 1.5;
    
    pa.endScale.min = 3.0;
    pa.endScale.max = 4.5;
    pa.endScale.variance = 0.5;
    
    pa.angleVariance = 45.0;
    
    pa.startColor.setWith(Ranger.Color4IWhite);
    pa.endColor.setWith(Ranger.Color4IBlack);
    return pa;
  }
  
  void _populateParticleSystem(Ranger.ParticleSystem ps) {
    // To populate a particle system we need prototypes to clone from.
    // Once the particle system has been built we can dispense with the
    // prototypes.
    
    // First we create a "prototype" visual which will be assigned to a
    // prototype particle.
    CircleParticleNode protoVisual = new CircleParticleNode.initWith(Ranger.Color4IBlack);
    
    // Next we create an actual particle and assign to it the prototype visual.
    // Together the particle system will clone this prototype particle along with its
    // visual (N) times.
    // Default values of 1.0 given because these values will determined when
    // the particle is launched. They are just place holder values for the
    // prototype.
    CircleParticle prototype = new CircleParticle.withNode(protoVisual);
    
    // Now we populate the particle system with "clones" of the prototype.
    // The particles will be emitted onto the main GameLayer.
    // If we had supplied "this" then the particles are emitted as children
    // of the ship and that would visually look incorrect, plus they
    // would inherit transform properties of the ship that we don't want.
    ps.addByPrototype(_particleEmissionSpace, prototype);
    
    // The prototypes are no longer relevant as they have been cloned. So
    // we move it back to the pool. The other option is to NOT put them back
    // and free up resources.
    //protoVisual.moveToPool();
    //prototype.moveToPool();
  }

}
