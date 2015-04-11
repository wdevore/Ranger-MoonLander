part of layer;

class MainLayer extends Ranger.BackgroundLayer {
  RectangleNode orangeRect;
  RectangleNode greenYellowRect;

  ZoomGroup _zoomGroup;
  bool _zoomIn = false;

  MainLayer();

  factory MainLayer.withColor(Ranger.Color4<int> backgroundColor, [bool centered = true, int width, int height]) {
    MainLayer layer = new MainLayer()
      ..centered = centered
      ..init(width, height)
      ..transparentBackground = false
      ..color = backgroundColor;
    return layer;
  }

  @override
  void onEnter() {
    enableMouse = true;

    _zoomGroup = new ZoomGroup.basic();
    addChild(_zoomGroup);

    orangeRect = new RectangleNode()
      ..init()
      ..setPosition(500.0, 500.0)
      ..uniformScale = 150.0;

    _zoomGroup.addChild(orangeRect);

    greenYellowRect = new RectangleNode()
      ..init()
      ..fillColor = Ranger.Color4IGreenYellow.toString()
      ..setPosition(1500.0, 500.0)
      ..uniformScale = 250.0;

    _zoomGroup.addChild(greenYellowRect);

    UTE.Tween.registerAccessor(RectangleNode, ranger.animations);

    _rotateNode(orangeRect, 2.0);
    _rotateNode(greenYellowRect, 4.0);

    // Not really necessary to initial as these are the default values
    // They are here for completeness.
    _zoomGroup..scaleCenter.setValues(0.0, 0.0)
      ..currentScale = 1.0
      ..iconScale = 20.0
      ..zoomIconVisible = true;
    super.onEnter();
  }

  @override
  void onExit() {
    disableInputs();

    ranger.animations.flushAll();

    super.onExit();
  }

  @override
  bool onMouseDown(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_zoomGroup, event.offset.x, event.offset.y);

    ranger.animations.stopAndUntrack(_zoomGroup, ZoomGroup.TWEEN_SCALE);

    _zoomGroup.scaleCenter.setValues(nodeP.v.x, nodeP.v.y);

    if (_zoomIn) {
      _zoom(1.0, 1.0);
    }
    else {
      _zoom(0.5, 1.0);
    }

    _zoomIn = !_zoomIn;

    return true;
  }

  void _zoom(double zoom, double duration) {
    UTE.Tween tw = new UTE.Tween.to(_zoomGroup, ZoomGroup.TWEEN_SCALE, duration)
      ..targetValues = [zoom]
      ..easing = UTE.Sine.INOUT;
    ranger.animations.add(tw);
    ranger.animations.track(_zoomGroup, ZoomGroup.TWEEN_SCALE);
  }

  void _rotateNode(RectangleNode rect, double duration) {

    ranger.animations.stopAndUntrack(rect, Ranger.TweenAnimation.ROTATE);

    ranger.animations.rotateBy(
        rect,
        duration,
        360.0,
        UTE.Linear.INOUT, null, false)
      ..repeat(10000, 0.0)
      ..start();

    ranger.animations.track(rect, Ranger.TweenAnimation.ROTATE);

  }
}