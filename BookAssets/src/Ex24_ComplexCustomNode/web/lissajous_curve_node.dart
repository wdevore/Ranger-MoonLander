part of layer;

// Based on:
// http://codepen.io/DonKarlssonSan/pen/KpdeYb

class LissajousCurveNode extends Ranger.Node {
  Ranger.Color4<int> fillColor = Ranger.Color4IOrange;

  /////////////////////////
  // Lissajous variables //
  /////////////////////////
  // We only care about a revolution: 0 - 2π
  // But since I'm lazy, I let t just increase.
  double t = 0.0;
  double A = 250.0;
  double B = 250.0;
  double a = 5.0;
  double b = 6.0;
  double d = PI / 2.0; // δ
  // A point somewhere along the curve
  double x = 0.0;
  double y = 0.0;


//  Another point along the curve, π/2 ahead.
  double x0 = 0.0;
  double y0 = 0.0;
  bool drawCurves = false;

  int width = 580;
  int height = 580;

  Random _randGen = new Random();

  void toggleCurve() {
    drawCurves = !drawCurves;
  }

  double randomWithMax (double max) {
    return _randGen.nextDouble() * max;
  }

  void random() {
    a = randomWithMax(10.0) + 1.0;
    b = randomWithMax(10.0) + 1.0;
  }

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D ctx = context.renderContext as CanvasRenderingContext2D;

    // By using a low alpha value,
    // we leave trails behind. The smaller the alpha the longer the trails.
    ctx.fillStyle = "rgba(0, 0, 0, 0.04)";

    ctx.fillRect(0, 0, width, height);

    t += 0.01;

    x0 = A * sin(a * (t + PI / 2.0) + d) + width / 2.0;
    y0 = B * sin(b * (t + PI / 2.0)) + height / 2.0;
    x = A * sin(a * t + d) + width / 2.0;
    y = B * sin(b * t) + height / 2.0;

    ctx.strokeStyle = "hsla(${(t * 100.0).floor()}, 90%, 50%, 1)";
    ctx.lineWidth = 3;

    ctx.beginPath();
    ctx.moveTo(x0, y0);
    ctx.lineTo(x, y);
    ctx.stroke();

    if (drawCurves) {
      ctx.strokeStyle = "rgba(64, 64, 64, 0.3)";
      ctx.lineWidth = 1;
      ctx.beginPath();
      for(var t2 = 0; t2 < PI * 2.0; t2 += 0.001) {
        x = A * sin(a * t2 + d) + width / 2;
        y = B * sin(b * t2) + height / 2;
        ctx.lineTo(x, y);
      }
      ctx.stroke();
    }

  }
}