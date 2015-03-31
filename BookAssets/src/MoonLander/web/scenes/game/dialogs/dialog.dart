part of moonlander;

abstract class Dialog extends Ranger.BackgroundLayer with UTE.Tweenable  {
  void show();
  void hide();
  void focus(bool b);
}