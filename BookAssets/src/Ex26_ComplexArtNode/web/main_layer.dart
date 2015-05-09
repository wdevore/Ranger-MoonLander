part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  ComplexArtNode art;

  bool _rotate = true;

  MainLayer();

  factory MainLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    MainLayer layer = new MainLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = false
      ..color = backgroundColor;
    return layer;
  }

  @override
  void onEnter() {
    enableMouse = true;

    art = new ComplexArtNode();

    addChild(art);

    super.onEnter();
  }

  @override
  bool onMouseDown(MouseEvent event) {

    return true;
  }

}