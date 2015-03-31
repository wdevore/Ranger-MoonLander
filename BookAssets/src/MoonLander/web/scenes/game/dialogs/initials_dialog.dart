part of moonlander;

/**
 * base modal dialog class.
 */
class InitialsDialog extends BaseHtmlDialog with UTE.Tweenable {
  static const int TWEEN_X = 1;
  static const int TINT = 2;

  InputElement initialInput;

  double width = 100.0;
  double height = 100.0;
  double outlineWidth = 1.0;

  // Red component of Input field
  int redComponent;

  int centerXOffset = 0;
  int outOfViewX = 0;
  LabelElement text;

  RegExp exp = new RegExp(r"(^[A-Za-z]{2,3})+$");

  InitialsDialog() {
    content.id = "initials_dialog_modalContent";
  }

  String get value => initialInput.value;

  void _configure() {
    if (_built)
      return;

    HtmlElement surface = ranger.surface;
    HtmlElement canvas = ranger.canvas;

    int surfaceWidth = surface.clientWidth;
    int surfaceHeight = surface.clientHeight;

    // Remove any old html.
    surface.nodes.remove(content);

    // If the canvas is narrower than the surface then we need to calc
    // the inset distance. This can occur on desktops where the browser
    // is sized larger than the design-view.
    int canvasXInset = (surfaceWidth - canvas.clientWidth) ~/ 2.0;
    centerXOffset = ((canvas.clientWidth) - width) ~/ 2.0 + canvasXInset;

    int canvasYInset = (surfaceHeight - canvas.clientHeight) ~/ 2.0;
    int centerYOffset = ((canvas.clientHeight) - height) ~/ 2.0 + canvasYInset;
    outOfViewX = (-width - outlineWidth).toInt();

    // Note: The DIV's positioning is in HTML space which means the
    // coordinate system is right-handed (aka +Y axis is downward).
    content.style
      ..left = "${outOfViewX}px"
      ..top = "${centerYOffset}px"
      ..width = "${width.toInt()}px"
      ..height = "${height.toInt()}px";
    // Set the background color to a brownish pantone color.
    // http://damonbauer.github.io/Pantone-Sass/

    surface.nodes.add(content);

    _addComponents();

    _built = true;
  }

  void _addComponents() {
    // Text
    DivElement textContent = new DivElement()
      ..id = "initials_dialog_textContent"
      ..text = ""
      ..style.width = "${width - (width * 0.95)}";

    text = new LabelElement()
      ..id = "initial_dialog_text1"
      ..text = "Nice!";
    textContent.nodes.add(text);

    LabelElement text2 = new LabelElement()
      ..text = "You made it onto the score board!"
               " Enter at least 2 or 3 initial letters.";
    textContent.nodes.add(text2);

    initialInput = new InputElement()
      ..id = "initial_dialog_input"
      ..value = ""
      ..maxLength = 3;

    DivElement buttonContainer = new DivElement()
      ..id = "initial_dialog_buttonContainer";

    SpanElement okayButton = new SpanElement()
      ..id = "initial_dialog_okayButton"
      ..text = "Okay";

    okayButton.onClick.listen(
        (Event e) => _validate(initialInput.value)
      );
    okayButton.onMouseEnter.listen(
        (Event e) =>
        okayButton.style.color = Ranger.color4IFromHex("#dddddd").toString()
      );
    okayButton.onMouseLeave.listen(
        (Event e) =>
        okayButton.style.color = Ranger.color4IFromHex("#222222").toString()
      );
    buttonContainer.nodes.add(okayButton);

    content.nodes.add(textContent);
    content.nodes.add(initialInput);
    content.nodes.add(buttonContainer);
  }

  void _validate(String value) {

    Match m = exp.firstMatch(value);
    if (m == null) {
      gm.playSound(gm.inCorrectSoundId);
      // Tint text box
      _tintAnimation();
    }
    else {
      gm.playSound(gm.clickSoundId);
      // Dismiss dialog
      hide();
      MessageData md = new MessageData();
      md.actionData = MessageData.HIDE;
      md.whatData = MessageData.DIALOG;
      md.data = "InitialsEntered";
      md.choice = MessageData.UNKNOWN;
      ranger.eventBus.fire(md);
    }
  }

  void _tintAnimation() {
    initialInput.style.backgroundColor = Ranger.Color4IWhite.toString();
    redComponent = 255;
    UTE.Tween tw = new UTE.Tween.to(this, TINT, 0.05)
      ..targetValues = [0]
      ..repeatYoyo(6, 0.0)
      ..easing = UTE.Sine.IN
      ..callback = _tintComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE;

    ranger.animations.add(tw);
  }

  void _tintComplete(int type, UTE.BaseTween source) {
    switch(type) {
      case UTE.TweenCallback.COMPLETE:
        initialInput.style.backgroundColor = Ranger.Color4IWhite.toString();
        break;
    }
  }

  @override
  void hide() {
    UTE.Tween tw = new UTE.Tween.to(this, TWEEN_X, 0.25)
      ..targetValues = [outOfViewX]
      ..easing = UTE.Cubic.OUT
      ..callback = _hideComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE;

    ranger.animations.add(tw);
  }

  void _hideComplete(int type, UTE.BaseTween source) {
    switch(type) {
      case UTE.TweenCallback.COMPLETE:
        content.style.visibility = "hidden";
        break;
    }
  }

  @override
  void show() {
    _configure();
    content.style.visibility = "visible";

    UTE.Tween tw = new UTE.Tween.to(this, TWEEN_X, 0.5)
      ..targetValues = [centerXOffset]
      ..easing = UTE.Cubic.OUT;

    ranger.animations.add(tw);

  }

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case TWEEN_X:
        int pos = content.style.left.indexOf("p");
        returnValues[0] = double.parse(content.style.left.substring(0, pos));
        return 1;
      case TINT:
        returnValues[0] = redComponent.toDouble();
        return 1;
    }
    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case TWEEN_X:
        content.style.left = "${newValues[0].toInt()}px";
        break;
      case TINT:
        initialInput.style.backgroundColor = "rgba(${newValues[0].toInt()}, 0, 0, 1.0)";
        break;
    }
  }

}

