part of moonlander;

class HudRimbaloidLayer extends Ranger.BackgroundLayer {
  Ranger.SpriteImage _pause;
  FuelGauge _fuel;

  YesNoChoicePopupDialog verifyQuitDialog;

  HudRimbaloidLayer();
 
  factory HudRimbaloidLayer.withColor([Ranger.Color4<int> backgroundColor = null, bool centered = true, int width, int height]) {
    HudRimbaloidLayer layer = new HudRimbaloidLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = true
      ..color = backgroundColor
      ..name = "HudRimbaloidLayer";
    return layer;
  }

  @override
  bool init([int width, int height]) {
    if (super.init(width, height)) {

      _configure();
    }
    
    return true;
  }

  @override
  void onEnter() {
    enableMouse = true;
    enableKeyboard = true;
    super.onEnter();

    scheduleUpdate();
  }

  @override
  void onExit() {
    disableInputs();
    
    ranger.animations.flushAll();
    unScheduleUpdate();

    super.onExit();
  }

  @override
  void onEnterTransitionDidFinish() {
    super.onEnterTransitionDidFinish();
    
  }

  @override
  bool onMouseDown(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_pause, event.offset.x, event.offset.y);
    if (_pause.pointInside(nodeP.v)) {
      nodeP.moveToPool();
      // Show verify popup
      verifyQuitDialog.show();

      return true;
    }
    nodeP.moveToPool();

    return false;
  }

  @override
  void update(double dt) {
    gm.triEngineRocket.update(dt);
    _fuel.value = gm.triEngineRocket.fuel;
    
    gm.verticalVelocity.value = gm.triEngineRocket.verticalVelocity;
    gm.horizontalVelocity.value = gm.triEngineRocket.horizontalVelocity;
  }
  
  @override
  bool onKeyDown(KeyboardEvent event) {
    switch (event.keyCode) {
      case 69:
        // "E" extend/retract gears
        gm.triEngineRocket.toggleGears();
        return true;
      case 65:
        // "A" key. Pitch CCW
        gm.triEngineRocket.pitchLeft(true);
        return true;
      case 83:
        // "S" key. Pitch CW
        gm.triEngineRocket.pitchRight(true);
        return true;
      case 191:
        // "/" key. Thrust
        gm.triEngineRocket.thrust(true);
        return true;
    }
    
    return false;
  }

  @override
  bool onKeyUp(KeyboardEvent event) {
    switch (event.keyCode) {
      case 65:
        // "A" key. Pitch CCW
        gm.triEngineRocket.pitchLeft(false);
        return true;
      case 83:
        // "S" key. Pitch CW
        gm.triEngineRocket.pitchRight(false);
        return true;
      case 191:
        // "/" key. Thrust
        gm.triEngineRocket.thrust(false);
        return true;
    }
    
    return false;
  }

  void _configure() {
    double h = contentSize.height / 2.0;
    double w = contentSize.width / 2.0;
    
    _pause = new Ranger.SpriteImage.withElement(gm.resources.pause)
      ..name = "Pause"
      ..uniformScale = 0.25
      ..setPosition(w - (w * 0.1), h - (h * 0.15));
    addChild(_pause);
    
    _fuel = new FuelGauge.basic()
      ..node.name = "Fuel"
      ..node.setPosition(-w + (w * 0.15), h - (h * 0.1))
      ..max = TriEngineRocket.MAX_FUEL
      ..value = TriEngineRocket.MAX_FUEL;
    addChild(_fuel.node);
    
    Ranger.GroupNode velocityGrp = new Ranger.GroupNode();
    velocityGrp.positionX = 10.0;

    gm.verticalVelocity = new VelocityGauge.basic();
    gm.verticalVelocity
      ..label = ""
      ..node.name = "VVelocity"
      ..node.setPosition(-w + (w * 0.20), h - (h * 0.4))
      ..node.rotationByDegrees = 90.0
      ..max = 10.0
      ..value = 0.0;
    velocityGrp.addChild(gm.verticalVelocity.node);
    
    gm.horizontalVelocity = new VelocityGauge.basic();
    gm.horizontalVelocity
      ..node.name = "HVelocity"
      ..TextLabel.setPosition(-170.0, 35.0)
      ..node.setPosition(-w + (w * 0.20), h - (h * 0.4))
      ..max = 10.0
      ..value = 0.0;
    velocityGrp.addChild(gm.horizontalVelocity.node);
    addChild(velocityGrp);

    double height = 200.0;
    double width = 1100.0;
    gm.slideOutDialog = new SlideOutDialog()
      ..init()
      ..listenToBus("StatusSlideOut")
      ..text = "Successful Landing!"
      ..textColor = Ranger.Color4IWhite
      ..textSize = 10.0
      ..setTextPosition(50.0, 75.0)
      ..setPosition(-width/2.0, h + 5.0)
      ..slideDelta = (height + (height / 1.1))
      ..width = width
      ..height = height;
    addChild(gm.slideOutDialog);

    height = 125.0;
    width = 150.0;
    gm.landingsSlideOutDialog = new SlideOutDialog()
      ..init()
      ..listenToBus("LandingSlideOut")
      ..text = "0"
      ..textColor = Ranger.Color4IGreenYellow
      ..textSize = 10.0
      ..slideOutTime = 1.0
      ..setTextPosition(40.0, 30.0)
      ..setPosition(350.0, h + 5.0)
      ..slideDelta = (height)
      ..width = width
      ..height = height;
    addChild(gm.landingsSlideOutDialog);


    gm.playAgainDialog = new YesNoChoicePopupDialog()
      ..init(1000, 500)
      ..setMessage("Play Again?", 1, 12.0, -300.0, 0.0, Ranger.Color4IWhite)
      ..data = "PlayAgain"
      ..setAcceptTextPosition(100.0, 30.0)
      ..setCancelTextPosition(120.0, 30.0)
      ..buttonCaptionSize = 6.0
      ..acceptCaption = "Yes"
      ..cancelCaption = "No";
    addChild(gm.playAgainDialog);

    verifyQuitDialog = new YesNoChoicePopupDialog()
      ..init(1000, 500)
      ..setMessage("Are you sure what to quit now?", 1, 6.0, -400.0, 120.0, Ranger.Color4IWhite)
      ..setMessage("You will lose your current", 2, 6.0, -400.0, 50.0, Ranger.Color4IWhite)
      ..setMessage("awesome landing record.", 3, 6.0, -400.0, -20.0, Ranger.Color4IWhite)
      ..data = "VerifyQuit"
      ..setAcceptTextPosition(100.0, 30.0)
      ..setCancelTextPosition(120.0, 30.0)
      ..buttonCaptionSize = 6.0
      ..acceptCaption = "Yes"
      ..cancelCaption = "No";
    addChild(verifyQuitDialog);

  }
}
