part of layer;

abstract class PartBase {
  double prevX = 0.0;
  double prevY = 0.0;
  bool _dragging = false;

  Ranger.GroupNode group;
  String name = "";
  RectangleNode part;

  double scale = 0.0;

  int _entered = -1;

//  Ranger.MutableRectangle _bbox = new Ranger.MutableRectangle.withP(-0.5, -0.5, 1.0, 1.0);
  Ranger.MutableRectangle _bbox = new Ranger.MutableRectangle.withP(0.0, 0.0, 1.0, 1.0);

  bool init() {
    group = new Ranger.GroupNode.basic();

    return true;
  }

  void configure(double scale, Ranger.Color4<int> color);

  bool pointInsideByView(int x, int y) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(part, x, y);

    bool inside = _bbox.containsPointByComp(nodeP.v.x, nodeP.v.y);

    if (inside) {
      if (_entered == -1 || _entered == 0) {
        _entered = 1;
        part.stroke = true;
      }
    }
    else {
      _entered = 0;
      part.stroke = false;
    }

    nodeP.moveToPool();

    return inside;
  }

  void setPosition(double x, double y) {
    group.setPosition(x, y);
  }

  bool eventDown(int x, int y) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(part, x, y);

    bool inside = _bbox.containsPointByComp(nodeP.v.x, nodeP.v.y);

    if (inside) {
      nodeP.moveToPool();
      nodeP = ranger.drawContext.mapViewToNode(group.parent, x, y);

      prevX = nodeP.v.x;
      prevY = nodeP.v.y;

      _dragging = true;
    }
    else {
      _dragging = false;
    }

    nodeP.moveToPool();

    return inside;
  }

  bool eventUp() {
    _dragging = false;
    return true;
  }

  bool eventMove(int x, int y) {
    if (_dragging) {

      Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(group.parent, x, y);

      double dx = nodeP.v.x - prevX;
      double dy = nodeP.v.y - prevY;

      group.moveByComp(dx, dy);

      prevX = nodeP.v.x;
      prevY = nodeP.v.y;

      nodeP.moveToPool();

      return true;
    }

    return false;
  }
}