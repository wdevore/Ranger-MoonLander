part of moonlander;

class SplashLayer extends Ranger.BackgroundLayer {
  Ranger.TextNode _title;
  Ranger.SpriteImage _spinner;
  Ranger.TextNode _loading;
  
  double _deltaTitleY;
  
  SplashLayer();
 
  factory SplashLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    SplashLayer layer = new SplashLayer();
    layer.centered = centered;
    layer.init(width, height);
    layer.transparentBackground = false;
    layer.color = backgroundColor;
    return layer;
  }

  @override
  bool init([int width, int height]) {
    if (super.init(width, height)) {

      // We need to register the SpriteImage class so that the
      // Tween Engine (TE) recognizes the class.
      UTE.Tween.registerAccessor(Ranger.SpriteImage, ranger.animations);
      UTE.Tween.registerAccessor(Ranger.TextNode, ranger.animations);

      _configure();
    }
    
    return true;
  }

  void _configure() {
    //---------------------------------------------------------------
    // Create text nodes.
    //---------------------------------------------------------------
    _title = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#e5e1e6"));
    _title.text = "Moon Lander";
    
    double h = contentSize.height;
    _deltaTitleY = h / 2.0 + 50.0;
    _title.setPosition(-550.0, _deltaTitleY);
    _title.uniformScale = 20.0;
    _title.shadows = true;
    addChild(_title);
  }
  
  void beforeResourcesLoaded() {
    // First get the spinner up and animating.
    _spinner = gm.resources.getSpinnerRing(1.5, -360.0, 7001);
    _spinner.uniformScale = 0.5;
    _spinner.setPosition(0.0, 0.0);
    
    // Track this infinite animation.
    ranger.animations.track(_spinner, Ranger.TweenAnimation.ROTATE);

    addChild(_spinner);

    _loading = new Ranger.TextNode.initWith(Ranger.Color4IOrange);
    _loading.text = "Loading";
    
    double h = contentSize.height;
    _loading.setPosition(-280.0, -230.0);
    _loading.uniformScale = 15.0;
    _loading.shadows = true;
    addChild(_loading);
    
    // Animate Title into view.
    UTE.Tween move = ranger.animations.moveBy(
        _title, 1.0,
        -_deltaTitleY + 150.0, 0.0,
        UTE.Cubic.OUT, Ranger.TweenAnimation.TRANSLATE_Y, null);
    ranger.animations.track(_title, Ranger.TweenAnimation.TRANSLATE_Y);
  }
  
  void afterResourcesLoaded() {
    // Stop any previous animations; especially infinite ones.
    ranger.animations.flushAll();
    
    _loading.visible = false;
    _spinner.visible = false;
  }
  

}
