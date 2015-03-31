part of moonlander;

class SplashScene extends Ranger.AnchoredScene {
  /**
   * How long to pause (in seconds) before transitioning to the [_replacementScene]
   * [Scene]. Default is immediately (aka 0.0)
   */
  double pauseFor = 0.0;
  Ranger.Scene _replacementScene;
  
  SplashScene.withPrimary(Ranger.Layer primary, Ranger.Scene replacementScene, [Function completeVisit = null]) {
    initWithPrimary(primary);
    completeVisitCallback = completeVisit;
    _replacementScene = replacementScene;
  }
  
  SplashScene.withReplacementScene(Ranger.Scene replacementScene, [Function completeVisit = null]) {
    tag = 405;  // An optional arbitrary number usual for debugging.
    completeVisitCallback = completeVisit;
    _replacementScene = replacementScene;
  }
  
  @override
  void onEnter() {
    super.onEnter();
    
    SplashLayer splashLayer = new SplashLayer.withColor(Ranger.color4IFromHex("#4b4f54"), true);
    splashLayer.tag = 404;
    initWithPrimary(splashLayer);

    splashLayer.beforeResourcesLoaded();
    
    // Async load resources for the first level.
    gm.resources.load().then((_) {
      gm.postLoad();
      splashLayer.afterResourcesLoaded();
      transitionEnabled = true;
    });
  }

  @override
  void transition() {
    Ranger.TransitionScene transition = new Ranger.TransitionInstant.initWithScene(_replacementScene)
      ..name = "TransitionInstant"
      ..tag = 9090;
    
    Ranger.SceneManager sm = Ranger.Application.instance.sceneManager;
    sm.replaceScene(transition);
  }
}