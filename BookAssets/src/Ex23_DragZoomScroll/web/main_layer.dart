part of layer;

/*
  Down:
  Part is pulled from zoom group and added to the clone in the mapped
  position. Scale is copied to clone group.
  Drag:
  Part is dragged as normal. Scroll is checked and performed.
  Up:
  Part is remapped back to zoom group.
 */
class MainLayer extends Ranger.BackgroundLayer {
  GroupDragNode _dragGroup;
  ZoomGroup _zoom;
  Ranger.GroupNode _holdGroup;

  Part orangePart;
  Part greenYellowPart;
  Part _activePart;

  static int NOT_DRAGGING = 0;
  static int DRAGGING_LEVEL = 1;
  static int DRAGGING_PART = 2;

  int _dragging = NOT_DRAGGING;
  double _dragScale = 0.0;
  double prevX = 0.0;
  double prevY = 0.0;

  ScrollEdge _scrollEdge;
  bool scrollNeeded = false;

  LineNode _line1;
  CrossNode _cursor;
  CrossNode _intersect;
  Ranger.TextNode _length;

  Ranger.Vector2P nodePz;

  double _gap = 0.0;
  Vector2 _dragDirection = new Vector2.zero();

  int zoomGroupOrdinalPos = 0;

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
    enableKeyboard = true;
    enableMouse = true;

    super.onEnter();

    _dragGroup = new GroupDragNode()
      ..width = contentSize.width
      ..height = contentSize.height;
    addChild(_dragGroup);

    double percent = 0.5;
    double ratio = contentSize.width / contentSize.height;

    double scrollWidth = contentSize.width - (contentSize.width  * percent / ratio);
    double scrollHeight = contentSize.height - (contentSize.height * percent);

    _gap = (contentSize.width - scrollWidth) / 2.0;

    double scrollCenterOffsetX = (contentSize.width - scrollWidth) / 2.0;
    double scrollCenterOffsetY = (contentSize.height - scrollHeight) / 2.0;

    _scrollEdge = new ScrollEdge()
      ..fill = false
      ..stroke = true
      ..centerX = contentSize.width / 2.0
      ..centerY = contentSize.height / 2.0
      ..setPosition(scrollCenterOffsetX, scrollCenterOffsetY)
      ..width = scrollWidth
      ..height = scrollHeight;
    _dragGroup.addChild(_scrollEdge);

    _holdGroup = new Ranger.GroupNode.basic();
    _dragGroup.addChild(_holdGroup);


    _line1 = new LineNode()
      ..visible = false;
    _dragGroup.addChild(_line1);

    _cursor = new CrossNode()
      ..visible = false
      ..uniformScale = 50.0;
    _dragGroup.addChild(_cursor);

    _intersect = new CrossNode()
      ..visible = false
      ..strokeColor = Ranger.Color3IRed.toString()
      ..uniformScale = 50.0
      ..rotationByDegrees = 45.0;
    _dragGroup.addChild(_intersect);

    _length = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "-"
      ..font = "normal 900 10px Verdana"
      ..setPosition(100.0, 1000.0)
      ..uniformScale = 5.0;
    _dragGroup.addChild(_length);


    _zoom = new ZoomGroup.basic()
      ..setPosition(1000.0, 500.0);
    _dragGroup.addChild(_zoom);

    orangePart = new Part()
      ..configure(150.0, Ranger.Color4IOrange);

    _zoom.addChild(orangePart.group);

    greenYellowPart = new Part()
      ..configure(100.0, Ranger.Color4IGreenYellow);
    greenYellowPart.setPosition(300.0, 0.0);

    _zoom.addChild(greenYellowPart.group);

    scheduleUpdate();
  }

  @override
  void onExit() {
    super.onExit();
    unScheduleUpdate();
  }

  @override
  bool onMouseDown(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_dragGroup, event.offset.x, event.offset.y);

    bool accepted = orangePart.eventDown(event.offset.x, event.offset.y);
    if (accepted)
      _activePart = orangePart;
    else {
      bool b = greenYellowPart.eventDown(event.offset.x, event.offset.y);
      if (b)
        _activePart = greenYellowPart;
      accepted = accepted || b;
    }

    if (_dragGroup.pointInsideByComp(nodeP.v.x, nodeP.v.y) && !accepted) {
      nodeP.moveToPool();

      // Translations are almost always relative to the a Node's parent, in this case
      // the rectangle's parent is "this" MainLayer.
      nodeP = ranger.drawContext.mapViewToNode(this, event.offset.x, event.offset.y);

      prevX = nodeP.v.x;
      prevY = nodeP.v.y;

      nodeP.moveToPool();
      _dragging = DRAGGING_LEVEL;

      return true;
    }
    else if (accepted) {
      _dragging = DRAGGING_PART;

      // Set Scale first "before" any mapping! We do this because our hold group
      // is a standard GroupNode and not a cloned zoom group.
      _holdGroup.uniformScale = _zoom.currentScale;

      // Map current zoom position into hold position via world-space.
      //Ranger.Vector2P ps = greenYellowPart.group.convertToWorldSpace(_activePart.part.position);
      //Ranger.Vector2P hs = _holdGroup.convertWorldToNodeSpace(ps.v);
      // OR via parent-space (faster)
      Ranger.Vector2P ps = _zoom.convertToParentSpace(_activePart.group.position);
      Ranger.Vector2P hs = _holdGroup.convertParentToNodeSpace(ps.v);
      ps.moveToPool();

      // Move Part to _holdGroup
      // First remove part from zoom group and track its original ordinal position
      // for later re-insertion.
      zoomGroupOrdinalPos = _zoom.removeChild(_activePart.group, false);
      // Move it to the temp hold group.
      _holdGroup.addChild(_activePart.group);
      // Now place the part in the equivalent mapped position in the hold group.
      _activePart.group.setPosition(hs.v.x, hs.v.y);
      hs.moveToPool();
      // Resync event as a result of the move.
      _activePart.eventDown(event.offset.x, event.offset.y); // Sync to new parent.

    }

    nodeP.moveToPool();

    return true;
  }

  @override
  bool onMouseMove(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_dragGroup, event.offset.x, event.offset.y);
    orangePart.pointInsideByView(event.offset.x, event.offset.y);
    greenYellowPart.pointInsideByView(event.offset.x, event.offset.y);

    if (_dragging == DRAGGING_LEVEL) {
      double dx = nodeP.v.x - prevX;
      double dy = nodeP.v.y - prevY;

      _zoom.translateByComp(dx, dy);

      prevX = nodeP.v.x;
      prevY = nodeP.v.y;
    }
    else if (_dragging == DRAGGING_PART) {
      bool scrollNeeded = _handleDrag(event.offset.x, event.offset.y, nodeP.v.x, nodeP.v.y);

      if (scrollNeeded)
        _showHideStuff(true);
      else
        _showHideStuff(false);

      bool accepted = orangePart.eventMove(event.offset.x, event.offset.y);
      if (!accepted)
        accepted = greenYellowPart.eventMove(event.offset.x, event.offset.y);
    }

    nodeP.moveToPool();

    return false;
  }

  bool _handleDrag(int x, int y, double nx, double ny) {

    if (_scrollEdge.pointOutsideByComp(x, y)) {
      scrollNeeded = true;
      _line1
        ..sx = _scrollEdge.centerX
        ..sy = _scrollEdge.centerY
        ..ex = nx
        ..ey = ny;

      _cursor.setPosition(nx, ny);

      double l = 0.0;

      Intersect intersect = Geometrics.segmentIntersect(
          _scrollEdge.centerX - _scrollEdge.width / 2.0,
          _scrollEdge.centerY + _scrollEdge.height / 2.0,
          _scrollEdge.centerX + _scrollEdge.width / 2.0,
          _scrollEdge.centerY + _scrollEdge.height / 2.0,
          _line1.sx, _line1.sy, _line1.ex, _line1.ey
      );
      if (intersect.type == Intersect.INTERSECTED) {
        _intersect.setPosition(intersect.x, intersect.y);
        l = Geometrics.distanceBetweenByDouble(
            intersect.x, intersect.y, nx, ny
        );
      }
      else {
        Intersect intersect = Geometrics.segmentIntersect(
            _scrollEdge.centerX + _scrollEdge.width / 2.0,
            _scrollEdge.centerY + _scrollEdge.height / 2.0,
            _scrollEdge.centerX + _scrollEdge.width / 2.0,
            _scrollEdge.centerY - _scrollEdge.height / 2.0,
            _line1.sx, _line1.sy, _line1.ex, _line1.ey
        );
        if (intersect.type == Intersect.INTERSECTED) {
          _intersect.setPosition(intersect.x, intersect.y);
          l = Geometrics.distanceBetweenByDouble(
              intersect.x, intersect.y, nx, ny
          );
        }
        else {
          Intersect intersect = Geometrics.segmentIntersect(
              _scrollEdge.centerX + _scrollEdge.width / 2.0,
              _scrollEdge.centerY - _scrollEdge.height / 2.0,
              _scrollEdge.centerX - _scrollEdge.width / 2.0,
              _scrollEdge.centerY - _scrollEdge.height / 2.0,
              _line1.sx, _line1.sy, _line1.ex, _line1.ey
          );
          if (intersect.type == Intersect.INTERSECTED) {
            _intersect.setPosition(intersect.x, intersect.y);
            l = Geometrics.distanceBetweenByDouble(
                intersect.x, intersect.y, nx, ny
            );
          }
          else {
            Intersect intersect = Geometrics.segmentIntersect(
                _scrollEdge.centerX - _scrollEdge.width / 2.0,
                _scrollEdge.centerY - _scrollEdge.height / 2.0,
                _scrollEdge.centerX - _scrollEdge.width / 2.0,
                _scrollEdge.centerY + _scrollEdge.height / 2.0,
                _line1.sx, _line1.sy, _line1.ex, _line1.ey
            );
            if (intersect.type == Intersect.INTERSECTED) {
              _intersect.setPosition(intersect.x, intersect.y);
              l = Geometrics.distanceBetweenByDouble(
                  intersect.x, intersect.y, nx, ny
              );
            }
          }
        }
      }

      if (intersect.type == Intersect.INTERSECTED) {
        _line1
          ..sx = intersect.x
          ..sy = intersect.y
          ..ex = nx
          ..ey = ny;
      }

      double scaleNormalized = l / _gap;
      _dragScale = (1.0 - pow(50.0, scaleNormalized)).abs();
      _length.text = "Distance: ${_dragScale.toStringAsFixed(3)}";
      _dragDirection.setValues(nx - _scrollEdge.centerX, ny - _scrollEdge.centerY);
      _dragDirection.normalize();
    }
    else {
      scrollNeeded = false;
    }

    return scrollNeeded;
  }

  @override
  bool onMouseUp(MouseEvent event) {
    _activePart.eventUp();

    _dragScale = 0.0;
    if (_dragging == DRAGGING_PART) {
      //Ranger.Vector2P ps = greenYellowPart.group.convertToWorldSpace(_activePart.part.position);
      //Ranger.Vector2P hs = _zoom.convertWorldToNodeSpace(ps.v);
      // OR
      Ranger.Vector2P ps = _holdGroup.convertToParentSpace(_activePart.group.position);
      Ranger.Vector2P hs = _zoom.convertParentToNodeSpace(ps.v);
      ps.moveToPool();

      // Remove the part from temp holding group.
      _holdGroup.removeChild(_activePart.group, false);
      // Move it back to the zoom group based on its original ordinal position.
      _zoom.addChildAt(_activePart.group, zoomGroupOrdinalPos);
      // Position it based on it position from the hold group.
      _activePart.group.setPosition(hs.v.x, hs.v.y);
      hs.moveToPool();
    }

    _showHideStuff(false);

    _dragging = NOT_DRAGGING;

    return false;
  }

  void _showHideStuff(bool b) {
    _line1.visible = b;
    _cursor.visible = b;
    _intersect.visible = b;
  }

  @override
  void update(double dt) {
    if (_dragging == DRAGGING_PART) {
      if (scrollNeeded) {
        // Move level opposite direction of Part.
        double dx = -_dragDirection.x * _dragScale;
        double dy = -_dragDirection.y * _dragScale;
        _zoom.translateByComp(dx, dy);
      }
    }
  }

  @override
  bool onMouseWheel(WheelEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_zoom, event.offset.x, event.offset.y);

    _zoom.scaleCenter.setValues(nodeP.v.x, nodeP.v.y);
    nodeP.moveToPool();

    if (event.wheelDeltaY > 0) {
      // Zoom in
      _zoom.zoomBy(0.02);
    }
    else {
      // Zoom out
      _zoom.zoomBy(-0.02);
    }

    // Keeps browser from handling the event thus preventing a browser scroll.
    event.preventDefault();

    return true;
  }

  @override
  bool onKeyDown(KeyboardEvent event) {

    switch (event.keyCode) {
      case KeyCode.ONE:
        // stop
        break;
    }
    return true;
  }

}