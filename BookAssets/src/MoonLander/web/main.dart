library moonlander;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'dart:web_audio';
import 'dart:math' as Math;

import 'package:ranger/ranger.dart' as Ranger;
import 'package:tweenengine/tweenengine.dart' as UTE;
import 'package:vector_math/vector_math.dart';
import 'package:lawndart/lawndart.dart';

part 'game_manager.dart';
part 'resources/resources.dart';

part 'scenes/splash/splash_scene.dart';
part 'scenes/splash/splash_layer.dart';

part 'scenes/game/main_scene.dart';
part 'scenes/game/main_layer.dart';
part 'scenes/game/hud_layer.dart';
part 'scenes/game/scores_scene.dart';
part 'scenes/game/scores_layer.dart';

part 'scenes/game/level_selection_scene.dart';
part 'scenes/game/level_selection_layer.dart';

part 'scenes/game/levels/level_rimbaloid_scene.dart';
part 'scenes/game/levels/level_rimbaloid_layer.dart';
part 'scenes/game/levels/hud_rimbaloid_layer.dart';

part 'scenes/game/actors/mobile_actor.dart';
part 'scenes/game/actors/physics_actor.dart';
part 'scenes/game/actors/tri_engine_rocket.dart';
part 'scenes/game/actors/tri_engine_rocket_part.dart';
part 'scenes/game/actors/tri_engine_rocket_gear_part.dart';
part 'scenes/game/actors/tri_engine_gear.dart';
part 'scenes/game/actors/fuel_gauge.dart';
part 'scenes/game/actors/velocity_gauge.dart';
part 'scenes/game/actors/circle_particle.dart';
part 'scenes/game/actors/particle_activator.dart';

part 'scenes/game/nodes/rectangle_node.dart';
part 'scenes/game/nodes/nonuniform_rectangle_node.dart';
part 'scenes/game/nodes/circle_particle_node.dart';
part 'scenes/game/nodes/circle_node.dart';
part 'scenes/game/nodes/animatable_circle_node.dart';
part 'scenes/game/nodes/round_rectangle_node.dart';
part 'scenes/game/nodes/zoom_group.dart';
part 'scenes/game/nodes/zone.dart';
part 'scenes/game/nodes/dual_range_zone.dart';
part 'scenes/game/nodes/fading_text_node.dart';

part 'scenes/game/dialogs/dialog.dart';
part 'scenes/game/dialogs/settings_dialog.dart';
part 'scenes/game/dialogs/popup_dialog.dart';
part 'scenes/game/dialogs/yesno_popup_dialog.dart';
part 'scenes/game/dialogs/playagain_popup_dialog.dart';
part 'scenes/game/dialogs/message_data.dart';
part 'scenes/game/dialogs/button.dart';
part 'scenes/game/dialogs/basic_button.dart';
part 'scenes/game/dialogs/toggle_button.dart';
part 'scenes/game/dialogs/slideout_dialog.dart';
part 'scenes/game/dialogs/base_html_dialog.dart';
part 'scenes/game/dialogs/initials_dialog.dart';

part 'scenes/game/dialogs/reset_popup_dialog.dart';

// Global management
GameManager gm = new GameManager.basic();

// Ranger application access
Ranger.Application ranger;

void main() {
  ranger = new Ranger.Application.fitDesignToWindow(
   window, 
   Ranger.CONFIG.surfaceTag,
   preConfigure,
   1900, 1200
   );

}

void preConfigure() {
  MainScene mainScene = new MainScene(333);
  mainScene.name = "MainScene";

  //---------------------------------------------------------------
  // Create a splash scene with a layer that will be shown prior
  // to transitioning to the main game scene.
  //---------------------------------------------------------------
  SplashScene splashScene = new SplashScene.withReplacementScene(mainScene)
    ..pauseFor = 0.1
    ..name = "SplashScene";

  
  // Create BootScene and push it onto the currently empty scene stack. 
  Ranger.BootScene bootScene = new Ranger.BootScene(splashScene)
    ..name = "BootScene";

  // Once the boot scene's onEnter is called it will immediately replace
  // itself with the replacement Splash screen.
  ranger.sceneManager.pushScene(bootScene);
  
  // Now complete the pre configure by signaling Ranger.
  ranger.gameConfigured();
}