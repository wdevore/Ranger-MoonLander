part of layer;

// Based on:
// http://codepen.io/MateiGCopot/pen/pJgreb

class Orbital {
  Random _randGen;
  SpinningStarsNode _node;

  double rad = 0.0;
  double r = 0.0;
  double speed = 0.0;

  Orbital(this._randGen, this._node, this.rad, this.r) {
    speed = ( _randGen.nextDouble() / 4.0 + 0.75 ) / 20.0;
  }

  double rand(double min, double max) {
    return _randGen.nextDouble() * ( max - min ) + min;
  }

  void update() {
    rad += speed * _node.Speed / 100.0;
    rad %= _node.tau;
  }

  void draw(CanvasRenderingContext2D ctx) {
    double radius = ( r + variation( _node.RadiusJitter ).abs() ) * _node.Scale;
    double hue = ( rad / _node.tau ) * 360.0 + variation( _node.HueJitter );

    if ( _node.ToggleOrbitals ) {
      ctx.lineWidth = 2;
      ctx.strokeStyle = _node.orbitalColorTemplate.replaceFirst( 'hue', "${hue}" );
      ctx.beginPath();
      ctx.arc( 0, 0, radius, rad - speed * 1.2, rad );
      ctx.stroke();
    }

    if ( _node.ToggleLight ) {
      ctx.lineWidth = 1;
      ctx.strokeStyle = _node.lightColorTemplate.replaceFirst( 'hue', "${hue}" );
      ctx.beginPath();
      ctx.moveTo( 0, 0 );
      ctx.lineTo( cos( rad ) * radius, sin( rad ) * radius );
      ctx.stroke();
    }
  }

  variation( value ) {
    //just a quick utility function
    return _randGen.nextDouble() * value - value / 2.0;
  }

}