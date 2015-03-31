part of moonlander;

/**
 * If you know that any of your SVG assets have anything complex like
 * Blur or Translucency then you may need to use an offscreen canvas for
 * pre-rendering. Otherwise an ImageElement isn't actually rendered until
 * it first intersects the viewport.
 * Using an offscreen canvas has its drawbacks in that scaling is "locked"
 * in place verses realtime scaling being done by the SVG renderer.
 * For example, if you zoomed in on an SVG image rendered to a canvas it
 * would always be redrawn vector wise. However, if you first cached a
 * prerendered version of the SVG to an offscreen buffer, when you zoomed
 * in the image would be pixelated.
 * 
 * So you have a choice: don't use Blur or Transluceny, or accept pixelation.
 */
class Resources {
  Completer _loadingWorker;
  Completer _nukeWorker;
  
  int _resourceCount = 0;
  int _resourceTotal = 0;

  Ranger.SpriteImage spriteSpinner2;
  ImageElement lander1;
  ImageElement gear;
  ImageElement back;
  
  ImageElement rocket1;
  ImageElement rocket2;
  ImageElement rocket3;

  ImageElement engineRocket3;
  ImageElement engineRocket3_hull;
  ImageElement engineRocket3_centercell;
  ImageElement engineRocket3_leftcell;
  ImageElement engineRocket3_rightcell;

  ImageElement medal;

  ImageElement pause;

  ImageElement configured;
  ImageElement skull;

  ImageElement lock;

  ImageElement chicken;
  ImageElement nuke;

  Map slideInSound;
  Map slideOutSound;
  Map popupSound;
  Map toggleSound;
  Map clickSound;
  Map inCorrectSound;

  Store gameStore;
  /*
   Game scores can overlap

   */
  Map gameConfig;

  Resources() {
    ImageElement spinner2 = new ImageElement(
        src: Ranger.BaseResources.svgMimeHeader + Ranger.BaseResources.spinner2,
        width: 512, height: 512);
    spriteSpinner2 = new Ranger.SpriteImage.withElement(spinner2);
  }
  
  Future<ImageElement> loadImage(String source, int iWidth, int iHeight, [bool simulateLoadingDelay = false]) {
    Ranger.ImageLoader loader = new Ranger.ImageLoader.withResource(source);
    loader.simulateLoadingDelay = simulateLoadingDelay;
    return loader.load(iWidth, iHeight);
  }
  
  bool get isLoaded => _resourceCount == _resourceTotal; 

  Future load() {
    _loadingWorker = new Completer();
    
    _resourceTotal++; // Lander1
    
    loadImage("resources/Lander1.svg", 295, 466).then((ImageElement ime) {
      lander1 = ime;
      _updateLoadStatus();
    });

    _resourceTotal += 2;    // gear and back icons
    loadImage("resources/gear.svg", 32, 32).then((ImageElement ime) {
      gear = ime;
      _updateLoadStatus();
    });
    loadImage("resources/back.svg", 35, 32).then((ImageElement ime) {
      back = ime;
      _updateLoadStatus();
    });

    _resourceTotal += 3;    // three rockets
    loadImage("resources/rocket1.svg", 32, 32).then((ImageElement ime) {
      rocket1 = ime;
      _updateLoadStatus();
    });
    loadImage("resources/rocket2.svg", 32, 32).then((ImageElement ime) {
      rocket2 = ime;
      _updateLoadStatus();
    });
    loadImage("resources/rocket3.svg", 32, 32).then((ImageElement ime) {
      rocket3 = ime;
      _updateLoadStatus();
    });

    _resourceTotal += 1;    // lock
    loadImage("resources/lock.svg", 32, 32).then((ImageElement ime) {
      lock = ime;
      _updateLoadStatus();
    });
    
    _resourceTotal += 2;    // rocket for level 0 and pause button
    loadImage("resources/EngineRocket3.svg", 235, 245).then((ImageElement ime) {
      engineRocket3 = ime;
      _updateLoadStatus();
    });
    loadImage("resources/pause.svg", 512, 512).then((ImageElement ime) {
      pause = ime;
      _updateLoadStatus();
    });

    _resourceTotal += 4;    // rocket in discrete parts
    loadImage("resources/EngineRocket3_hull.svg", 220, 220).then((ImageElement ime) {
      engineRocket3_hull = ime;
      _updateLoadStatus();
    });
    loadImage("resources/EngineRocket3_centercell.svg", 80, 80).then((ImageElement ime) {
      engineRocket3_centercell = ime;
      _updateLoadStatus();
    });
    loadImage("resources/EngineRocket3_leftcell.svg", 65, 65).then((ImageElement ime) {
      engineRocket3_leftcell = ime;
      _updateLoadStatus();
    });
    loadImage("resources/EngineRocket3_rightcell.svg", 56, 76).then((ImageElement ime) {
      engineRocket3_rightcell = ime;
      _updateLoadStatus();
    });

    _resourceTotal += 1;    // configured
    loadImage("resources/configured.svg", 32, 32).then((ImageElement ime) {
      configured = ime;
      _updateLoadStatus();
    });
    
    _resourceTotal += 1;    // skull
    loadImage("resources/Pirate_Skull_And_Bones.svg", 744, 496).then((ImageElement ime) {
      skull = ime;
      _updateLoadStatus();
    });

    _resourceTotal += 1;
    loadImage("resources/medal.svg", 512, 512).then((ImageElement ime) {
      medal = ime;
      _updateLoadStatus();
    });

    _resourceTotal += 2;    // chicken and nuke
    loadImage("resources/Chicken_icon.svg", 128, 128).then((ImageElement ime) {
      chicken = ime;
      _updateLoadStatus();
    });
    loadImage("resources/nuc_it.svg", 60, 60).then((ImageElement ime) {
      nuke = ime;
      _updateLoadStatus();
    });
    
    // Load Configure map.
    _resourceTotal += 1;    // storage
    gameStore = new Store("MoonLanderDB", "MoonLanderConfig");

    gameStore.open().then((_) {
      gameStore.getByKey("Config").then((Map value) {
        if (value == null) {
          print("No app configuration present. Defaulting to a preset.");
          gameConfig = _buildDefaultConfig();
        }
        else {
          print("Game config present.");
          gameConfig = value;
        }
        _updateLoadStatus();
      });
    });

    _loadSoundEffects();

    return _loadingWorker.future;
  }

  void _loadSoundEffects() {
    _resourceTotal += 6;    // sound effect
    HttpRequest.getString("resources/SlideIn.rsfxr").then((sfxr){
      slideInSound = JSON.decode(sfxr);
      _updateLoadStatus();
    });
    HttpRequest.getString("resources/SlideOut.rsfxr").then((sfxr){
      slideOutSound = JSON.decode(sfxr);
      _updateLoadStatus();
    });
    HttpRequest.getString("resources/Popup.rsfxr").then((sfxr){
      popupSound = JSON.decode(sfxr);
      _updateLoadStatus();
    });
    HttpRequest.getString("resources/Toggle.rsfxr").then((sfxr){
      toggleSound = JSON.decode(sfxr);
      _updateLoadStatus();
    });
    HttpRequest.getString("resources/Click.rsfxr").then((sfxr){
      clickSound = JSON.decode(sfxr);
      _updateLoadStatus();
    });
    HttpRequest.getString("resources/Incorrect.rsfxr").then((sfxr){
      inCorrectSound = JSON.decode(sfxr);
      _updateLoadStatus();
    });
  }

  Map _buildDefaultConfig() {
    Map m = {
      "Music": false,
      "Sound": true,
      "Cloud": false,
      "Scores": {
        4: "Moo",
        3: "n L",
        2: "and",
        1: "er"
      }
    };
    
    return m;
  }
  
  bool get isMusicOn => gameConfig["Music"] as bool;

  set musicOn(bool b) {
    gameConfig["Music"] = b;
  }
  
  bool get isSoundOn => gameConfig["Sound"] as bool;
  set soundOn(bool b) {
    gameConfig["Sound"] = b;
  }
  
  bool get isCloudOn => gameConfig["Cloud"] as bool;
  set cloudOn(bool b) {
    gameConfig["Cloud"] = b;
  }
  
  void _updateStore() {
    gameStore.save(gameConfig, "Config");
  }
  
  Future _nukeStore() {
    _nukeWorker = new Completer();

    if (!gameStore.isOpen) {
      gameStore.open().then((_) {
        print("Store opened. Nuking game.");
        gameStore.nuke().then((_) {
          print("Game nuked.");
          gameConfig = _buildDefaultConfig();
          _nukeWorker.complete();
        }).catchError((Error e) => print(e));
      }).catchError((DomException e) => print(e));
    }
    else {
      gameStore.nuke().then((_) {
        print("Game nuked.");
        gameConfig = _buildDefaultConfig();
        _nukeWorker.complete();
      }).catchError((Error e) => print(e));
    }
    
    return _nukeWorker.future;
  }

  void _updateLoadStatus() {
    _resourceCount++;

    if (isLoaded) {
      _loadingWorker.complete();
    }
  }
  
  void save() {
    _updateStore();
  }
  
  Future reset() {
    // TODO should wait for Future to complete.
    return _nukeStore();
  }
  
  /**
   * This spinner is available immediately.
   * [lapTime] how long to make one rotation/arc of the given [deltaDegrees].
   */
  Ranger.SpriteImage getSpinnerRing(double lapTime, double deltaDegrees, int tag) {
    spriteSpinner2.tag = tag;
    
    UTE.Tween rot = ranger.animations.rotateBy(
        spriteSpinner2, 
        lapTime,
        deltaDegrees, 
        UTE.Linear.INOUT, null, false);
    //                 v---------^
    // Above we set "autostart" to false in order to set the repeat value
    // because you can't change the value after the tween has started.
    rot..repeat(UTE.Tween.INFINITY, 0.0)
       ..start();
    
    return spriteSpinner2;
  }

}