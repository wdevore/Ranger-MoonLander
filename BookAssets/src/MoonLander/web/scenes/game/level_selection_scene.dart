part of moonlander;

class LevelSelectionScene extends Ranger.AnchoredScene {
  LevelSelectionScene([int tag = 0]) {
    this.tag = tag;
    this.name = "LevelSelectionScene";
  }

  @override
  void onEnter() {
    super.onEnter();
    
    LevelSelectionLayer primaryLayer = new LevelSelectionLayer.withColor(Ranger.color4IFromHex("#221c35"))
      ..name = "LevelSelectionLayer";
    initWithPrimary(primaryLayer);
  }
}