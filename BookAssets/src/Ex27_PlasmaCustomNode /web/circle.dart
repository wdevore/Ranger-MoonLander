part of layer;

// Based on:
// http://codepen.io/MateiGCopot/pen/pJgreb

class Circle {
  Random _randGen;
  PlasmaNode _node;

  double size = 0.0;
  double x = 0.0;
  double y = 0.0;

  double  glowTime = 0.0;
  double glow = 0.0;
  double glowDirection = 0.0;

  int hue = 0;
  String color = "";
  String shadowColor = "";

  bool _initialized = false;
  bool dead = false;

  CanvasGradient gradient;

  Circle(this._randGen, this._node) {
    reset();
  }

  double rand(double min, double max) {
    return _randGen.nextDouble() * ( max - min ) + min;
  }

  void reset() {
    size = rand(_node.minSize, _node.maxSize);

    x = _node.w + size;
    y = _randGen.nextDouble() * _node.h;

    glowTime = rand(_node.minGlowTime, _node.maxGlowTime);
    glow = _randGen.nextDouble();
    glowDirection = _randGen.nextDouble() < .5 ? 1 / glowTime : -1 / glowTime;

    int d = _node.hueEnd - _node.hueStart;
    if (d > 0)
      hue = (( ( _node.frame ) % ( _node.hueEnd - _node.hueStart ) ) + _node.hueStart).toInt();
    else
      hue = (( ( _node.frame ) % ( 1 ) ) + _node.hueStart).toInt();
    shadowColor = "hsla($hue, 80%, 50%, 1.0)";
  }

  void step(CanvasRenderingContext2D ctx) {
    update();
    render(ctx);
  }

  void update() {
    x -= size * _node.speed;
    glow += glowDirection;
    if (glow > 1 || glow < 0) glowDirection *= -1;

    if (glow < 0) glow = .1;

    if (x + size < 0)
      if (_node.totalCircleCount > _node.circles.length)
        reset();
      else
        dead = true;
  }

  void render(CanvasRenderingContext2D ctx) {
    if (!_initialized) {
      _initialized = true;
      gradient = ctx.createRadialGradient(0, 0, 0, 0, 0, size);
      gradient.addColorStop(0, "hsla($hue, 80%, 50%, 0.1)");
      gradient.addColorStop(.8, "hsla($hue, 80%, 50%, 0.2)");
      gradient.addColorStop(1, "hsla($hue, 80%, 50%, 0.8)");
    }

    ctx.shadowBlur = glow * _node.glowSize * size;
    ctx.fillStyle = gradient;
    ctx.shadowColor = shadowColor;

    ctx.translate(x, y);
    ctx.beginPath();
    ctx.arc(0, 0, size, 0, PI * 2.0);
    ctx.fill();
    ctx.translate(-x, -y);
  }
}