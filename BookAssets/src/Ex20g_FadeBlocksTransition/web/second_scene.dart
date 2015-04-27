part of layer;

class SecondScene extends Ranger.AnchoredScene {

  SecondScene();

  @override
  void onEnter() {
    super.onEnter();

    SecondLayer layer = new SecondLayer.withColor(Ranger.Color4IDartBlue, false);
    initWithPrimary(layer);

  }
}