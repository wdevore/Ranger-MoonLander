part of layer;

class MainScene extends Ranger.Scene {

  MainScene();

  @override
  void onEnter() {
    super.onEnter();

    MainLayer layer = new MainLayer.withColor(Ranger.color4IFromHex("#333333ff"), false);
    addChild(layer);

  }
}