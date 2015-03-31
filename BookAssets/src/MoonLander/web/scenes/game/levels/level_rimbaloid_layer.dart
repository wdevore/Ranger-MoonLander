part of moonlander;

class LevelRimbaloidLayer extends Ranger.BackgroundLayer {
  RectangleNode _plane;
  RectangleNode _pad;

  ZoomGroup _zoomGroup;

  DualRangeZone _zone;

  final double widePerspective = 0.5;
  final double narrowPerspective = 1.6;
  final double tiltTolerance = 5.0;

  Ranger.ParticleSystem _explosionPS;

  static const int MAX_LANDINGS = 1000;

  int successfulLandings = 0;
  static const int GAME_STATE_RESET = 0;
  static const int GAME_STATE_INTRO = 3;
  static const int GAME_STATE_NEW_LANDING = 5;
  static const int GAME_STATE_LANDING = 10;
  // Show floating text and number
  static const int GAME_STATE_LANDED = 20;
  static const int GAME_STATE_CRASHED = 30;
  static const int GAME_STATE_WIN = 40;
  static const int GAME_STATE_FAIL = 50;
  static const int GAME_STATE_INITIALS = 60;
  static const int GAME_STATE_PLAYAGAIN = 70;
  static const int GAME_STATE_END = 80;
  static const int GAME_STATE_PAUSE = 90;

  int gameState = GAME_STATE_RESET;
  int prevGameState = GAME_STATE_RESET;

  double _timer = 2.5;
  double _timerCount = 0.0;
  bool _timerElapsed = false;

  FadingTextNode _countTextNode;

  StreamSubscription<MessageData> _busStream;

  bool _quiting = false;

  Math.Random _randGen = new Math.Random();

  LevelRimbaloidLayer();

  factory LevelRimbaloidLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    LevelRimbaloidLayer layer = new LevelRimbaloidLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = false
      ..color = backgroundColor
      ..tag = 100009;
    return layer;
  }

  @override
  bool init([int width, int height]) {
    if (super.init(width, height)) {

      _listenToBus();
      _configure();
    }

    return true;
  }

  @override
  void onEnter() {
    super.onEnter();

    scheduleUpdate();

  }

  @override
  void onExit() {
    ranger.animations.flushAll();

    unScheduleUpdate();

    if (_busStream != null)
      _busStream.cancel();

    super.onExit();
  }

  @override
  void enable(bool enable) {
    super.enable(enable);
  }

  @override
  void update(double dt) {
    switch (gameState) {
      case GAME_STATE_RESET:
        _resetState();
        break;
      case GAME_STATE_INTRO:
        _updateIntroState(dt);
        break;
      case GAME_STATE_NEW_LANDING:
        _updateNewLandingState(dt);
        break;
      case GAME_STATE_LANDING:
        _updateLandingState(dt);
        break;
      case GAME_STATE_LANDED:
        _updateLandedState(dt);
        break;
      case GAME_STATE_CRASHED:
        _updateCrashedState(dt);
        break;
      case GAME_STATE_FAIL:
        _updateFailState(dt);
        break;
      case GAME_STATE_INITIALS:
        _updateInitialsState(dt);
        break;
      case GAME_STATE_WIN:
        _updateWinState(dt);
        break;
      case GAME_STATE_PLAYAGAIN:
        _updatePlayAgainState(dt);
        break;
      case GAME_STATE_PAUSE:
        _updatePauseState(dt);
        break;
    }
  }

  void _listenToBus() {
    _busStream = ranger.eventBus.on(MessageData).listen(
      (MessageData md) {
        if (md.handled)
          return;

        switch (md.whatData) {
          case MessageData.DIALOG:
            if (md.actionData == MessageData.HIDE) {
              if (md.data == "PlayAgain") {
                if (md.choice == MessageData.YES) {
                  _changeGameState(GAME_STATE_RESET);
                }
                else {
                  // Return to the level selection scene
                  ranger.sceneManager.popScene();
                }
                md.handled = true;
              }
              else if (md.data == "InitialsEntered") {
                // Did they decide to quit during? If yes then pop scene
                if (_quiting) {
                  // Return to the level selection scene
                  ranger.sceneManager.popScene();
                }
                else {
                  _changeGameState(GAME_STATE_PLAYAGAIN);
                  // Update scores
                  String initials = gm.initialsDialog.value;

                  gm.updateScores(successfulLandings, initials);

                  gm.playAgainDialog.show();
                }
              }
              else if (md.data == "VerifyQuit") {
                if (md.choice == MessageData.YES) {
                  _quiting = true;
                  // Check rank first.
                  if (gm.placed(successfulLandings)) {
                    _changeGameState(GAME_STATE_INITIALS);
                    gm.initialsDialog.show();
                  }
                  else {
                    _changeGameState(GAME_STATE_END);
                    // Return to the level selection scene
                    ranger.sceneManager.popScene();
                  }
                }
                else {
                  // No
                  gameState = prevGameState;
                }
                _pause(false);
              }
              enable(true);
            }
            else if (md.actionData == MessageData.SHOW) {
              if (md.data == "VerifyQuit") {
                _changeGameState(GAME_STATE_PAUSE);
                _pause(true);
              }
            }
          break;
        }
      });
  }

  void _updateExplosion(double dt) {
    gm..triEngineRocket_hull.update(dt)
      ..triEngineRocket_centercell.update(dt)
      ..triEngineRocket_leftcell.update(dt)
      ..triEngineRocket_rightcell.update(dt)
      ..leg.update(dt)
      ..toe.update(dt)
      ..leg2.update(dt)
      ..toe2.update(dt);
    _explosionPS.update(dt);
  }

  void _changeGameState(int state) {
    prevGameState = gameState;
    gameState = state;
  }

  void _resetState() {
    _timer = 3.0;
    _timerCount = 0.0;
    _timerElapsed = false;

    successfulLandings = 0;

    gm.triEngineRocket
      ..controlsEnabled = false
      ..node.visible = false
      ..cutThrust()
      ..ignoreGravity = true;

    _hideParts();

    gm..triEngineRocket.reset()
      ..triEngineRocket_hull.reset()
      ..triEngineRocket_centercell.reset()
      ..triEngineRocket_leftcell.reset()
      ..triEngineRocket_rightcell.reset()
      ..leg.reset()
      ..toe.reset()
      ..leg2.reset()
      ..toe2.reset()
      ..landingsSlideOutDialog.text = "0";

    _changeGameState(GAME_STATE_INTRO);

    double h = contentSize.height / 2.0;
    double height = 200.0;
    double width = 1150.0;
    gm.slideOutDialog
      ..text = "Land as many times as you can before crashing."
      ..textColor = Ranger.Color4IWhite
      ..textSize = 4.5
      ..setTextPosition(30.0, 75.0)
      ..setPosition(-width/2.0, h + 5.0)
      ..slideDelta = (height + (height / 1.1))
      ..width = width
      ..height = height;

    MessageData md = new MessageData()
      ..actionData = MessageData.SHOW
      ..whatData = MessageData.DIALOG
      ..data = "StatusSlideOut"
      ..choice = SlideOutDialog.FROM_TOP;
    ranger.eventBus.fire(md);
  }

  void _updateIntroState(double dt) {
    _timerCount += dt;

    if (_timerCount > _timer) {
      _timer = 2.5;
      _timerCount = 0.0;
      _timerElapsed = false;
      _changeGameState(GAME_STATE_NEW_LANDING);

      MessageData md = new MessageData()
        ..actionData = MessageData.HIDE
        ..whatData = MessageData.DIALOG
        ..data = "StatusSlideOut"
        ..choice = SlideOutDialog.FROM_TOP;
      ranger.eventBus.fire(md);

      md = new MessageData()
        ..actionData = MessageData.SHOW
        ..whatData = MessageData.DIALOG
        ..data = "LandingSlideOut"
        ..choice = SlideOutDialog.FROM_TOP;
      ranger.eventBus.fire(md);
    }
  }

  void _updateNewLandingState(double dt) {
    _setForNewLanding();
    _changeGameState(GAME_STATE_LANDING);

    _timerCount = 0.0;
    _timer = 4.0;
    _timerElapsed = false;

    gm.triEngineRocket
      ..controlsEnabled = true
      ..node.visible = true
      ..pause(false)
      ..ignoreGravity = false;

    _explodeRing();
  }

  void _updateLandedState(double dt) {
    _timerCount += dt;

    if (_timerCount > _timer) {
      MessageData md = new MessageData()
        ..actionData = MessageData.HIDE
        ..whatData = MessageData.DIALOG
        ..data = "StatusSlideOut"
        ..choice = SlideOutDialog.FROM_TOP;
      ranger.eventBus.fire(md);

      // If they have reached Max landings then we show Win popup and ask for their initials
      if (successfulLandings == MAX_LANDINGS) {
        if (gm.placed(successfulLandings)) {
          _changeGameState(GAME_STATE_INITIALS);
          gm.initialsDialog.show();
        }
        else {
          _changeGameState(GAME_STATE_PLAYAGAIN);
          // Pop up a Play Again dialog
          gm.playAgainDialog.show();
        }
      }
      else {
        _changeGameState(GAME_STATE_NEW_LANDING);

        MessageData md = new MessageData()
          ..actionData = MessageData.SHOW
          ..whatData = MessageData.DIALOG
          ..data = "LandingSlideOut"
          ..choice = SlideOutDialog.FROM_TOP;
        ranger.eventBus.fire(md);
      }
    }
  }

  void _updateCrashedState(double dt) {
    _timerCount += dt;

    _updateExplosion(dt);

    if (_timerCount > _timer) {

      MessageData md = new MessageData()
        ..actionData = MessageData.HIDE
        ..whatData = MessageData.DIALOG
        ..data = "StatusSlideOut"
        ..choice = SlideOutDialog.FROM_TOP;
      ranger.eventBus.fire(md);

      _changeGameState(GAME_STATE_FAIL);

      enable(false);
    }
  }

  void _updateFailState(double dt) {
    // This state is maintained until the user selects Yes or No from
    // the Play Again popup.
    _updateExplosion(dt);

    // If they landed at least once and bested a previous score then issue
    // a Initials popup. Else issue Play Again dialog.
    if (gm.placed(successfulLandings)) {
      _changeGameState(GAME_STATE_INITIALS);

      gm.initialsDialog.show();
    }
    else {
      _changeGameState(GAME_STATE_PLAYAGAIN);

      // Pop up a Play Again dialog
      gm.playAgainDialog.show();
    }

  }

  void _updateInitialsState(double dt) {
    _updateExplosion(dt);
  }

  void _updateWinState(double dt) {
  }

  void _updatePlayAgainState(double dt) {
    _updateExplosion(dt);
  }

  void _updateLandingState(double dt) {
    _timerCount += dt;

    _zone.updateState(gm.triEngineRocket.node.position);

    Ranger.MutableRectangle<double> padBox = calcAABBox();
    Ranger.MutableRectangle<double> landerBox = gm.triEngineRocket.calcAABBox();

    if (padBox.intersects(landerBox)) {

      bool successful = ruleCheckPadAligned(landerBox, padBox);

      if (!successful) {
        _landingFailed();
        return;
      }

      successful = ruleCheckVerticalAligned();
      if (!successful) {
        _landingFailed();
        return;
      }

      int ruleRes = ruleCheckVelocities();
      if (ruleRes < 0) {
        _landingFailed();
        return;
      }

      if (gm.triEngineRocket.gearsRetracted) {
        _landingFailed();
        return;
      }

      _landingSuccessful();

      return;
    }

    if (_timerCount > _timer && !_timerElapsed) {
      _timerElapsed = true;

      MessageData md = new MessageData()
        ..actionData = MessageData.HIDE
        ..whatData = MessageData.DIALOG
        ..data = "LandingSlideOut"
        ..choice = SlideOutDialog.FROM_TOP;
      ranger.eventBus.fire(md);

    }

    //gm.aabbox.outlineColor = Ranger.Color4IWhite.toString();
  }

  void _updatePauseState(double dt) {
    _updateExplosion(dt);
  }

  void _landingSuccessful() {
    //gm.aabbox.outlineColor = Ranger.Color4IBlue.toString();

    successfulLandings++;
    gm.landingsSlideOutDialog.text = "$successfulLandings";

    // Auto land
    gm.triEngineRocket
      ..controlsEnabled = false
      ..cutThrust()
      ..ignoreGravity = true
      ..restHull()
      ..alignUpright();

    _changeGameState(GAME_STATE_LANDED);

    // Animate Text for both count and success label.
    _countTextNode
      ..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y)
      ..text = "+$successfulLandings"
      ..visible = true
      ..opacity = 255;

    UTE.Tween fadeIn = new UTE.Tween.to(_countTextNode, FadingTextNode.TWEEN_FADE, 3.0)
      ..targetValues = [0]
      ..easing = UTE.Cubic.OUT;
    ranger.animations.add(fadeIn);

    UTE.Tween floatUp = new UTE.Tween.to(_countTextNode, FadingTextNode.TWEEN_TRANSLATE_Y, 3.73)
      ..targetRelative = [100.0]
      ..easing = UTE.Expo.OUT;
    ranger.animations.add(floatUp);

    gm.slideOutDialog
      ..text = "Successful Landing!"
      ..setTextPosition(50.0, 75.0)
      ..textSize = 10.0
      ..textColor = Ranger.Color4IWhite;

    _timerCount = 0.0;
    _timer = 2.5;
    _timerElapsed = false;
    MessageData md = new MessageData()
      ..actionData = MessageData.SHOW
      ..whatData = MessageData.DIALOG
      ..data = "StatusSlideOut"
      ..choice = SlideOutDialog.FROM_TOP;
    ranger.eventBus.fire(md);

  }

  void _setForNewLanding() {
    // Show lander
    gm.triEngineRocket.node.visible = true;

    // Generate new position.
    //double h = contentSize.height;
    double w = contentSize.width;
    w = w - w * 0.1;
    double x = _randGen.nextDouble() * w - w/4;

    gm.triEngineRocket.node.setPosition(x, 480.0);
    gm.triEngineRocket.retractGears();

    // Reenable controls
    gm.triEngineRocket..controlsEnabled = true
      ..ignoreGravity = false;

    _zoomOut(widePerspective, 0.25);

    // Raise hull back to lifted state.
    gm.triEngineRocket.liftHull();
  }

  void _landingFailed() {
    // Failed to land. Start explode animation.
    //gm.aabbox.outlineColor = Ranger.Color4IRed.toString();

    gm.triEngineRocket..controlsEnabled = false
      ..cutThrust()
      ..ignoreGravity = true;

    _triggerDisc();

    ranger.animations.stopAndUntrack(_zoomGroup, ZoomGroup.TWEEN_SCALE);
    _zoomOut(1.0, 1.0);

    _explodeLander();

    _changeGameState(GAME_STATE_CRASHED);

    _timer = 2.5;
    _timerCount = 0.0;
    _timerElapsed = false;

    gm.slideOutDialog..text = "Failed Landing!"
      ..setTextPosition(160.0, 65.0)
      ..textSize = 10.0
      ..textColor = Ranger.Color4IYellowGreen;

    MessageData md = new MessageData()
      ..actionData = MessageData.SHOW
      ..whatData = MessageData.DIALOG
      ..data = "StatusSlideOut"
      ..choice = SlideOutDialog.FROM_TOP;
    ranger.eventBus.fire(md);

  }

  void _hideParts() {
    gm.triEngineRocket_hull.node.visible = false;
    gm.triEngineRocket_centercell.node.visible = false;
    gm.triEngineRocket_leftcell.node.visible = false;
    gm.triEngineRocket_rightcell.node.visible = false;
    gm.leg.node.visible = false;
    gm.toe.node.visible = false;
    gm.leg2.node.visible = false;
    gm.toe2.node.visible = false;
  }

  void _explodeLander() {
    gm.triEngineRocket.node.visible = false;
    gm.triEngineRocket.explode();

    _explosionPS..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y)
      ..explodeByStyle(Ranger.ParticleActivation.OMNI_DIRECTIONAL);

    Math.Random _randGen = new Math.Random();

    double dir = _randGen.nextDouble() * 40.0 - 20.0;
    // -2 -- 0 -- 2
    double spinRate = _randGen.nextDouble() * 4.0 - 2.0;
    gm.triEngineRocket_hull.applyImpulse(dir, 0.1, spinRate, 3.0);
    gm.triEngineRocket_hull.node..visible = true
      ..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y);

    dir = _randGen.nextDouble() * 40.0 - 20.0;
    spinRate = _randGen.nextDouble() * 10.0 - 5.0;
    gm.triEngineRocket_centercell.applyImpulse(dir, 0.3, spinRate, 3.0);
    gm.triEngineRocket_centercell.node..visible = true
      ..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y);

    dir = _randGen.nextDouble() * 40.0 - 20.0;
    double power = 1.0 + _randGen.nextDouble() * 2.0;
    spinRate = _randGen.nextDouble() * 9.0 - 4.5;
    gm.triEngineRocket_leftcell.applyImpulse(dir, 0.2, spinRate, power);
    gm.triEngineRocket_leftcell.node..visible = true
      ..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y);

    dir = _randGen.nextDouble() * 40.0 - 20.0;
    power = 1.0 + _randGen.nextDouble() * 2.0;
    spinRate = 2.0 + _randGen.nextDouble() * 8.0 - 4.0;
    gm.triEngineRocket_rightcell.applyImpulse(dir, 0.15, spinRate, power);
    gm.triEngineRocket_rightcell.node..visible = true
      ..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y);

    dir = _randGen.nextDouble() * 40.0 - 20.0;
    power = 2.0 + _randGen.nextDouble() * 3.0;
    spinRate = 2.0 + _randGen.nextDouble() * 8.0 - 4.0;
    gm.leg..applyImpulse(dir, 0.15, spinRate, power);
    gm.leg.node..visible = true
      ..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y);

    dir = _randGen.nextDouble() * 50.0 - 25.0;
    power = 2.0 + _randGen.nextDouble() * 3.0;
    spinRate = 2.0 + _randGen.nextDouble() * 8.0 - 4.0;
    gm.toe..applyImpulse(dir, 0.15, spinRate, power);
    gm.toe.node..visible = true
      ..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y);

    dir = _randGen.nextDouble() * 40.0 - 20.0;
    power = 2.0 + _randGen.nextDouble() * 3.0;
    spinRate = 2.0 + _randGen.nextDouble() * 10.0 - 5.0;
    gm.leg2..applyImpulse(dir, 0.15, spinRate, power);
    gm.leg2.node..visible = true
      ..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y);

    dir = _randGen.nextDouble() * 50.0 - 25.0;
    power = 2.0 + _randGen.nextDouble() * 3.0;
    spinRate = 2.0 + _randGen.nextDouble() * 10.0 - 5.0;
    gm.toe2..applyImpulse(dir, 0.15, spinRate, power);
    gm.toe2.node..visible = true
      ..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y);
  }

  void _explodeRing() {
    gm.explodingRing..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y)
      ..visible = true
      ..uniformScale = 0.1;

    UTE.Timeline par = new UTE.Timeline.parallel();

    // Expand ring
    UTE.Tween scaleUp = new UTE.Tween.to(gm.explodingRing, AnimatableCircleNode.SCALE, 1.0)
      ..targetRelative = [300.0]
      ..easing = UTE.Expo.OUT;
    ranger.animations.add(scaleUp, false);
    par.push(scaleUp);

    // Fade out ring
    gm.explodingRing.outlineColor = Ranger.Color4IWhite;
    UTE.Tween fadeOut = new UTE.Tween.to(gm.explodingRing, AnimatableCircleNode.ALPHA_OUTLINE, 1.5)
      ..targetValues = [0]
      ..easing = UTE.Sine.OUT;
    ranger.animations.add(fadeOut, false);
    par.push(fadeOut);

    ranger.animations.add(par);
  }

  void _triggerDisc() {
    gm.fadingDisc..setPosition(gm.triEngineRocket.node.position.x, gm.triEngineRocket.node.position.y)
      ..visible = true
      ..fillColor.a = 8;

    UTE.Timeline seq = new UTE.Timeline.sequence();
    UTE.Tween discFadeIn = new UTE.Tween.to(gm.fadingDisc, AnimatableCircleNode.ALPHA_FILL, 0.1)
      ..callback = _discFadeOutComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE
      ..targetValues = [255]
      ..easing = UTE.Cubic.IN;

    UTE.Tween discFadeOut = new UTE.Tween.to(gm.fadingDisc, AnimatableCircleNode.ALPHA_FILL, 0.75)
      ..targetValues = [0]
      ..easing = UTE.Expo.OUT;
    seq.push(discFadeIn);
    seq.push(discFadeOut);

    ranger.animations.add(seq);
  }

  void _discFadeOutComplete(int type, UTE.BaseTween source) {
    if (type == UTE.TweenCallback.COMPLETE) {
      _explodeRing();
    }
  }

  void _pause(bool p) {
    if (p) {
      gm.triEngineRocket
        ..pause(true);
    }
    else {
      gm.triEngineRocket
        ..pause(false);
    }
  }

  int ruleCheckVelocities() {
    int rulePassed = 0;

    final double vValue = gm.verticalVelocity.getValue(gm.triEngineRocket.verticalVelocity);
    final double hValue = gm.horizontalVelocity.getValue(gm.triEngineRocket.horizontalVelocity);

    if (vValue > 0.1 || hValue > 0.1) {
      rulePassed = -1; // Failed
    }
    else if (vValue > 0.05 || hValue > 0.05) {
      //gm.aabbox.outlineColor = Ranger.Color4IYellow.toString();
      rulePassed = 1; // Warning. Less points
    }
    else {
      //gm.aabbox.outlineColor = Ranger.Color4IPurple.toString();
    }

    return rulePassed;
  }

  bool ruleCheckPadAligned(Ranger.MutableRectangle<double> landerBox, Ranger.MutableRectangle<double> padBox) {
    bool rulePassed = true;

    // Check left/right edges.
    if (landerBox.left > padBox.left && landerBox.right < padBox.right) {
      //gm.aabbox.outlineColor = Ranger.Color4IBlue.toString();
    }
    else {
      rulePassed = false; // Failed
    }

    return rulePassed;
  }

  bool ruleCheckVerticalAligned() {
    bool rulePassed = true;

    if (gm.triEngineRocket.node.rotationInDegrees.abs() < tiltTolerance) {
      //gm.aabbox.outlineColor = Ranger.Color4IGreen.toString();
    }
    else {
      rulePassed = false; // Failed
    }

    return rulePassed;
  }

  Ranger.MutableRectangle<double> calcAABBox() {
    Ranger.AffineTransform at = new Ranger.AffineTransform.withAffineTransformP(_pad.calcTransform());

    _pad.localBounds; // Cause [rect] to be calculated

    Ranger.RectApplyAffineTransformTo(_pad.rect, rect, at);

    // <editor-fold desc="DEBUG">
    gm.aabbox2.bottom = rect.bottom;
    gm.aabbox2.left = rect.left;
    gm.aabbox2.width = rect.width;
    gm.aabbox2.height = rect.height;
    // </editor-fold>

    return rect;
  }

  void _configure() {
    _zoomGroup = new ZoomGroup.basic();
    //_zoomGroup.zoomIconVisible = false;
    //_zoomGroup.iconScale = 50.0;
    addChild(_zoomGroup);

    // <editor-fold desc="DEBUG">
    //_zoomGroup.addChild(gm.aabbox);
    //_zoomGroup.addChild(gm.aabbox2);
    // </editor-fold>

    gm.triEngineRocket = new TriEngineRocket();
    gm.triEngineRocket.init();

    gm.triEngineRocket..enableBBoxVisual = false
      ..particleEmissionSpace = _zoomGroup;
    
    gm.triEngineRocket.node.uniformScale = 0.5;

    _zoomGroup.addChild(gm.triEngineRocket.node);

    _constructPSExplosion();

    // ----------------------------------------------------------
    // The lander's alter ego.
    // ----------------------------------------------------------
    gm.leg.constructPart(gm.triEngineRocket.landingGear.leg.scaleX, gm.triEngineRocket.landingGear.leg.scaleY, Ranger.Color4IGoldYellow);
    gm.leg.node.visible = false;
    _zoomGroup.addChild(gm.leg.node);
    gm.toe.constructPart(gm.triEngineRocket.landingGear.toe.scaleX, gm.triEngineRocket.landingGear.toe.scaleY, Ranger.Color4IGreyBlue);
    gm.toe.node.visible = false;
    _zoomGroup.addChild(gm.toe.node);

    gm.leg2.constructPart(gm.triEngineRocket.landingGear.leg.scaleX, gm.triEngineRocket.landingGear.leg.scaleY, Ranger.Color4IGoldYellow);
    gm.leg2.node.visible = false;
    _zoomGroup.addChild(gm.leg2.node);
    gm.toe2.constructPart(gm.triEngineRocket.landingGear.toe.scaleX, gm.triEngineRocket.landingGear.toe.scaleY, Ranger.Color4IGreyBlue);
    gm.toe2.node.visible = false;
    _zoomGroup.addChild(gm.toe2.node);

    gm.triEngineRocket_hull.node..visible = false
      ..uniformScale = gm.triEngineRocket.node.uniformScale;
    gm.triEngineRocket_centercell.node..visible = false
      ..uniformScale = gm.triEngineRocket.node.uniformScale;
    gm.triEngineRocket_leftcell.node..visible = false
      ..uniformScale = gm.triEngineRocket.node.uniformScale;
    gm.triEngineRocket_rightcell.node..visible = false
      ..uniformScale = gm.triEngineRocket.node.uniformScale;
    _zoomGroup
      ..addChild(gm.triEngineRocket_hull.node)
      ..addChild(gm.triEngineRocket_centercell.node)
      ..addChild(gm.triEngineRocket_leftcell.node)
      ..addChild(gm.triEngineRocket_rightcell.node);
    // ----------------------------------------------------------

    double h = contentSize.height / 2.0;
    //double w = contentSize.width / 2.0;
    double yOff = -h + 10.0;

    _zoomGroup.scaleCenter.setValues(0.0, yOff);
    // Note. This scale setting needs to be placed after the center
    // is defined otherwise you get a local-scale instead of relative.
    _zoomGroup.currentScale = widePerspective;

    _plane = new RectangleNode.basic(Ranger.Color4IGrey)
      ..positionY = yOff
      ..scaleX = contentSize.width
      ..scaleY = 10.0;
    _zoomGroup.addChild(_plane);
    
    _pad = new RectangleNode.basic(Ranger.Color4IOrange)
      ..positionY = yOff + 15.0 + _plane.scaleY / 2.0
      ..scaleX = 200.0
      ..scaleY = 30.0;
    _zoomGroup.addChild(_pad);
    
    _zone = new DualRangeZone.initWith(
        Ranger.color4IFromHex("#ffaa00"),
        Ranger.color4IFromHex("#ffaa77"),
        200.0, 300.0)
      ..positionX = 0.0
      ..positionY = yOff + 250.0
      ..iconsVisible = true
      ..zoneId = 1;
    _zoomGroup.addChild(_zone);
    
    ranger.eventBus.on(DualRangeZone).listen(
    (DualRangeZone zone) {
      _dualRangeZoneAction(zone);
    });

    gm.explodingRing..visible = false
      ..outlineThickness = 5.0
      ..outlineColor = Ranger.Color4IWhite;

    gm.fadingDisc..visible = false
      ..uniformScale = 400.0
      ..fillColor = Ranger.Color4IWhite;

    _zoomGroup.addChild(gm.explodingRing);
    _zoomGroup.addChild(gm.fadingDisc);

    _countTextNode = new FadingTextNode.initWith(Ranger.Color4IOrange)
      ..text = ""
      ..font = "normal 200 10px Verdana"
      ..visible = false
      ..uniformScale = 8.0;
    _zoomGroup.addChild(_countTextNode);

  }
  
  void _dualRangeZoneAction(DualRangeZone zone) {
    double zoom = 1.0;
    
    switch (zone.zoneId) {
      case 1:
        zoom = narrowPerspective;
      break;
    }
  
    ranger.animations.stopAndUntrack(_zoomGroup, ZoomGroup.TWEEN_SCALE);

    switch (zone.action) {
      case DualRangeZone.ZONE_INWARD_ACTION:
          UTE.Tween tw = new UTE.Tween.to(_zoomGroup, ZoomGroup.TWEEN_SCALE, 2.0)
            ..targetValues = [zoom]
            ..easing = UTE.Sine.INOUT;
            ranger.animations.add(tw);
            ranger.animations.track(_zoomGroup, ZoomGroup.TWEEN_SCALE);
        break;
      case DualRangeZone.ZONE_OUTWARD_ACTION:
        _zoomOut(widePerspective, 2.0);
        break;
    }
  }

  void _zoomOut(double zoom, double duration) {
    UTE.Tween tw = new UTE.Tween.to(_zoomGroup, ZoomGroup.TWEEN_SCALE, duration)
      ..targetValues = [zoom]
      ..easing = UTE.Sine.INOUT;
    ranger.animations.add(tw);
    ranger.animations.track(_zoomGroup, ZoomGroup.TWEEN_SCALE);
  }

  //------------------------------------------------------------------
  // Particle explosion
  //------------------------------------------------------------------
  void _constructPSExplosion() {
    _explosionPS = new Ranger.BasicParticleSystem.initWith(100);

    ParticleActivator pa = _constructActivator();

    _explosionPS.particleActivation = pa;

    // Construct Exhaust Particles
    _populateParticleSystem(_explosionPS);
    _explosionPS.active = true;
  }

  ParticleActivator _constructActivator() {
    ParticleActivator pa = new ParticleActivator()
    ..lifetime.min = 1.0
    ..lifetime.max = 4.0
    ..lifetime.variance = 2.0

    ..activationData.velocity.setSpeedRange(1.0, 5.0)
    ..activationData.velocity.limitMagnitude = false
    ..speed.variance = 3.0

    ..startScale.min = 8.5
    ..startScale.max = 20.5
    ..startScale.variance = 1.5

    ..endScale.min = 3.0
    ..endScale.max = 4.5
    ..endScale.variance = 0.5

    ..startColor.setWith(Ranger.Color4IWhite)
    ..endColor.setWith(Ranger.Color4IBlack);

  pa..speed.min = pa.activationData.velocity.minMagnitude
    ..speed.max = pa.activationData.velocity.maxMagnitude;

  return pa;
  }

  void _populateParticleSystem(Ranger.ParticleSystem ps) {
    CircleParticleNode protoVisual = new CircleParticleNode.initWith(Ranger.Color4IBlack);
    CircleParticle prototype = new CircleParticle.withNode(protoVisual);
    ps.addByPrototype(_zoomGroup, prototype);
  }

}
