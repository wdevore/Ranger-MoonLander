part of moonlander;

class BasicButton extends Button {
  RoundRectangleNode _background;
  Ranger.SpriteImage _icon;
  Ranger.TextNode _captionNode;

  double _width = 0.0;
  double _height = 0.0;
  
  String backgroundFillColor;
  String backgroundOutlineColor;
  Ranger.Color4<int> captionColor;
  String _caption;
  Vector2 captionOffset = new Vector2.zero();
  
  BasicButton();
  
  factory BasicButton.basic([double width, double height]) {
    BasicButton b = new BasicButton();
    b.init(width, height);
    return b;
  }

  bool init([double width, double height]) {
    if (super.init()) {
      initGroupingBehavior(this);
      _width = width;
      _height = height;
    }
    return true;
  }

  void setIcon(Ranger.SpriteImage si, double px, double py) {
    _icon = si;
    _icon.setPosition(px, py);
  }
  
  void construct() {
    _background = new RoundRectangleNode.basic()
      ..cornerRadius = 15.0
      ..fillColor = backgroundFillColor
      ..outlineColor = backgroundOutlineColor
      ..width = _width
      ..height = _height;
    addChild(_background);

    double dx = _width * 0.3;
    double dy = _height * 0.3;
    double ix = _width - dx;
    double iy = _height - dy;
    
    _captionNode = new Ranger.TextNode.initWith(captionColor)
        ..text = "Uhmm..."
        ..font = "normal 1000 10px Verdana"
        ..setPosition(captionOffset.x, captionOffset.y)
        ..uniformScale = 3.5;
    addChild(_captionNode);
    
    if (_icon != null)
      addChild(_icon);
  }

  set caption(String s) => _captionNode.text = s;
  Ranger.TextNode get captionNode => _captionNode;

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    return 0;
  }
  
  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
  }
  
  @override
  bool check(int x, int y) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_background, x, y);

    if (_background.pointInside(nodeP.v)) {
      nodeP.moveToPool();
      
      // Send message indicating this toggle button was clicked.
      MessageData md = new MessageData();
      md.whatData = MessageData.BUTTON;
      md.actionData = MessageData.CLICKED;
      md.data = _caption;
      ranger.eventBus.fire(md);
      
      return true;
    }
    nodeP.moveToPool();
    
    return false;
  }


}