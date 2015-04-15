part of layer;

class ViewPortNode extends Ranger.Node {
  String strokeColor = Ranger.Color4IBlack.toString();

  bool stroke = false;

  double left = 0.0;
  double bottom = 0.0;
  double width = 1.0;
  double height = 1.0;

  Ranger.MutableRectangle _bbox;

  ViewPortNode() {
    _bbox = new Ranger.MutableRectangle.withP(left, bottom, width, height);
  }

  Ranger.MutableRectangle get rect => _bbox;

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

    if (stroke) {
      context2D
        ..strokeStyle = strokeColor
        ..lineWidth = 3.0 / calcUniformScaleComponent()
        ..strokeRect(left, bottom, width, height);
    }
  }

  bool intersects(Ranger.MutableRectangle box) {
    return _bbox.intersects(box);
  }

  @override
  bool pointInsideByComp(double x, double y) {
    return _bbox.containsPointByComp(x, y);
  }

}