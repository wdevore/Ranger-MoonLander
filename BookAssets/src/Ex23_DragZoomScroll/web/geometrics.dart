part of layer;

class Intersect {
  static int PREEVAL = 0;
  static int INCIDENT = 1;
  static int PARALLEL = 2;
  static int UNDEFINED = 3;
  static int INTERSECTED = 4;
  double x;
  double y;
  int type = -1;
}

class Geometrics {
  static double _stx = 0.0;
  static double _sty = 0.0;
  static double EPSILON = 0.0000001192092896;

  static Intersect I = new Intersect();

  static Intersect segmentIntersect(double Ax, double Ay, double Bx, double By,
                              double Cx, double Cy, double Dx, double Dy) {

    int result = lineIntersect(
        Ax, Ay, Bx, By,
        Cx, Cy, Dx, Dy);

    I.type = result;

    if (result == Intersect.PREEVAL
        && (_stx >= 0.0 && _stx <= 1.0 && _sty >= 0.0 && _sty <= 1.0)) {
      // Point of intersection
      I.x = Ax + _stx * (Bx - Ax);
      I.y = Ay + _stx * (By - Ay);
      I.type = Intersect.INTERSECTED;
    }

    return I;
  }

  static int lineIntersect(double Ax, double Ay, double Bx, double By,
                           double Cx, double Cy, double Dx, double Dy) {
    // FAIL: Line undefined
    if (((Ax == Bx) && (Ay == By)) || ((Cx == Dx) && (Cy == Dy))) {
      return Intersect.UNDEFINED;
    }
    double BAx = Bx - Ax;
    double BAy = By - Ay;
    double DCx = Dx - Cx;
    double DCy = Dy - Cy;
    double ACx = Ax - Cx;
    double ACy = Ay - Cy;

    double denom = (DCy * BAx) - (DCx * BAy);

    _stx = (DCx * ACy) - (DCy * ACx); // S
    _sty = (BAx * ACy) - (BAy * ACx); // T

    // Checking for denom == 0.0 isn't numerically stable so we use
    // epsilon.
    if (denom.abs() < EPSILON) {
      if (_stx == 0.0 || _sty == 0.0) {
        // Lines incident
        return Intersect.INCIDENT;
      }
      // Lines parallel and not incident
      return Intersect.PARALLEL;
    }

    _stx /= denom;
    _sty /= denom;

    return Intersect.PREEVAL;
  }

  static double distanceBetweenByDouble(double p0X, double p0Y, double p1X, double p1Y) {
    double dx = p0X - p1X;
    double dy = p0Y - p1Y;
    return sqrt(dx * dx + dy * dy);
  }

}