part of layer;

class ScrollEdge extends RectangleNode {

  double distance = 0.0;

  double centerX;
  double centerY;

  ScrollEdge() {
    init();
  }

  get width => scale.x;
  set width (double v) {
    scaleX = v;
  }

  get height => scale.y;
  set height (double v) {
    scaleY = v;
  }

  bool pointOutsideByComp(int x, int y) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(this, x, y);

    bool state = !_bbox.containsPointByComp(nodeP.v.x, nodeP.v.y);

    if (state)
      strokeColor = Ranger.Color4IGreenYellow.toString();
    else
      strokeColor = Ranger.Color4IBlack.toString();

    _calcDistance();

    nodeP.moveToPool();

    return state;
  }

  void _calcDistance() {
    // Find intersect of line from origin to edge.

    // compute length from intersect to cursor

    // Apply exponential scaling.
  }
}