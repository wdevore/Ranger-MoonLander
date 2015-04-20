part of moonlander;

class SettingsDialog extends Dialog {
  static const int TWEEN_TRANSLATE_Y = 1;
  static const int TWEEN_FADE = 2;

  RoundRectangleNode _background;
  double _verticalSlideDistance = 0.0;
  
  ToggleButton _music;
  ToggleButton _sounds;
  ToggleButton _cloud;
  
  Ranger.SpriteImage _configured;
  Ranger.SpriteImage _reset;
  Ranger.TextNode _dareReset;
  
  RoundRectangleNode _blackoutOverlay;
  
  bool _enterExit = false;

  StreamSubscription<MessageData> _busStream;

  SettingsDialog();
 
  factory SettingsDialog.withSize([int width, int height]) {
    SettingsDialog layer = new SettingsDialog()
      ..init(width, height)
      ..autoInputs = false
      ..tag = 800
      ..transparentBackground = true;
    return layer;
  }

  @override
  bool init([int width, int height]) {
    if (super.init(width, height)) {
      _configure();
      _listenToBus();
    }
    
    return true;
  }

  void _listenToBus() {
    // Register for events on the message bus. The toggle buttons will
    // transmit their state.
    _busStream = ranger.eventBus.on(MessageData).listen(
    (MessageData md) {
      if (md.handled)
        return;
      
      switch(md.whatData) {
        case MessageData.BUTTON:
          if (md.actionData == MessageData.TOGGLED_ON) {
            if (md.data == "Music") {
              gm.resources.musicOn = true;
              md.handled = true;
            }
          }
          else if (md.actionData == MessageData.TOGGLED_OFF) {
            if (md.data == "Music") {
              gm.resources.musicOn = false;
              md.handled = true;
            }
          }
          
          if (md.actionData == MessageData.TOGGLED_ON) {
            if (md.data == "Sound") {
              gm.resources.soundOn = true;
              md.handled = true;
            }
          }
          else if (md.actionData == MessageData.TOGGLED_OFF) {
            if (md.data == "Sound") {
              gm.resources.soundOn = false;
              md.handled = true;
            }
          }

          if (md.actionData == MessageData.TOGGLED_ON) {
            if (md.data == "Cloud") {
              gm.resources.cloudOn = true;
              md.handled = true;
            }
          }
          else if (md.actionData == MessageData.TOGGLED_OFF) {
            if (md.data == "Cloud") {
              gm.resources.cloudOn = false;
              md.handled = true;
            }
          }

          break;
      }
    });
  }
  
  set backgroundColor(Ranger.Color4<int> c) => _background.fillColor = c.toString();
  set outlineColor(Ranger.Color4<int> c) => _background.outlineColor = c.toString();
  set cornerRadius(double r) => _background.cornerRadius = r;
  
  @override
  void onEnter() {
    // For dialogs we don't enable inputs here for two reasons; one we
    // don't need inputs until the dialog is shown and two it would
    // cause duplicate enablement causing multiple events to be generated.
    super.onEnter();

    double strokeGap = 3.0;
    double s = 1.5;

    double hh = ranger.designSize.height / s;
    double hw = ranger.designSize.width / s;
    double dw = ranger.designSize.width;
    //double dh = ranger.designSize.height;
    
    visible = false;

    // Both center and position the Dialog out of view.
    _verticalSlideDistance = hh + strokeGap;
    setPosition(dw - (dw / 2.0) - hw / 2.0, -_verticalSlideDistance);
  }

  @override
  void onExit() {
    super.onExit();
    if (_busStream != null) {
      _busStream.cancel();
    }
    ranger.animations.stopAndUntrack(_reset, Ranger.TweenAnimation.ROTATE);
  }

  @override
  bool onMouseDown(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_configured, event.offset.x, event.offset.y);

    if (_configured.pointInside(nodeP.v)) {
      nodeP.moveToPool();
      
      // Send message requesting "Settings", "Dialog" to hide.
      MessageData md = new MessageData();
      md.actionData = MessageData.HIDE;
      md.whatData = MessageData.DIALOG;
      md.data = "Settings";
      ranger.eventBus.fire(md);

      return true;
    }
    nodeP.moveToPool();

    nodeP = ranger.drawContext.mapViewToNode(_reset, event.offset.x, event.offset.y);

    if (_reset.pointInside(nodeP.v)) {
      nodeP.moveToPool();

      MessageData md = new MessageData();
      md.actionData = MessageData.SHOW;
      md.whatData = MessageData.DIALOG;
      md.data = "ConfirmReset";
      ranger.eventBus.fire(md);

      return true;
    }
    nodeP.moveToPool();
    
    // The buttons transmit on the EventBus. This class listens for them
    // in the _listenToBus method.
    bool clicked = _music.check(event.offset.x, event.offset.y);
    if (clicked)
        gm.playSound(gm.toggleSoundId);
    else {
      clicked = _sounds.check(event.offset.x, event.offset.y);
      if (clicked)
        gm.playSound(gm.toggleSoundId);
      else {
        clicked = _cloud.check(event.offset.x, event.offset.y);
        if (clicked)
          gm.playSound(gm.toggleSoundId);
      }
    }
    
    return clicked;
  }

  @override
  bool onMouseMove(MouseEvent event) {
    Ranger.Vector2P nodeP = ranger.drawContext.mapViewToNode(_reset, event.offset.x, event.offset.y);

    if (_reset.pointInside(nodeP.v)) {
      nodeP.moveToPool();
      
      if (!_enterExit) {
        _enterExit = true;
        // Shake pirate
        _shakeNode(_reset);
        
        _dareReset.opacity = 0;
        UTE.Tween fadeIn = new UTE.Tween.to(this, TWEEN_FADE, 3.0)
          ..targetValues = [255]
          ..easing = UTE.Cubic.OUT;
        ranger.animations.add(fadeIn);
        ranger.animations.track(this, TWEEN_FADE);
      }
      
      return true;
    }
    else {
      ranger.animations.flush(this);
      _dareReset.opacity = 0;
      _enterExit = false;
    }
    
    nodeP.moveToPool();

    return false;
  }
  
  void _configure() {
    _background = new RoundRectangleNode.basic(Ranger.Color4IRed)
      ..width = contentSize.width
      ..height = contentSize.height;
    addChild(_background);
    
    _configured = new Ranger.SpriteImage.withElement(gm.resources.configured)
      ..uniformScale = 3.0
      ..setPosition(contentSize.width - (contentSize.width * 0.09), contentSize.height - (contentSize.height * 0.1));
    addChild(_configured);
    
    Ranger.TextNode title = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "Settings"
      ..font = "normal 900 10px Verdana"
      ..shadows = true
      ..setPosition(380.0, contentSize.height - (contentSize.height * 0.13))
      ..uniformScale = 10.0;
    addChild(title);

    _music = new ToggleButton.basic(180.0, 75.0)
      ..backgroundFillColor = Ranger.Color4IOrange.toString()
      ..backgroundOutlineColor = Ranger.Color4IBlack.toString()
      ..trackFillColor = Ranger.Color4IGrey.toString()
      ..captionColor = Ranger.Color4IWhite
      ..caption = "Music"
      ..captionOffset.setValues(-230.0, 20.0)
      ..sliderRadius = 25.0
      ..sliderOffColor = Ranger.Color4IGreyBlue.toString()
      ..sliderOutlineColor = Ranger.Color4IBlack.toString()
      ..setPosition(contentSize.width - (contentSize.width * 0.2), contentSize.height - (contentSize.height * 0.35))
      ..construct();
    addChild(_music);

    _sounds = new ToggleButton.basic(180.0, 75.0)
      ..backgroundFillColor = Ranger.Color4IOrange.toString()
      ..backgroundOutlineColor = Ranger.Color4IBlack.toString()
      ..trackFillColor = Ranger.Color4IGrey.toString()
      ..captionColor = Ranger.Color4IWhite
      ..caption = "Sound"
      ..captionOffset.setValues(-230.0, 20.0)
      ..sliderRadius = 25.0
      ..sliderOffColor = Ranger.Color4IGreyBlue.toString()
      ..sliderOutlineColor = Ranger.Color4IBlack.toString()
      ..setPosition(contentSize.width - (contentSize.width * 0.2), contentSize.height - (contentSize.height * 0.50))
      ..construct();
    addChild(_sounds);
    
    _cloud = new ToggleButton.basic(180.0, 75.0)
      ..backgroundFillColor = Ranger.Color4IOrange.toString()
      ..backgroundOutlineColor = Ranger.Color4IBlack.toString()
      ..trackFillColor = Ranger.Color4IGrey.toString()
      ..captionColor = Ranger.Color4IWhite
      ..caption = "Cloud"
      ..captionOffset.setValues(-230.0, 20.0)
      ..sliderRadius = 25.0
      ..sliderOffColor = Ranger.Color4IGreyBlue.toString()
      ..sliderOutlineColor = Ranger.Color4IBlack.toString()
      ..setPosition(contentSize.width - (contentSize.width * 0.2), contentSize.height - (contentSize.height * 0.65))
      ..construct();
    addChild(_cloud);
    
    _reset = new Ranger.SpriteImage.withElement(gm.resources.skull)
      ..tag = 411
      ..uniformScale = 0.3
      ..setPosition(contentSize.width - (contentSize.width * 0.2), contentSize.height - (contentSize.height * 0.85));
    addChild(_reset);

    _dareReset = new Ranger.TextNode.initWith(Ranger.Color4IGoldYellow)
      ..tag = 412
      ..text = "Dare ye reset!"
      ..font = "normal 200 10px Verdana"
      ..opacity = 0
      ..setPosition(contentSize.width - (contentSize.width * 0.28), contentSize.height - (contentSize.height * 0.75))
      ..uniformScale = 3.0;
    addChild(_dareReset);
    
    Ranger.TextNode designLine1 = new Ranger.TextNode.initWith(Ranger.Color4IBlack)
      ..text = "Design, Code,"
      ..font = "normal 900 10px Verdana"
      ..setPosition(180.0, contentSize.height - (contentSize.height * 0.3))
      ..uniformScale = 5.0;
    addChild(designLine1);

    Ranger.TextNode designLine2 = new Ranger.TextNode.initWith(Ranger.Color4IBlack)
      ..text = "Art & Sounds"
      ..font = "normal 900 10px Verdana"
      ..setPosition(180.0, contentSize.height - (contentSize.height * 0.38))
      ..uniformScale = 5.0;
    addChild(designLine2);

    Ranger.TextNode designLine3 = new Ranger.TextNode.initWith(Ranger.Color4IOrange)
      ..text = "Will DeVore"
      ..font = "normal 900 10px Verdana"
      ..shadows = true
      ..setPosition(100.0, contentSize.height - (contentSize.height * 0.5))
      ..uniformScale = 8.0;
    addChild(designLine3);

    Ranger.TextNode designLine4 = new Ranger.TextNode.initWith(Ranger.Color4IBlack)
      ..text = "Thanks To:"
      ..font = "normal 900 10px Verdana"
      ..setPosition(200.0, contentSize.height - (contentSize.height * 0.65))
      ..uniformScale = 5.0;
    addChild(designLine4);

    Ranger.TextNode designLine5 = new Ranger.TextNode.initWith(Ranger.Color4IDartBlue)
      ..text = "Dart Team"
      ..font = "normal 900 10px Verdana"
      ..shadows = true
      ..setPosition(200.0, contentSize.height - (contentSize.height * 0.77))
      ..uniformScale = 5.0;
    addChild(designLine5);

    Ranger.TextNode designLine6 = new Ranger.TextNode.initWith(Ranger.Color4IWhite)
      ..text = "Copyright 2014 by Will DeVore"
      ..font = "normal 100 10px Verdana"
      ..setPosition(130.0, contentSize.height - (contentSize.height * 0.9))
      ..uniformScale = 3.0;
    addChild(designLine6);
    
    _blackoutOverlay = new RoundRectangleNode.basic(new Ranger.Color4<int>.withRGBA(0, 0, 0, 128))
      ..visible = false
      ..width = contentSize.width
      ..height = contentSize.height;
    addChild(_blackoutOverlay);

  }
  
  void _shakeNode(Ranger.BaseNode node) {
    // I am using an Immediately invoked Anonymous Closure 
    // to localize a variable rather creating a global variable.
    // In this case it is the initial position of the node being shaken.
    // originalPos could have been declared at the GameLayer level but
    // I didn't want the GameLayer littered with temporary objects just
    // for an animation.
    () {
      Ranger.Vector2P originalPos = new Ranger.Vector2P();
      ranger.animations.shake(
          node,
          0.5,
          2.0,
          (int type, UTE.BaseTween source) {
            switch(type) {
              case UTE.TweenCallback.BEGIN:
                Ranger.Node n = source.userData as Ranger.Node;
                originalPos.v.setFrom(n.position);
                break;
              case UTE.TweenCallback.END:
                Ranger.Node n = source.userData as Ranger.Node;
                n.position.setFrom(originalPos.v);
                originalPos.moveToPool();
                break;
            }
          }
      );
      ranger.animations.track(node, Ranger.TweenAnimation.SHAKE);
    }();
  }
  
  void _rockNode(Ranger.BaseNode node) {
    UTE.BaseTween wobbleCW = ranger.animations.rotateBy(
        node,
        2.0,
        -node.rotationInDegrees * 2.0,
        UTE.Quad.INOUT,
        null,
        false);
    
    wobbleCW.repeatYoyo(10000, 0.0);
    ranger.animations.track(node, Ranger.TweenAnimation.ROTATE);

    ranger.animations.add(wobbleCW, true);
  }

  void focus(bool b) {
    if (b) {
      enableMouse = true;
      _blackoutOverlay.visible = false;
      enableInputs();
    }
    else {
      _blackoutOverlay.visible = true;
      
      disableInputs();
    }
  }
  
  void reset() {
    _loadValues();
  }
  
  void _loadValues() {
    _music.on = gm.resources.isMusicOn;
    _sounds.on = gm.resources.isSoundOn;
    _cloud.on = gm.resources.isCloudOn;
  }
  
  void show() {
    // We enable mouse here instead of the onEnter method as we don't
    // want inputs enable until the dialog is shown not when it is
    // created.
    focus(true);
    visible = true;

    // Update widgets based on configuration
    _loadValues();
    
    // Slowly rock pirate
    _reset.rotationByDegrees = 10.0;
    _rockNode(_reset);
    
    ranger.animations.track(_reset, Ranger.TweenAnimation.ROTATE);
    
    UTE.Tween moveBy = new UTE.Tween.to(this, TWEEN_TRANSLATE_Y, 0.25)
      ..targetRelative = [_verticalSlideDistance]
      ..easing = UTE.Sine.OUT;
    ranger.animations.add(moveBy);
  }

  void hide() {
    focus(false);

    gm.resources.save();
    
    ranger.animations.stopAndUntrack(_reset, Ranger.TweenAnimation.ROTATE);

    UTE.Tween moveBy = new UTE.Tween.to(this, TWEEN_TRANSLATE_Y, 0.25)
      ..targetRelative = [-_verticalSlideDistance]
      ..callback = _hideComplete
      ..callbackTriggers = UTE.TweenCallback.COMPLETE
      ..easing = UTE.Sine.IN;
    ranger.animations.add(moveBy);
  }

  void _hideComplete(int type, UTE.BaseTween source) {
    visible = false;
  }

  int getTweenableValues(UTE.Tween tween, int tweenType, List<num> returnValues) {
    switch(tweenType) {
      case TWEEN_TRANSLATE_Y:
        returnValues[0] = position.y;
        return 1;
      case TWEEN_FADE:
        returnValues[0] = _dareReset.opacity;
        return 1;
    }
    return 0;
  }
  
  void setTweenableValues(UTE.Tween tween, int tweenType, List<num> newValues) {
    switch(tweenType) {
      case TWEEN_TRANSLATE_Y:
        setPosition(position.x, newValues[0]);
        break;
      case TWEEN_FADE:
        _dareReset.opacity = newValues[0].toInt();
        break;
    }
  }
}