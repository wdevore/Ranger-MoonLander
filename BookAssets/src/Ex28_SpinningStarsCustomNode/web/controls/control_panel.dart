part of layer;

/**
 * base modal dialog class.
 */
class ControlPanel implements UTE.Tweenable {
  static const int MOVE_Y = 1;

  bool isShowing = false;
  bool isTransitioningIn = true;

  RangeInputElement _totalOrbitals;
  LabelElement _totalOrbitalsValue;

  RangeInputElement _speed;
  LabelElement _speedValue;

  RangeInputElement _scale;
  LabelElement _scaleValue;

  RangeInputElement _radiusJitter;
  LabelElement _radiusJitterValue;

  RangeInputElement _hueJitter;
  LabelElement _hueJitterValue;

  RangeInputElement _clearAlpha;
  LabelElement _clearAlphaValue;

  CheckboxInputElement _toggleOrbitals;

  RangeInputElement _orbitalAlpha;
  LabelElement _orbitalAlphaValue;

  CheckboxInputElement _toggleLight;

  RangeInputElement _lightAlpha;
  LabelElement _lightAlphaValue;

  DivElement _clearButton;

  DivElement _panel;
  DivElement _panelOpenClose;

  int panelHeight = 345;
  int buttonHeight = 30;
  int slideDistance = 0;

  StreamSubscription<MessageData> _busStream;

  ControlPanel();

  void build() {
    _totalOrbitals = querySelector("#totalOrbitals")
      ..onInput.listen(
            (Event event) => _sliderTotalOrbitals()
      );
    _totalOrbitalsValue = querySelector("#totalOrbitalsValue");

    _speed = querySelector("#speed")
      ..onInput.listen(
            (Event event) => _sliderSpeed()
    );
    _speedValue = querySelector("#speedValue");

    _scale = querySelector("#scale")
      ..onInput.listen(
            (Event event) => _sliderScale()
    );
    _scaleValue = querySelector("#scaleValue");

    _radiusJitter = querySelector("#radiusJitter")
      ..onInput.listen(
            (Event event) => _sliderRadiusJitter()
    );
    _radiusJitterValue = querySelector("#radiusJitterValue");

    _hueJitter = querySelector("#hueJitter")
      ..onInput.listen(
            (Event event) => _sliderHueJitter()
    );
    _hueJitterValue = querySelector("#hueJitterValue");

    _clearAlpha = querySelector("#clearAlpha")
      ..onInput.listen(
            (Event event) => _sliderClearAlphaValue()
    );
    _clearAlphaValue = querySelector("#clearAlphaValue");

    _toggleOrbitals = querySelector("#toggleOrbitals")
      ..onChange.listen(
            (Event event) => _sliderToggleOrbitals()
    );

    _orbitalAlpha = querySelector("#orbitalAlpha")
      ..onInput.listen(
            (Event event) => _sliderOrbitalAlpha()
    );
    _orbitalAlphaValue = querySelector("#orbitalAlphaValue");

    _toggleLight = querySelector("#toggleLight")
      ..onChange.listen(
            (Event event) => _sliderToggleLight()
    );

    _lightAlpha = querySelector("#lightAlpha")
      ..onInput.listen(
            (Event event) => _sliderLightAlpha()
    );
    _lightAlphaValue = querySelector("#lightAlphaValue");

    _clearButton = querySelector("#controlPanel_clear")
      ..onClick.listen(
            (Event event) => _sliderControlPanel_clear()
    );

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

    _listenToBus();
  }

  void _listenToBus() {
    _busStream = ranger.eventBus.on(MessageData).listen(
      (MessageData md) {
        switch (md.field) {
          case MessageData.UPDATEGUI:
            double dv = md.complex.LightAlpha / 100.0;
            _lightAlphaValue.text = dv.toStringAsFixed(1);
            _lightAlpha.value = md.complex.LightAlpha.toString();

            _toggleLight.checked = md.complex.ToggleLight;
            _toggleOrbitals.checked = md.complex.ToggleOrbitals;

            _orbitalAlphaValue.text = md.complex.OrbitalAlpha.toString();
            _orbitalAlpha.value = md.complex.OrbitalAlpha.toString();

            _clearAlphaValue.text = md.complex.ClearAlpha.toStringAsFixed(0);
            _clearAlpha.value = md.complex.ClearAlpha.toString();

            _hueJitterValue.text = md.complex.HueJitter.toStringAsFixed(0);
            _hueJitter.value = md.complex.HueJitter.toString();

            _radiusJitterValue.text = md.complex.RadiusJitter.toStringAsFixed(1);
            _radiusJitter.value = md.complex.RadiusJitter.toString();

            dv = md.complex.Scale * 100.0;
            _scaleValue.text = md.complex.Scale.toStringAsFixed(1);
            _scale.value = dv.toString();

            dv = -md.complex.Speed + 300.0;
            _speedValue.text = (-md.complex.Speed).toStringAsFixed(0);
            _speed.value = dv.toString();

            break;
        }
      });
  }

  void _sliderControlPanel_clear() {
    MessageData md = new MessageData()
      ..field = MessageData.RESET;
    ranger.eventBus.fire(md);
  }

  void _sliderLightAlpha() {
    int v = int.parse(_lightAlpha.value);
    double dv = v / 100.0;
    _lightAlphaValue.text = dv.toStringAsFixed(1);

    MessageData md = new MessageData()
      ..field = MessageData.LIGHTALPHA
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderToggleLight() {
    MessageData md = new MessageData()
      ..field = MessageData.TOGGLELIGHT
      ..data = _toggleLight.checked ? "Y" : "N";
    ranger.eventBus.fire(md);
  }

  void _sliderOrbitalAlpha() {
    int v = int.parse(_orbitalAlpha.value);
    double dv = v / 100.0;
    _orbitalAlphaValue.text = dv.toStringAsFixed(1);

    MessageData md = new MessageData()
      ..field = MessageData.ORBITALALPHA
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderToggleOrbitals() {
    MessageData md = new MessageData()
      ..field = MessageData.TOGGLEORBITALS
      ..data = _toggleOrbitals.checked ? "Y" : "N";
    ranger.eventBus.fire(md);
  }

  void _sliderClearAlphaValue() {
    _clearAlphaValue.text = _clearAlpha.value;
    MessageData md = new MessageData()
      ..field = MessageData.CLEARALPHA
      ..data = _clearAlphaValue.text;
    ranger.eventBus.fire(md);
  }

  void _sliderSpeed() {
    int v = int.parse(_speed.value) - 300;
    double dv = v / 100.0;
    _speedValue.text = (v).toString();

    MessageData md = new MessageData()
      ..field = MessageData.SPEED
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderHueJitter() {
    int v = int.parse(_hueJitter.value);
    double dv = v / 100.0;
    _hueJitterValue.text = v.toStringAsFixed(0);

    MessageData md = new MessageData()
      ..field = MessageData.HUEJITTER
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderRadiusJitter() {
    int v = int.parse(_radiusJitter.value);
    double dv = v / 100.0;
    _radiusJitterValue.text = dv.toStringAsFixed(1);

    MessageData md = new MessageData()
      ..field = MessageData.RADIUSJITTER
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderScale() {
    int v = int.parse(_scale.value);
    double dv = v / 100.0;
    _scaleValue.text = dv.toStringAsFixed(1);

    MessageData md = new MessageData()
      ..field = MessageData.SCALE
      ..data = v.toString();
    ranger.eventBus.fire(md);
  }

  void _sliderTotalOrbitals() {
    _totalOrbitalsValue.text = _totalOrbitals.value;
    MessageData md = new MessageData()
      ..field = MessageData.TOTALORBITALS
      ..data = _totalOrbitalsValue.text;
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

