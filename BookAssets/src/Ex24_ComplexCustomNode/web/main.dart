library layer;

// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:math';

import 'package:ranger/ranger.dart' as Ranger;
import 'package:tweenengine/tweenengine.dart' as UTE;

part 'main_scene.dart';
part 'main_layer.dart';
part 'lissajous_curve_node.dart';

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
  MainScene mainScene = new MainScene()
    ..name = "MainScene";

  // Create BootScene and push it onto the currently empty scene stack.
  Ranger.BootScene bootScene = new Ranger.BootScene(mainScene)
    ..name = "BootScene";

  // Once the boot scene's onEnter is called it will immediately replace
  // itself with the replacement Splash screen.
  ranger.sceneManager.pushScene(bootScene);

  // Now complete the pre configure by signaling Ranger.
  ranger.gameConfigured();
}