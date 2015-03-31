part of moonlander;

class ScoresScene extends Ranger.AnchoredScene {
  ScoresScene([int tag = 0]) {
    this.tag = tag;
    this.name = "ScoresScene";
  }

  @override
  void onEnter() {
    super.onEnter();
    
    ScoresLayer primaryLayer = new ScoresLayer.withColor(Ranger.color4IFromHex("#ffc563"))
      ..name = "ScoresScene"; // Optional. Used for debugging if needed.

    initWithPrimary(primaryLayer);
  }
}