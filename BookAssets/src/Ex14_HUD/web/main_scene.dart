part of layer;

class MainScene extends Ranger.AnchoredScene {
  Ranger.GroupNode _group;
  MainLayer _mainLayer;
  HudLayer _hud;

  MainScene();

  @override
  bool init([int width, int height]) {
    if (super.init()) {
      _group = new Ranger.GroupNode();
      initWithPrimary(_group);

      _mainLayer = new MainLayer.withColor(Ranger.Color4IGrey, false);
      addLayer(_mainLayer);

      _hud = new HudLayer.withColor();
      addLayer(_hud);
    }
    return true;
  }

  @override
  void onEnter() {
    super.onEnter();
  }
}