part of moonlander;

/// Overlay layer.
class HudLayer extends Ranger.BackgroundLayer {
  Ranger.TextNode _fpsText;
  
  HudLayer();

  factory HudLayer.asTransparent([bool centered = true, int width, int height]) {
    HudLayer layer = new HudLayer();
    layer.centered = centered;
    layer.init(width, height);
    layer.transparentBackground = true;
    return layer;
  }

  factory HudLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    HudLayer layer = new HudLayer();
    layer.centered = centered;
    layer.init(width, height);
    layer.color = backgroundColor;
    return layer;
  }

  @override
  void update(double dt) {
    if (ranger.updateStats) {
      // Update FPS text
      if (ranger.upsEnabled)
        _fpsText.text = "FPS: ${ranger.framesPerPeriod}, UPS: ${ranger.updatesPerPeriod}";
      else
        _fpsText.text = "FPS: ${ranger.framesPerPeriod}";

      ranger.framesPerPeriod = 0;
      ranger.updatesPerPeriod = 0;
      ranger.deltaAccum = 0.0;
    }
  }

  @override
  bool init([int width, int height]) {
    super.init(width, height);
    
    _fpsText = new Ranger.TextNode.initWith(Ranger.Color4IWhite);
    _fpsText.text = "--";
    _fpsText.setPosition(-position.x + 10.0, position.y - 40.0);
    _fpsText.uniformScale = 3.0;
    addChild(_fpsText);

    return true;
  }

  @override
  void onEnter() {
    super.onEnter();

    scheduleUpdate();
  }
  
  @override
  void onExit() {
    super.onExit();
    unScheduleUpdate();
  }
}
