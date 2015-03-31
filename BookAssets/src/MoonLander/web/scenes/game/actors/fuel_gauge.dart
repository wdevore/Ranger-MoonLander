part of moonlander;

class FuelGauge {
  Ranger.GroupNode _base;
  NonUniformRectangleNode _solid;
  NonUniformRectangleNode _outline;
  Ranger.TextNode _label;

  double _min = 0.0;
  double _max = 1.0;
  
  // Visual size of gauge
  double _height = 20.0;    // vertical size
  double _width = 400.0;  // horizontal size
  double _ratio = 1.0;
  
  FuelGauge();
  
  factory FuelGauge.basic() {
    FuelGauge o = new FuelGauge();
    
    if (o.init())
      return o;
    
    return null;
  }
  
  Ranger.Node get node => _base;
  
  bool init() {
    _base = new Ranger.GroupNode();
    
    _label = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#e5e1e6"));
    _label.text = "Fuel";
    _label.uniformScale = 5.0;
    _label.positionX = -110.0;
    _base.addChild(_label);

    _solid = new NonUniformRectangleNode.basic(Ranger.Color4IGreen);
    _solid.height = _height;
    _base.addChild(_solid);
    
    _outline = new NonUniformRectangleNode.basic(null, new Ranger.Color4<int>.withRGBA(255, 255, 255, 128));
    _outline.height = _height;
    _outline.width = _width;
    _base.addChild(_outline);
    
    return true;
  }
  
  set width(double d) {
    _outline.width = _width = d;
    _ratio = _width / _max;
  }
  
  set height(double d) {
    _outline.height = _height = d;
  }
  
  set value(double d) {
    // Scale solid bar
    _solid.width = _ratio * d;
    
    double p = 1.0 - (_max - d) / _max;
    
    if (p < 0.25)
      _solid.fillColor = Ranger.Color4IRed.toString();
    else if (p < 0.5)
      _solid.fillColor = Ranger.Color4IGoldYellow.toString();
  }
  
  set max(double d) {
    _max = d;
    _ratio = _width / _max;
  }

}