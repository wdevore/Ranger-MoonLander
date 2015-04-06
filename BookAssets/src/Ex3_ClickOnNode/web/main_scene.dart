part of layer;

class MainScene extends Ranger.Scene {

  MainScene();

  @override
  void onEnter() {
    super.onEnter();

    MainLayer layer = new MainLayer.withColor(Ranger.Color4IGrey, false);
    addChild(layer);

  }
}