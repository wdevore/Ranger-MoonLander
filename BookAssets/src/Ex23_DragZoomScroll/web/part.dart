part of layer;

class Part extends PartBase {

  Part() {
    if (init()) {
    }
  }

  @override
  void configure(double scale, Ranger.Color4<int> color) {
    part = new RectangleNode()
      ..init()
      ..uniformScale = scale
      ..fillColor = color.toString();

    group.addChild(part);
  }


}