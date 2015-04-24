part of layer;

class GroupDragNode extends Ranger.GroupNode {

  Ranger.MutableRectangle _bbox = new Ranger.MutableRectangle.withP(0.0, 0.0, 1.0, 1.0);

  GroupDragNode() {
    if (init()) {
      initGroupingBehavior(this);
    }
  }

  set width (double v) {
    _bbox.width = v;
  }

  set height (double v) {
    _bbox.height = v;
  }

  @override
  bool pointInsideByComp(double x, double y) {
    return _bbox.containsPointByComp(x, y);
  }

}