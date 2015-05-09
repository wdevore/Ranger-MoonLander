part of layer;

class _Point {
  double x = 0.0;
  double y = 0.0;
  double angle = 0.0;
}

// Based on:
// http://codepen.io/DonKarlssonSan/pen/oXgmbL

class ComplexHexNode extends Ranger.Node {

  double minS = 0.0;

  _Point point = new _Point();
  int x = 0;
  int y = 0;
  int color = 0;

  Random _randGen = new Random();

  @override
  void onEnter() {
    point.x = ranger.designSize.width / 2.0;
    point.y = ranger.designSize.height / 2.0;
    minS = min(ranger.designSize.width, ranger.designSize.height);
  }

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D ctx = context.renderContext as CanvasRenderingContext2D;

    color += 1;
    ctx.strokeStyle = "hsla($color, 90%, 50%, 0.75)";
    ctx.beginPath();
    ctx.moveTo(point.x, point.y);

    do {
      if(_randGen.nextDouble() > 0.5) {
        point.angle += PI / 3.0;
      }
      else {
        point.angle -= PI / 3.0;
      }

      x = incX(point);
      y = incY(point);

      // The while statement is to keep the coordinates
      // inside the canvas. Although this sometimes
      // breaks the "pure" hexagonal pattern because
      // the angle will change by more than 60 deg.
      // That's ok since it makes the pattern more
      // interesting I think.
    } while(
          point.x + x > ranger.designSize.width
          || point.x + x < 0
          || point.y + y > ranger.designSize.height
          || point.y + y < 0);

      point.x += x;
      point.y += y;
      ctx.lineTo(point.x, point.y);
      ctx.stroke();
  }

  int incX(_Point point) {
    return (cos(point.angle) * minS / 25.0).round();
  }
  int incY(_Point point) {
    return (sin(point.angle) * minS / 25.0).round() * -1;
  }

}