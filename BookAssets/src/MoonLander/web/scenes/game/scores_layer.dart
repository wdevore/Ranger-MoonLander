part of moonlander;

// We show a total of ten scores in two columns of 5 each.
// Each entry shows "initials - score"
class ScoresLayer extends Ranger.BackgroundLayer {

  Ranger.SpriteImage _back;

  Ranger.TextNode _title;
  
  double _deltaTitleY;

  ScoresLayer();
 
  factory ScoresLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    ScoresLayer layer = new ScoresLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = false
      ..color = backgroundColor
      ..name = "ScoresLayer";
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
        _title, 0.5,
        -_deltaTitleY + 400.0, 0.0,
        UTE.Bounce.OUT, Ranger.TweenAnimation.TRANSLATE_Y, null);
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

    return false;
  }

  void _configure() {
    //---------------------------------------------------------------
    // Create text nodes.
    //---------------------------------------------------------------
    double h = contentSize.height / 2.0;
    //double w = contentSize.width / 2.0;
    _deltaTitleY = h + 50.0;

    _title = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#c5e86c"))
      ..text = "High Scores"
      ..setPosition(-400.0, _deltaTitleY)
      ..uniformScale = 15.0
      ..shadows = true;
    addChild(_title);

    // Get scores. There may be less than 10 scores.
    Map scores = gm.scores;
    int rows = scores.keys.length;

    List<int> sortedScores = scores.keys.toList();
    // We provide a comparator because we want high-to-low, not the default low-to-high
    sortedScores.sort((x, y) => y.compareTo(x));

    double x = -750.0;
    double y = 200.0;
    for(int i = 0; i < rows; i++) {
      int score = sortedScores[i];
      String initials = scores[score];

      Ranger.TextNode initialsTN = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#284734"))
        ..uniformScale = 15.0
        ..text = "${initials} - "
        ..setPosition(x, y)
        ..shadows = false;
      addChild(initialsTN);

      Ranger.TextNode scoreTN = new Ranger.TextNode.initWith(Ranger.Color4IBlack)
        ..uniformScale = 15.0
        ..text = "$score"
        ..setPosition(x + 450.0, y)
        ..shadows = true;
      addChild(scoreTN);

      y -= 150.0;
      if (i == 4) {
        x = 250.0;
        y = 200.0;
      }
    }

    //---------------------------------------------------------------
    // Back/return icon
    //---------------------------------------------------------------
    _back = new Ranger.SpriteImage.withElement(gm.resources.back)
      ..uniformScale = 8.0
      ..setPosition(0.0, -450.0);
    addChild(_back);
    
  }
}
