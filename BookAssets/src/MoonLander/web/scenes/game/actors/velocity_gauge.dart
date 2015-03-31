part of moonlander;

class VelocityGauge {
  Ranger.GroupNode _base;
  NonUniformRectangleNode _solid;
  NonUniformRectangleNode _outline;
  Ranger.TextNode _label;

  double _min = 0.0;
  double _max = 1.0;
  
  // Visual size of gauge
  double _height = 20.0;    // vertical size
  double _width = 300.0;  // horizontal size
  double _ratio = 1.0;
  
  VelocityGauge();
  
  factory VelocityGauge.basic() {
    VelocityGauge o = new VelocityGauge();
    
    if (o.init())
      return o;
    
    return null;
  }
  
  Ranger.Node get node => _base;
  set label(String l) => _label.text = l;
  Ranger.TextNode get TextLabel => _label;
  
  bool init() {
    _base = new Ranger.GroupNode();
    
    _label = new Ranger.TextNode.initWith(Ranger.color4IFromHex("#e5e1e6"));
    _label.text = "Speed";
    _label.uniformScale = 5.0;
    _label.setPosition(-60.0, 35.0);
    _base.addChild(_label);

    _solid = new NonUniformRectangleNode.basic(Ranger.Color4IGreen);
    _solid.height = _height;
    _base.addChild(_solid);
    
    _outline = new NonUniformRectangleNode.basic(null, new Ranger.Color4<int>.withRGBA(255, 255, 255, 128));
    _outline.left = -_width/2.0;
    _outline.height = _height;
    _outline.width = _width;
    _base.addChild(_outline);
    
    return true;
  }
  
  set width(double d) {
    _outline.width = _width = d;
    _outline.left = -_outline.width/2.0;
    _ratio = _width / _max;
  }
  
  set height(double d) {
    _outline.height = _height = d;
  }

  double getValue(double vel) => 1.0 - (_max - vel.abs()) / _max;

  set value(double d) {
    // Scale solid bar
    double p = 1.0 - (_max - d.abs()) / _max;

    if (p.abs() > 0.5)
      _solid.width = 0.5 * _width * d.sign;
    else
      _solid.width = _ratio * d;

    if (p > 0.1)
      _solid.fillColor = Ranger.Color4IRed.toString();
    else if (p > 0.05)
      _solid.fillColor = Ranger.Color4IGoldYellow.toString();
    else
      _solid.fillColor = Ranger.Color4IGreen.toString();
  }
  
  set max(double d) {
    _max = d;
    _ratio = _width / _max;
  }

}