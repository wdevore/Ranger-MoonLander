part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  PlasmaNode complex;

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

    complex = new PlasmaNode()
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
          case MessageData.TOTALCIRCLECOUNT:
            complex.totalCircleCount = int.parse(md.data);
            break;
          case MessageData.HUESTART:
            complex.hueStart = int.parse(md.data);
            break;
          case MessageData.HUEEND:
            complex.hueEnd = int.parse(md.data);
            break;
          case MessageData.HUECHANGE:
            int v = int.parse(md.data);
            complex.hueChange = v / 100.0;
            break;
          case MessageData.MINSIZE:
            complex.minSize = double.parse(md.data);
            break;
          case MessageData.MAXSIZE:
            complex.maxSize = double.parse(md.data);
            break;
          case MessageData.SPEED:
            int v = int.parse(md.data);
            complex.speed = v / 100.0;
            break;
          case MessageData.MINGLOWTIME:
            complex.minGlowTime = double.parse(md.data);
            break;
          case MessageData.MAXGLOWTIME:
            complex.maxGlowTime = double.parse(md.data);
            break;
          case MessageData.GLOWSIZE:
            int v = int.parse(md.data);
            complex.glowSize = v / 100.0;
            break;
          case MessageData.REPAINTALPHA:
            int v = int.parse(md.data);
            complex.repaintAlpha = v / 100.0;
            break;
          case MessageData.SPAWNCHANCE:
            int v = int.parse(md.data);
            complex.spawnChance = v / 100.0;
            break;
        }
      });
  }
}