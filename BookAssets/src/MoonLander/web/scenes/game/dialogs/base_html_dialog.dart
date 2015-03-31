part of moonlander;

/**
 * base modal dialog class.
 */
abstract class BaseHtmlDialog {
  final DivElement _content;

  bool _built = false;

  BaseHtmlDialog() :
    _content = new DivElement()
  {
    _content.id = "defaultDialogStyle";
  }

  DivElement get content => _content;

  void hide();

  void show();
}

