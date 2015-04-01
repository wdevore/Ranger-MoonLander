part of scene;

class MainScene extends Ranger.Scene {

  MainScene();

  @override
  void onEnter() {
    super.onEnter();

    RectangleNode rectangle = new RectangleNode()
      ..init()
      ..setPosition(500.0, 500.0)
      ..uniformScale = 150.0;

    addChild(rectangle);

  }
}