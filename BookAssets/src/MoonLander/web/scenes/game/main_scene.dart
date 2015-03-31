part of moonlander;

class MainScene extends Ranger.AnchoredScene {
  Ranger.GroupNode _group;
  
  SettingsDialog _settingsDialog;
  ResetPopupDialog _resetConfirmDialog;

  MainLayer _mainLayer;
  RectangleNode _blackout;

  StreamSubscription<MessageData> _busStream;

  MainScene([int tag = 0]) {
    this.tag = tag;
    name = "MainScene";
  }

  @override
  void onEnter() {
    super.onEnter();
    
    if (_group == null) {
      double dw = ranger.designSize.width;
      double dh = ranger.designSize.height;

      _group = new Ranger.GroupNode();
      initWithPrimary(_group);

      _mainLayer = new MainLayer.withColor(Ranger.color4IFromHex("#4b4f54"));
      addLayer(_mainLayer);
      
      // Node to dim the background layer when dialog visible.
      _blackout = new RectangleNode.basic(new Ranger.Color4<int>.withRGBA(0, 0, 0, 128));
      _blackout.centered = false;
      _blackout.visible = false;
      _blackout.scaleX = dw;
      _blackout.scaleY = dh;
      _blackout.setPosition(0.0, dh / 2.0);
      addNode(_blackout);

      // Dialogs and Popups
      double s = 1.5;

      double hh = ranger.designSize.height / s;
      double hw = ranger.designSize.width / s;
      
      _settingsDialog = new SettingsDialog.withSize(hw.toInt(), hh.toInt());
      _settingsDialog.backgroundColor = Ranger.color4IFromHex("#866761");
      _settingsDialog.outlineColor = Ranger.color4IFromHex("#e4d5d3");
      
      // Scenes are not centered and thus their origin is in the
      // lower-left corner. Keep this in mind when positioning the
      // dialog.
      _settingsDialog.hide();

      addLayer(_settingsDialog);
      
      //---------------------------------------------------------------
      // A layer that overlays on top of the all other layers. For example, FPS.
      //---------------------------------------------------------------
      HudLayer hudLayer = new HudLayer.asTransparent(true);
      addLayer(hudLayer);
    }

    _listenToBus();

    // Reset Scene's position just incase it was animated by a Transition
    setPosition(0.0, 0.0);
  }

  @override
  void onExit() {
    super.onExit();
    if (_busStream != null) {
      _busStream.cancel();
    }
  }

  void _listenToBus() {
    double dw = ranger.designSize.width;
    double dh = ranger.designSize.height;

    // Register for events on the message bus. The main layer and
    // dialog will transmit on it.
    _busStream = ranger.eventBus.on(MessageData).listen(
    (MessageData md) {
      switch(md.whatData) {
        case MessageData.DIALOG:
          if (md.actionData == MessageData.SHOW) {
            if (md.data == "Settings") {
              gm.playSound(gm.slideInSoundId);
              focus(false);
              _settingsDialog.show();
              _blackout.visible = true;
            }
            else if (md.data == "ConfirmReset") {
              gm.playSound(gm.popupSoundId);
              _settingsDialog.focus(false);
              _resetConfirmDialog = new ResetPopupDialog.withSize((dw * 0.5).toInt(), (dh * 0.5).toInt());
              addChild(_resetConfirmDialog);
              _resetConfirmDialog..setMessage("Well now...", 1, 10.0, -400.0, 200.0, Ranger.Color4IOrange)
                ..setMessage("It seems you have a hankering to", 2, 5.0, -400.0, 100.0, Ranger.Color4IWhite)
                ..setMessage("expunge your \"questionable\" landing", 3, 5.0, -400.0, 30.0, Ranger.Color4IWhite)
                ..setMessage("records. Your secret is safe with me.", 4, 5.0, -400.0, -40.0, Ranger.Color4IWhite)
                ..acceptCaption = "Nuke it"
                ..cancelCaption = "Rethink it"
                ..show();
            }
          }
          else if (md.actionData == MessageData.HIDE) {
            if (md.data == "Settings") {
              gm.playSound(gm.slideOutSoundId);
              _settingsDialog.hide();
              focus(true);
              _blackout.visible = false;
            }
            else if (md.data == "ConfirmReset") {
              _resetConfirmDialog.hide();
              _settingsDialog.focus(true);
              removeChild(_resetConfirmDialog);
              if (md.choice == MessageData.YES) {
                gm.resources.reset().then((_) {
                  _settingsDialog.reset();
                });
              }
            }
          }
          break;
      }
    });
  }
  
  @override
  void focus(bool gain) {
    super.focus(gain);
    _mainLayer.enable(gain);
  }

}