part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  ComplexHexNode complex;

  bool _cleared = false;

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

    complex = new ComplexHexNode()
      ..init();

    addChild(complex);

    super.onEnter();
  }

  @override
  void draw(Ranger.DrawContext context) {
    super.draw(context);
    if (!_cleared) {
      // Clear the background just once.
      context.drawRect(0.0, 0.0, contentSize.width, contentSize.height);
      _cleared = true;
    }
  }

  @override
  bool onMouseDown(MouseEvent event) {

    return true;
  }


}