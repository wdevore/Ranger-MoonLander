part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode orangeRect;

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
    enableKeyboard = true;

    orangeRect = new RectangleNode()
      ..init()
      ..setPosition(1000.0, 500.0)  // Near center-ish.
      ..uniformScale = 150.0;

    addChild(orangeRect);

    UTE.Tween tw = new UTE.Tween.to(orangeRect, RectangleNode.FADE, 1.0)
      ..targetValues = [0.0]
      ..easing = UTE.Expo.INOUT
      ..repeatYoyo(UTE.Tween.INFINITY, 0.0);
    ranger.animations.add(tw);

    super.onEnter();
  }

}