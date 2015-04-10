part of layer;

class HudLayer extends Ranger.BackgroundLayer {
  Ranger.TextNode _someText;

  HudLayer();

  factory HudLayer.withColor([Ranger.Color4<int> backgroundColor = null, bool centered = true, int width, int height]) {
    HudLayer layer = new HudLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = true //<-- A characteristic of Huds.
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

  void _configure() {
    _someText = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "HUD layer"
      ..font = "normal 900 10px Verdana"
      ..setPosition(100.0, 300.0)
      ..uniformScale = 5.0;
    addChild(_someText);
  }
}