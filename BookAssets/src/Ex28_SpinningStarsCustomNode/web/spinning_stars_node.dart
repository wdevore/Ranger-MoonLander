part of layer;

// Based on:
// http://codepen.io/MateiGCopot/pen/vOLBVy

class SpinningStarsNode extends Ranger.Node {

  int TotalOrbitals = 100;
  // Ranger's default coordinate system is opposite of the original codepen.
  double Speed = -65.0;
  double Scale = 2.0;
  double RadiusJitter = 0.0;
  double HueJitter = 0.0;
  double ClearAlpha = 10.0;
  bool ToggleOrbitals = true;
  int OrbitalAlpha = 100;
  bool ToggleLight = true;
  int LightAlpha = 5;

  double centerX = 0.0;
  double centerY = 0.0;

  double tau = PI * 2.0;

  String colorTemplate = 'hsla(hue, 80%, 50%, alp)';
  String orbitalColorTemplate = "";
  String lightColorTemplate = "";

  int w = 0;
  int h = 0;

  List<Orbital> orbitals = new List<Orbital>();

  Random _randGen = new Random();

  SpinningStarsNode() {
    init();
    w = ranger.designSize.width.toInt();
    h = ranger.designSize.height.toInt();

    centerX = w / 2.0;
    centerY = h / 2.0;

    rebuild();
  }

  void rebuild() {
    orbitals.clear();
    for(int i = 0; i < TotalOrbitals; ++i ) {
      orbitals.add( new Orbital(_randGen, this, _randGen.nextDouble() * tau, i * 3.0 ) );
    }
  }

  @override
  void draw(Ranger.DrawContext context) {

    CanvasRenderingContext2D ctx = context.renderContext as CanvasRenderingContext2D;

    ctx.fillStyle = "rgba(0, 0, 0, ${ClearAlpha / 100.0})";
    ctx.fillRect( 0, 0, w, h );

    ctx.globalCompositeOperation = 'lighter';
    ctx.translate( centerX, centerY );

    updateTemplates();
    orbitals.forEach((Orbital o) => o.update());
    orbitals.forEach((Orbital o) => o.draw(ctx));

    ctx.translate( -centerX, -centerY );
    ctx.globalCompositeOperation = 'source-over';
  }

  void updateTemplates() {
    orbitalColorTemplate = colorTemplate.replaceFirst( 'alp', "${OrbitalAlpha / 100.0}" );
    lightColorTemplate = colorTemplate.replaceFirst( 'alp', "${LightAlpha / 100.0}" );
  }

}