part of layer;

class MainScene extends Ranger.Scene {

  MainScene() {
    name = "MainScene";
  }

  @override
  void onEnter() {
    super.onEnter();

    MainLayer layer = new MainLayer.withColor(Ranger.Color4IBlack, false);
    addChild(layer);

  }
}