part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  SpinningStarsNode complex;

  bool _rotate = true;
  bool _cleared = false;

  StreamSubscription<MessageData> _busStream;

  MainLayer();

  factory MainLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    MainLayer layer = new MainLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = true
      ..color = backgroundColor;

    // Tell the SceneManager to NOT clear the background on every render pass.
    ranger.sceneManager.ignoreClear = true;

    return layer;
  }

  @override
  void onEnter() {
    enableMouse = true;

    complex = new SpinningStarsNode()
      ..init();

    addChild(complex);

    _listenToBus();

    super.onEnter();
  }

  @override
  void onExit() {
    ranger.animations.flushAll();

    if (_busStream != null)
      _busStream.cancel();

    super.onExit();
  }

  @override
  void draw(Ranger.DrawContext context) {
    super.draw(context);
    if (!_cleared) {
      // Clear the background just once. This will allow the alpha
      // accumulate
      context.drawRect(0.0, 0.0, contentSize.width, contentSize.height);
      _cleared = true;
    }
  }

  @override
  bool onMouseDown(MouseEvent event) {

    return true;
  }

  void _listenToBus() {
    _busStream = ranger.eventBus.on(MessageData).listen(
      (MessageData md) {
        switch (md.field) {
          case MessageData.TOTALORBITALS:
            complex.TotalOrbitals = int.parse(md.data);
            complex.rebuild();
            break;
          case MessageData.SCALE:
            int v = int.parse(md.data);
            complex.Scale = v / 100.0;
            break;
          case MessageData.RADIUSJITTER:
            complex.RadiusJitter = double.parse(md.data);
            break;
          case MessageData.HUEJITTER:
            complex.HueJitter = double.parse(md.data);
            break;
          case MessageData.SPEED:
            complex.Speed = -double.parse(md.data);
            break;
          case MessageData.CLEARALPHA:
            complex.ClearAlpha = double.parse(md.data);
            break;
          case MessageData.TOGGLEORBITALS:
            complex.ToggleOrbitals = md.data == "Y" ? true : false;
            break;
          case MessageData.ORBITALALPHA:
            int v = int.parse(md.data);
            complex.OrbitalAlpha = v;
            break;
          case MessageData.TOGGLELIGHT:
            complex.ToggleLight = md.data == "Y" ? true : false;
            break;
          case MessageData.LIGHTALPHA:
            int v = int.parse(md.data);
            complex.LightAlpha = v;
            break;
          case MessageData.RESET:
            complex
              ..TotalOrbitals = 100
              ..rebuild()
              ..ToggleOrbitals = true
              ..ToggleLight = true
              ..ClearAlpha = 10.0
              ..OrbitalAlpha = 100
              ..LightAlpha = 10
              ..Speed = -65.0
              ..RadiusJitter = 0.0
              ..HueJitter = 0.0
              ..Scale = 2.0;

            MessageData md = new MessageData()
              ..field = MessageData.UPDATEGUI
              ..complex = complex;
            ranger.eventBus.fire(md);
            break;
        }
      });
  }
}