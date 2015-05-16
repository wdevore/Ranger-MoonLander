part of layer;

// Based on:
// http://codepen.io/MateiGCopot/pen/pJgreb

class PlasmaNode extends Ranger.Node {

  int totalCircleCount = 50;
  int hueStart = 0;
  int hueEnd = 50;
  double hueChange = 1.0;
  double minSize = 20.0;
  double maxSize = 50.0;
  double speed = 0.05;
  double minGlowTime = 20.0;
  double maxGlowTime = 50.0;
  double glowSize = 1.5;
  double repaintAlpha = 0.8;
  double spawnChance = 0.2;

  int w = 0;
  int h = 0;

  double frame = 0.0;

  List<Circle> circles = new List<Circle>();

  Random _randGen = new Random();

  PlasmaNode() {
    init();
    w = ranger.designSize.width.toInt();
    h = ranger.designSize.height.toInt();
  }

  @override
  void draw(Ranger.DrawContext context) {

    if( circles.length < totalCircleCount && _randGen.nextDouble() < spawnChance )
      circles.add( new Circle(_randGen, this) );

    CanvasRenderingContext2D ctx = context.renderContext as CanvasRenderingContext2D;

    ctx.shadowBlur = 0;
    ctx.globalCompositeOperation = 'source-over';
    ctx.fillStyle = "rgba(0, 0, 0, $repaintAlpha)";
    ctx.fillRect( 0, 0, w, h );
    ctx.globalCompositeOperation = 'lighter';

    frame += hueChange;

    for (Circle cr in circles.skipWhile((Circle c) => c.dead))
      cr.step(ctx);

    circles.removeWhere((Circle c) => c.dead);

  }
}