part of moonlander;

class MainLayer extends Ranger.BackgroundLayer {
  Ranger.SpriteImage _scores;
  Ranger.SpriteImage _gear;
  Ranger.SpriteImage _lander;
  Ranger.TextNode _title;
  
  MainLayer();
 
  factory MainLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    MainLayer layer = new MainLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = false
      ..name = "MainLayer"
      ..color = backgroundColor;
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
    super.onEnter();

    // Reset Nodes in case we return to this Layer.
    _lander.rotationByDegrees = 0.0;
    _rotateGear();
    _rockNode(_scores);
  }

  @override
  void onExit() {
    disableInputs();

    // Stop animations when this scene leaves the stage.
    ranger.animations.flushAll();

    super.onExit();
  }

  @override
  bool onMouseDown(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_lander, event.offset.x, event.offset.y);

    if (_lander.pointInside(nodeP.v)) {
      nodeP.moveToPool();
      
      _lander.rotationByDegrees = 0.0;
      
      ranger.animations.rotateTo(
          _lander, 
          0.25,
          90.0, 
          UTE.Linear.INOUT, null)
        ..callback = _rotationComplete
        ..callbackTriggers = UTE.TweenCallback.COMPLETE; // We only need the complete signal.
      
      return true;
    }
    nodeP.moveToPool();

    nodeP = ranger.drawContext.mapViewToNode(_gear, event.offset.x, event.offset.y);

    if (_gear.pointInside(nodeP.v)) {
      nodeP.moveToPool();

      // Send message requesting "Settings Dialog". The MainScene will be
      // listening to this event.
      MessageData md = new MessageData();
      md.actionData = MessageData.SHOW;
      md.whatData = MessageData.DIALOG;
      md.data = "Settings";
      ranger.eventBus.fire(md);

      return true;
    }

    nodeP = ranger.drawContext.mapViewToNode(_scores, event.offset.x, event.offset.y);

    if (_scores.pointInside(nodeP.v)) {
      nodeP.moveToPool();

      // Transition to Scores scene
      ScoresScene inComingScene = new ScoresScene();

      Ranger.TransitionMoveInFrom transition = new Ranger.TransitionMoveInFrom.initWithDurationAndScene(0.5, inComingScene, Ranger.TransitionSlideIn.FROM_BOTTOM)
        ..name = "TransitionMoveInFrom";

      ranger.sceneManager.pushScene(transition);

      return true;
    }

    nodeP.moveToPool();
    return false;
  }
  
  // The Tween callback handler for the rotation.
  // The signature for this method needs to meet the UTE's handler signature.
  /// A [TweenCallbackHandler] method.
  void _rotationComplete(int type, UTE.BaseTween source) {
    switch(type) {
      case UTE.TweenCallback.COMPLETE:
        // Transition to selection scene
        _transitionToSelections();
        break;
    }
  }

  void _transitionToSelections() {
    // Transition to level selector.
    LevelSelectionScene inComingScene = new LevelSelectionScene()
      ..name = "LevelSelectionScene";
    Ranger.TransitionSlideIn transition = new Ranger.TransitionSlideIn.initWithDurationAndScene(0.5, inComingScene, Ranger.TransitionSlideIn.FROM_RIGHT)
      ..name = "TransitionSlideIn";
    ranger.sceneManager.pushScene(transition);
  }
  
  void _configure() {
    //---------------------------------------------------------------
    // Create text nodes.
    //---------------------------------------------------------------
    _title = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#e5e1e6"));
    _title.text = "Moon Lander";
    
    double h = contentSize.height / 2.0;
    double w = contentSize.width / 2.0;
    
    _title.setPosition(-550.0, 150.0);
    _title.uniformScale = 20.0;
    _title.shadows = true;
    addChild(_title);
    
    // Animate title upward a little
    ranger.animations.moveBy(
        _title, 1.0,
        200.0, 0.0,
        UTE.Cubic.INOUT, Ranger.TweenAnimation.TRANSLATE_Y, null);
    ranger.animations.track(_title, Ranger.TweenAnimation.TRANSLATE_Y);

    // Gear icon
    _gear = new Ranger.SpriteImage.withElement(gm.resources.gear)
      ..tag = 911
      ..uniformScale = 4.0
      ..setPosition(-w + (w / 7.0), -h + (h / 5.0));
    addChild(_gear);

    // Scores icon
    _scores = new Ranger.SpriteImage.withElement(gm.resources.medal)
      ..uniformScale = 0.35
      ..rotationByDegrees = 10.0
      ..setPosition(w - (w / 7.0), -h + (h / 5.0));
    addChild(_scores);

    // Lander
    _lander = new Ranger.SpriteImage.withElement(gm.resources.lander1);
    addChild(_lander);
  }

  void _rockNode(Ranger.BaseNode node) {
    UTE.BaseTween wobbleCW = ranger.animations.rotateBy(
        node,
        2.0,
        -node.rotationInDegrees * 2.0,
        UTE.Quad.INOUT,
        null,
        false);

    wobbleCW.repeatYoyo(10000, 0.0);
    ranger.animations.track(node, Ranger.TweenAnimation.ROTATE);

    ranger.animations.add(wobbleCW, true);
  }

  void _rotateGear() {
    UTE.Tween rot = ranger.animations.rotateBy(
        _gear, 
        12.0,
        360.0, 
        UTE.Linear.INOUT, null, false);
    //                 v---------^
    // Above we set "autostart" to false in order to set the repeat value
    // because you can't change the value after the tween has started.
    rot..repeat(UTE.Tween.INFINITY, 0.0)
       ..start();
  }

  @override
  void enable(bool enable) {
    super.enable(enable);
    if (enable) {
      _rotateGear();    
      ranger.animations.track(_gear, Ranger.TweenAnimation.ROTATE);
    }
    else {
      ranger.animations.stopAndUntrack(_gear, Ranger.TweenAnimation.ROTATE);
      ranger.animations.stopAndUntrack(_scores, Ranger.TweenAnimation.ROTATE);
    }
  }

}
