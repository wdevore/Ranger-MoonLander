part of layer;

class _rect {
  double x = 0.0;
  double y = 0.0;
  double width = 0.0;
  double height = 0.0;
  double rotation = 0.0;
}

class ComplexArtNode extends Ranger.Node {

  _rect rect = new _rect();
  int tick = 0;

  double width = 0.0;
  double height = 0.0;

  ComplexArtNode() {
    init();
  }

  @override
  void onEnter() {
    super.onEnter();

    rect.width = 80.0;
    rect.height = 80.0;
    rect.x = ranger.designSize.height / 1.0;
    rect.y = ranger.designSize.width / 1.0;

    width = 2000.0;
    height = 2000.0;

    scheduleUpdate();
  }

  @override
  void update(double dt) {
    rect.y = height / 2 + sin( tick / 20 ) * 175;
    rect.rotation = cos( tick / 40 ) * PI * 0.5;
    tick++;
  }

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D ctx = context.renderContext as CanvasRenderingContext2D;

    ctx.save();
    ctx.lineWidth = 5;

    ctx.translate( ranger.designSize.width / 2, ranger.designSize.height / 2 );
    ctx.rotate( tick / 40 );

    ctx.translate( -height / 2, -width / 2 );
    ctx.fillStyle = '#f34';
    ctx.fillRect( -width / 2, height / 2 , width * 2, height * 2 );

    ctx.save();
    ctx.translate( rect.x, rect.y );
    ctx.rotate( rect.rotation );
    ctx.fillStyle = '#f34';
    ctx.fillRect( -rect.width / 2, -rect.height / 2, rect.width, rect.height );
    ctx.strokeStyle = '#333';
    ctx.strokeRect( -rect.width / 2, -rect.height / 2, rect.width, rect.height );
    ctx.restore();

    ctx.save();
    ctx.translate( rect.x, height - rect.y );
    ctx.rotate( -rect.rotation );
    ctx.fillStyle = '#333';
    ctx.fillRect( -rect.width / 2, -rect.height / 2, rect.width, rect.height );
    ctx.strokeStyle = '#f34';
    ctx.strokeRect( -rect.width / 2, -rect.height / 2, rect.width, rect.height );
    ctx.restore();

    ctx.restore();

  }
}