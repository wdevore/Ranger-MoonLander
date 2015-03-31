part of moonlander;

class LevelRimbaloidScene extends Ranger.AnchoredScene {
  Ranger.GroupNode _group;
  LevelRimbaloidLayer _gameLayer;
  HudRimbaloidLayer _hud;
  
  LevelRimbaloidScene([int tag = 0]) {
    this.tag = tag;
    name = "LevelRimbaloidScene";
  }

  @override
  bool init([int width, int height]) {
    if (super.init()) {
      _group = new Ranger.GroupNode();
      initWithPrimary(_group);
    
      _gameLayer = new LevelRimbaloidLayer.withColor(Ranger.color4IFromHex("#221c35"));
      addLayer(_gameLayer);
      
      _hud = new HudRimbaloidLayer.withColor();
      addLayer(_hud);
    }    
    return true;
  }
  
  @override
  void onEnter() {
    super.onEnter();
  }
  
  @override
  void enable(bool enable) {
    _gameLayer.enable(enable);
    _hud.enable(enable);
  }

}