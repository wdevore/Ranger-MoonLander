part of moonlander;

class GameManager {
  Ranger.AudioEffects audioEffects;

  int slideInSoundId;
  int slideOutSoundId;
  int popupSoundId;
  int toggleSoundId;
  int clickSoundId;
  int inCorrectSoundId;

  Resources resources = new Resources();
  TriEngineRocket triEngineRocket;
  TriEngineRocketPart triEngineRocket_hull;
  TriEngineRocketPart triEngineRocket_centercell;
  TriEngineRocketPart triEngineRocket_leftcell;
  TriEngineRocketPart triEngineRocket_rightcell;
  TriEngineRocketGearPart leg;
  TriEngineRocketGearPart toe;
  TriEngineRocketGearPart leg2;
  TriEngineRocketGearPart toe2;

  static const double ACCELERATION = 0.02;
  Ranger.Velocity gravity;

  VelocityGauge verticalVelocity;
  VelocityGauge horizontalVelocity;

  AnimatableCircleNode explodingRing;
  AnimatableCircleNode fadingDisc;

  SlideOutDialog slideOutDialog;
  YesNoChoicePopupDialog playAgainDialog;
  SlideOutDialog landingsSlideOutDialog;

  InitialsDialog initialsDialog;

  // <editor-fold desc="DEBUG">
  NonUniformRectangleNode aabbox = new NonUniformRectangleNode.basic(null, Ranger.Color4IRed);
  NonUniformRectangleNode aabbox2 = new NonUniformRectangleNode.basic(null, Ranger.Color4IRed);
  // </editor-fold>

  GameManager();
  
  factory GameManager.basic() {
    GameManager o = new GameManager();
    return o;
  }
  
  bool postLoad() {
    
    gravity = new Ranger.Velocity.withComponents(0.0, -1.0, ACCELERATION);
    
    audioEffects = new Ranger.AudioEffects.basic(new AudioContext());
    
    slideInSoundId = audioEffects.loadEffectByMap(resources.slideInSound);
    slideOutSoundId = audioEffects.loadEffectByMap(resources.slideOutSound);
    popupSoundId = audioEffects.loadEffectByMap(resources.popupSound);
    toggleSoundId = audioEffects.loadEffectByMap(resources.toggleSound);
    clickSoundId = audioEffects.loadEffectByMap(resources.clickSound);
    inCorrectSoundId = audioEffects.loadEffectByMap(resources.inCorrectSound);

    explodingRing = new AnimatableCircleNode.basic();
    fadingDisc = new AnimatableCircleNode.basic();

    triEngineRocket_hull = new TriEngineRocketPart()
      ..init()
      ..constructPart(gm.resources.engineRocket3_hull);
    triEngineRocket_centercell = new TriEngineRocketPart()
      ..init()
      ..constructPart(gm.resources.engineRocket3_centercell);
    triEngineRocket_leftcell = new TriEngineRocketPart()
      ..init()
      ..constructPart(gm.resources.engineRocket3_leftcell);
    triEngineRocket_rightcell = new TriEngineRocketPart()
      ..init()
      ..constructPart(gm.resources.engineRocket3_rightcell);

    leg = new TriEngineRocketGearPart()
      ..init();
    toe = new TriEngineRocketGearPart()
      ..init();
    leg2 = new TriEngineRocketGearPart()
      ..init();
    toe2 = new TriEngineRocketGearPart()
      ..init();

    initialsDialog = new InitialsDialog()
      ..width = 400.0
      ..height = 300.0;

    return true;
  }

  void playSound(int id) {
    if (resources.isSoundOn)
      audioEffects.play(id);
  }

  Map get scores => resources.gameConfig["Scores"];

  // Did they Place on the score board.
  bool placed(int landings) {
    // Did they beat one of the scores
    int score = scores.keys.firstWhere((int i) => landings >= i, orElse: () => null);

    return score != null;
  }

  void updateScores(int landings, String initials) {
    // The new score either replaces a score or adds. However, the list maxes at 10.
    // Duplicates are not allowed. They must match or bettin a score to place on the board.
    if (scores.length == 10) {
      if (!scores.keys.contains(landings)) {
        List<int> sortedScores = scores.keys.toList();
        sortedScores.sort();

        // Remove the lowest score
        scores.remove(sortedScores.elementAt(0));
      }
    }

    scores[landings] = initials;
  }
}
