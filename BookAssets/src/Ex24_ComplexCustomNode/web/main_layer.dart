part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  LissajousCurveNode complex;

  bool _rotate = true;
  bool _cleared = false;

  MainLayer();

  factory MainLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    MainLayer layer = new MainLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = true
      ..color = backgroundColor;

    ranger.sceneManager.ignoreClear = true;

    return layer;
  }

  @override
  void onEnter() {
    enableMouse = true;

    complex = new LissajousCurveNode()
      ..init()
      ..drawCurves = true
      ..setPosition(350.0, 50.0)
      ..uniformScale = 2.0;

    addChild(complex);

    super.onEnter();
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

    complex.random();

    return true;
  }


}