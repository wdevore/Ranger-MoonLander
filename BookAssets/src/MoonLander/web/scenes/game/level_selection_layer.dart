part of moonlander;

class LevelSelectionLayer extends Ranger.BackgroundLayer {
  Ranger.SpriteImage _rocket1;
  Ranger.TextNode _rocket1Text;
  
  Ranger.SpriteImage _rocket2;
  Ranger.TextNode _rocket2Text;
  Ranger.SpriteImage _rocket2Lock;
  
  Ranger.SpriteImage _rocket3;
  Ranger.TextNode _rocket3Text;
  Ranger.SpriteImage _rocket3Lock;

  Ranger.SpriteImage _back;

  Ranger.TextNode _title;
  
  double _deltaTitleY;

  LevelSelectionLayer();
 
  factory LevelSelectionLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    LevelSelectionLayer layer = new LevelSelectionLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = false
      ..color = backgroundColor
      ..tag = 1000123
      ..name = "LevelSelectionLayer";
    return layer;
  }

  @override
  bool init([int width, int height]) {
    if (super.init(width, height)) {

      UTE.Tween.registerAccessor(Ranger.TextNode, ranger.animations);

      _configure();
    }
    
    return true;
  }

  @override
  void onEnter() {
    enableMouse = true;
    super.onEnter();
  }

  @override
  void onExit() {
    disableInputs();
    
    ranger.animations.flushAll();

    super.onExit();
  }

  @override
  void onEnterTransitionDidFinish() {
    super.onEnterTransitionDidFinish();

    ranger.animations.moveBy(
        _title, 1.0,
        -_deltaTitleY + 250.0, 0.0,
        UTE.Cubic.OUT, Ranger.TweenAnimation.TRANSLATE_Y, null);
  }

  @override
  bool onMouseDown(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_back, event.offset.x, event.offset.y);

    if (_back.pointInside(nodeP.v)) {
      nodeP.moveToPool();
      // Transition back to MainScene.
      ranger.sceneManager.popScene();
      return true;
    }
    nodeP.moveToPool();

    nodeP = ranger.drawContext.mapViewToNode(_rocket1, event.offset.x, event.offset.y);

    if (_rocket1.pointInside(nodeP.v)) {
      nodeP.moveToPool();
      LevelRimbaloidScene inComingScene = new LevelRimbaloidScene()
        ..name = "LevelRimbaloidScene";
      Ranger.TransitionMoveInFrom transition = new Ranger.TransitionMoveInFrom.initWithDurationAndScene(0.5, inComingScene, Ranger.TransitionSlideIn.FROM_BOTTOM)
        ..name = "TransitionMoveInFrom";
      
      ranger.sceneManager.replaceScene(transition);

      return true;
    }
    nodeP.moveToPool();
    
    return false;
  }
  
  void _configure() {
    //---------------------------------------------------------------
    // Create text nodes.
    //---------------------------------------------------------------
    _title = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#e5e1e6"));
    _title.text = "Mission Go!";
    
    double h = contentSize.height / 2.0;
    //double w = contentSize.width / 2.0;
    _deltaTitleY = h + 50.0;

    _title..setPosition(-550.0, _deltaTitleY)
      ..uniformScale = 20.0
      ..shadows = true;
    addChild(_title);
   
    //---------------------------------------------------------------
    // Create rocket 1, text
    //---------------------------------------------------------------
    _rocket1 = new Ranger.SpriteImage.withElement(gm.resources.rocket1)
      ..uniformScale = 10.0
      ..setPosition(-500.0, 0.0);
    addChild(_rocket1);
    _rocket1Text = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#e5e1e6"))
      ..uniformScale = 5.0
      ..text = "Rimbaloid"
      ..setPosition(-610.0, -200.0)
      ..shadows = true;

    addChild(_rocket1Text);

    //---------------------------------------------------------------
    // Create rocket 2, text and lock nodes.
    //---------------------------------------------------------------
    _rocket2 = new Ranger.SpriteImage.withElement(gm.resources.rocket2)
      ..uniformScale = 10.0
      ..setPosition(0.0, 0.0);
    addChild(_rocket2);
    _rocket2Text = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#e5e1e6"))
      ..uniformScale = 5.0
      ..text = "RangerDanger"
      ..setPosition(-160.0, -200.0)
      ..shadows = true;
    addChild(_rocket2Text);
    _rocket2Lock = new Ranger.SpriteImage.withElement(gm.resources.lock)
      ..uniformScale = 3.0
      ..setPosition(90.0, -80.0);
    addChild(_rocket2Lock);

    //---------------------------------------------------------------
    // Create rocket 3, text and lock nodes.
    //---------------------------------------------------------------
    _rocket3 = new Ranger.SpriteImage.withElement(gm.resources.rocket3)
      ..uniformScale = 10.0
      ..setPosition(500.0, 0.0);
    addChild(_rocket3);
    _rocket3Text = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#e5e1e6"))
      ..uniformScale = 5.0
      ..text = "OnTheRocks"
      ..setPosition(360.0, -200.0)
      ..shadows = true;
    addChild(_rocket3Text);
    _rocket3Lock = new Ranger.SpriteImage.withElement(gm.resources.lock)
      ..uniformScale = 3.0
      ..setPosition(500.0 + 90.0, -80.0);
    addChild(_rocket3Lock);
    
    //---------------------------------------------------------------
    // Back/return icon
    //---------------------------------------------------------------
    _back = new Ranger.SpriteImage.withElement(gm.resources.back)
      ..uniformScale = 8.0
      ..setPosition(0.0, -400.0);
    addChild(_back);
    
  }
}
