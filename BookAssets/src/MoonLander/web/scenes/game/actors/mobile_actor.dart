part of moonlander;

abstract class MobileActor {
  Ranger.MutableRectangle<double> rect = new Ranger.MutableRectangle<double>(0.0, 0.0, 0.0, 0.0);

  Ranger.MutableRectangle<double> calcAABBox();
}
