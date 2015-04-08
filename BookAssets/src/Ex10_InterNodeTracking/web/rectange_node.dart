part of layer;

class RectangleNode extends Ranger.Node with Ranger.GroupingBehavior {
  String fillColor = Ranger.Color4IOrange.toString();

  double left = -0.5;
  double bottom = -0.5;
  double width = 1.0;
  double height = 1.0;

  Ranger.MutableRectangle _bbox = new Ranger.MutableRectangle.zeroP();

  RectangleNode() {
    initGroupingBehavior(this);
    setSize(left, bottom, width, height);
  }

  void setSize(double left, double bottom, double width, double height) {
    this.left = left;
    this.bottom = bottom;
    this.width = width;
    this.height = height;
    _bbox.setValues(left, bottom, width, height);
  }

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D context2D = context.renderContext as CanvasRenderingContext2D;

    context2D..fillStyle = fillColor
      ..fillRect(_bbox.left, _bbox.bottom, _bbox.width, _bbox.height);

  }

  @override
  bool pointInsideByComp(double x, double y) {
    return _bbox.containsPointByComp(x, y);
  }

}