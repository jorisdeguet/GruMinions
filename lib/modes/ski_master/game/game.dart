import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide Route, OverlayRoute;

import 'routes/gameplay.dart';
import 'routes/level_complete.dart';
import 'routes/level_selection.dart';
import 'routes/main_menu.dart';
import 'routes/pause_menu.dart';
import 'routes/retry_menu.dart';
import 'routes/settings.dart';

class SkiMasterGame extends FlameGame with HasCollisionDetection {
  final musicValueNotifier = ValueNotifier(false);
  final sfxValueNotifier = ValueNotifier(false);

  //Stores the mapping between strings and routes using a id as a key
  late final _routes = <String, Route>{
    MainMenu.id: OverlayRoute(
      (context, game) => MainMenu(
        onPlayPressed: () => _routeById(LevelSelection.id),
        onSettingsPressed: () => _routeById(Settings.id),
      ),
    ),
    Settings.id: OverlayRoute(
      (context, game) => Settings(
        musicValueListenable: musicValueNotifier,
        sfxValueListenable: sfxValueNotifier,
        onBackPressed: _popRoute,
        onMusicValueChanged: (value) => musicValueNotifier.value = value,
        onSfxcValueChanged: (value) => sfxValueNotifier.value = value,
      ),
    ),
    LevelSelection.id: OverlayRoute(
      (context, game) => LevelSelection(
        onLevelSelected: _startLevel,
        onBackPressed: _popRoute,
      ),
    ),
    PauseMenu.id: OverlayRoute(
      (context, game) => PauseMenu(
        onResumePressed: _resumeGame,
        onRestartPressed: _restartLevel,
        onExitPressed: _exitToMainMenu,
      ),
    ),
    RetryMenu.id: OverlayRoute(
      (context, game) => RetryMenu(
        onRetryPressed: _restartLevel,
        onExitPressed: _exitToMainMenu,
      ),
    ),
  };

  late final _routeFactories = <String, Route Function(String)>{
    LevelComplete.id: (argument) => OverlayRoute(
          (context, game) => LevelComplete(
            nStars: int.parse(argument),
            onNextPressed: _startNextLevel,
            onRetryPressed: _restartLevel,
            onExitPressed: _exitToMainMenu,
          ),
        ),
  };

  //Since we are accsessing a class member to init the router we ned to set it as late
  late final _router = RouterComponent(
    initialRoute: MainMenu.id,
    routes: _routes,
    routeFactories: _routeFactories,
  );

  @override
  Color backgroundColor() => const Color.fromARGB(255, 238, 248, 254);

  @override
  Future<void> onLoad() async {
    await add(_router);
  }

  void _routeById(String id) {
    _router.pushNamed(id);
  }

  void _popRoute() {
    _router.pop();
  }

  void _startLevel(int levelIndex) {
    //Here using a normal rotue instead of a overlay route
    //Since contexte of this route is made of flame components not flutter widgets
    //Beceause of this thisisnot added to reoute map directly
    //since input level to gameplay will keep changing with the content of gameplay
    //So we are making a gameplay route instead
    //we will for this reason store the name/id as a optional parameter
    _router.pop();
    _router.pushReplacement(
        Route(
          () => Gameplay(
            levelIndex,
            onPausePressed: _pauseGame,
            onLevelCompleted: _showLevelCompleteMenu,
            onGameOver: _showRetryMenu,
            key: ComponentKey.named(Gameplay.id),
          ),
        ),
        name: Gameplay.id);
  }

  void _restartLevel() {
    // We know that the component of this key will be of type gameplay
    //So we set the generic parameter of this methode  as gameplay
    final gameplay = findByKeyName<Gameplay>(Gameplay.id);
    if (gameplay != null) {
      _startLevel(gameplay.currentLevel);
      resumeEngine();
    }
  }

  void _startNextLevel() {
    final gameplay = findByKeyName<Gameplay>(Gameplay.id);
    if (gameplay != null) {
      _startLevel(gameplay.currentLevel + 1);
    }
  }

  void _pauseGame() {
    _router.pushNamed(PauseMenu.id);
    pauseEngine();
  }

  void _resumeGame() {
    _router.pop();
    resumeEngine();
  }

  void _exitToMainMenu() {
    _resumeGame();
    _router.pushReplacementNamed(MainMenu.id);
  }

  void _showLevelCompleteMenu(int nStars) {
    //First slash is input id second is argument
    _router.pushNamed('${LevelComplete.id}/$nStars');
  }

  void _showRetryMenu() {
    _router.pushNamed(RetryMenu.id);
  }
}
