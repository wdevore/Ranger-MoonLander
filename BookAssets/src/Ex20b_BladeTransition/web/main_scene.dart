part of layer;

class MainScene extends Ranger.AnchoredScene {

  MainScene();

  @override
  void onEnter() {
    super.onEnter();

    MainLayer layer = new MainLayer.withColor(Ranger.Color4IGrey, false);
    initWithPrimary(layer);

  }
}