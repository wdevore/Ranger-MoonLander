part of layer;

/**
 * base modal dialog class.
 */
class ControlPanel implements UTE.Tweenable {
  static const int MOVE_Y = 1;

  bool isShowing = false;
  bool isTransitioningIn = true;

  RangeInputElement _totalCircleCount;
  LabelElement _totalCircleCountValue;

  RangeInputElement _hueStart;
  LabelElement _hueStartValue;

  RangeInputElement _hueEnd;
  LabelElement _hueEndValue;

  RangeInputElement _hueChange;
  LabelElement _hueChangeValue;

  RangeInputElement _minSize;
  LabelElement _minSizeValue;

  RangeInputElement _maxSize;
  LabelElement _maxSizeValue;

  RangeInputElement _speed;
  LabelElement _speedValue;

  RangeInputElement _minGlowTime;
  LabelElement _minGlowTimeValue;

  RangeInputElement _maxGlowTime;
  LabelElement _maxGlowTimeValue;

  RangeInputElement _glowSize;
  LabelElement _glowSizeValue;

  RangeInputElement _repaintAlpha;
  LabelElement _repaintAlphaValue;

  RangeInputElement _spawnChance;
  LabelElement _spawnChanceValue;

  DivElement _panel;
  DivElement _panelOpenClose;

  int panelHeight = 390;
  int buttonHeight = 30;
  int slideDistance = 0;

  ControlPanel();

  void build() {
    _totalCircleCount = querySelector("#totalCircleCount")
      ..onInput.listen(
            (Event event) => _sliderTotalCount()
      );
    _totalCircleCountValue = querySelector("#totalCircleCountValue");

    _hueStart = querySelector("#hueStart")
      ..onInput.listen(
            (Event event) => _sliderHueStart()
    );
    _hueStartValue = querySelector("#hueStartValue");

    _hueEnd = querySelector("#hueEnd")
      ..onInput.listen(
            (Event event) => _sliderHueEnd()
    );
    _hueEndValue = querySelector("#hueEndValue");

    _hueChange = querySelector("#hueChange")
      ..onInput.listen(
            (Event event) => _sliderChangeEnd()
    );
    _hueChangeValue = querySelector("#hueChangeValue");

    _minSize = querySelector("#minSize")
      ..onInput.listen(
            (Event event) => _sliderMinSize()
    );
    _minSizeValue = querySelector("#minSizeValue");

    _maxSize = querySelector("#maxSize")
      ..onInput.listen(
            (Event event) => _sliderMaxSize()
    );
    _maxSizeValue = querySelector("#maxSizeValue");

    _speed = querySelector("#speed")
      ..onInput.listen(
            (Event event) => _sliderSpeed()
    );
    _speedValue = querySelector("#speedValue");

    _minGlowTime = querySelector("#minGlowTime")
      ..onInput.listen(
            (Event event) => _sliderMinGlowTime()
    );
    _minGlowTimeValue = querySelector("#minGlowTimeValue");

    _maxGlowTime = querySelector("#maxGlowTime")
      ..onInput.listen(
            (Event event) => _sliderMaxGlowTime()
    );
    _maxGlowTimeValue = querySelector("#maxGlowTimeValue");

    _glowSize = querySelector("#glowSize")
      ..onInput.listen(
            (Event event) => _sliderGlowSize()
    );
    _glowSizeValue = querySelector("#glowSizeValue");

    _repaintAlpha = querySelector("#repaintAlpha")
      ..onInput.listen(
            (Event event) => _sliderRepaintAlpha()
    );
    _repaintAlphaValue = querySelector("#repaintAlphaValue");

    _spawnChance = querySelector("#spawnChance")
      ..onInput.listen(
            (Event event) => _sliderSpawnChance()
    );
    _spawnChanceValue = querySelector("#spawnChanceValue");

    // ---------------------------------------------------------------------------
    _panel = querySelector("#controlPanel");
    slideDistance = panelHeight - buttonHeight;
    // We have to actually set the "top" here because
    // it is blank during creation.
    _panel.style.top = "${-slideDistance}px";

    _panelOpenClose = querySelector("#controlPanel_button")
      ..onClick.listen(
            (Event event) => _openClose()
      );

    _panel.style.visibility = "visible";
  }

  void _sliderSpawnChance() {
    int v = int.parse(_spawnChance.value);
    double dv = v / 100.0;
    _spawnChanceValue.text = dv.toStringAsFixed(1);

    MessageData md = new MessageData()
      ..field = MessageData.SPAWNCHANCE
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderRepaintAlpha() {
    int v = int.parse(_repaintAlpha.value);
    double dv = v / 100.0;
    _repaintAlphaValue.text = dv.toStringAsFixed(1);

    MessageData md = new MessageData()
      ..field = MessageData.REPAINTALPHA
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderGlowSize() {
    int v = int.parse(_glowSize.value);
    double dv = v / 100.0;
    _glowSizeValue.text = dv.toStringAsFixed(1);

    MessageData md = new MessageData()
      ..field = MessageData.GLOWSIZE
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderMaxGlowTime() {
    _maxGlowTimeValue.text = _maxGlowTime.value;
    MessageData md = new MessageData()
      ..field = MessageData.MAXGLOWTIME
      ..data = _maxGlowTimeValue.text;
    ranger.eventBus.fire(md);
  }

  void _sliderMinGlowTime() {
    _minGlowTimeValue.text = _minGlowTime.value;
    MessageData md = new MessageData()
      ..field = MessageData.MINGLOWTIME
      ..data = _minGlowTimeValue.text;
    ranger.eventBus.fire(md);
  }

  void _sliderMaxSize() {
    _maxSizeValue.text = _maxSize.value;
    MessageData md = new MessageData()
      ..field = MessageData.MAXSIZE
      ..data = _maxSizeValue.text;
    ranger.eventBus.fire(md);
  }

  void _sliderMinSize() {
    _minSizeValue.text = _minSize.value;
    MessageData md = new MessageData()
      ..field = MessageData.MINSIZE
      ..data = _minSizeValue.text;
    ranger.eventBus.fire(md);
  }

  void _sliderSpeed() {
    int v = int.parse(_speed.value);
    double dv = v / 100.0;
    _speedValue.text = dv.toStringAsFixed(2);

    MessageData md = new MessageData()
      ..field = MessageData.SPEED
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderChangeEnd() {
    int v = int.parse(_hueChange.value);
    double dv = v / 100.0;
    _hueChangeValue.text = dv.toStringAsFixed(1);

    MessageData md = new MessageData()
      ..field = MessageData.HUECHANGE
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderHueEnd() {
    _hueEndValue.text = _hueEnd.value;
    MessageData md = new MessageData()
      ..field = MessageData.HUEEND
      ..data = _hueEndValue.text;
    ranger.eventBus.fire(md);
  }

  void _sliderHueStart() {
    _hueStartValue.text = _hueStart.value;
    MessageData md = new MessageData()
      ..field = MessageData.HUESTART
      ..data = _hueStartValue.text;
    ranger.eventBus.fire(md);
  }

  void _sliderTotalCount() {
    _totalCircleCountValue.text = _totalCircleCount.value;
    MessageData md = new MessageData()
      ..field = MessageData.TOTALCIRCLECOUNT
      ..data = _totalCircleCountValue.text;
    ranger.eventBus.fire(md);
  }

  void _openClose() {
    if (isShowing) {
      _panelOpenClose.text = "Open Controls";
      hide();
    }
    else {
      _panelOpenClose.text = "Close Controls";
      show();
    }
    isShowing = !isShowing;
  }

  // ----------------------------------------------------------------
  // Animation
  // ----------------------------------------------------------------
  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case MOVE_Y:
        int pos = _panel.style.top.indexOf("p");
        returnValues[0] = double.parse(_panel.style.top.substring(0, pos));
        return 1;
    }

    return 0;
  }

  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case MOVE_Y:
        _panel.style.top = "${newValues[0]}px";
        break;
    }
  }

  void hide() {
    UTE.Tween tw = new UTE.Tween.to(this, MOVE_Y, 0.5)
      ..targetRelative = [-slideDistance]
      ..easing = UTE.Cubic.OUT;
    ranger.animations.add(tw);
  }

  void show() {
    UTE.Tween tw = new UTE.Tween.to(this, MOVE_Y, 0.5)
      ..targetRelative = [slideDistance]
      ..easing = UTE.Cubic.OUT;
    ranger.animations.add(tw);
  }

}

