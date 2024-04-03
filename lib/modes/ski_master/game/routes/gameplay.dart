import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';

import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';

import '../actors/avalanche.dart';
import '../actors/player.dart';
import '../actors/snowman.dart';
import '../game.dart';
import '../hud.dart';



class Gameplay extends Component with HasGameReference<SkiMasterGame> {
  // onPausePressed is a optional parameter
  Gameplay(
      this.currentLevel, {
        super.key,
        required this.onPausePressed,
        required this.onLevelCompleted,
        required this.onGameOver,
      });
  static const id = 'Gameplay';
  static const _timeScaleRate = 1;

  final int currentLevel;
  final VoidCallback onPausePressed;
  final ValueChanged<int> onLevelCompleted;
  final VoidCallback onGameOver;

  late final _resetTimer = Timer(1, autoStart: false, onTick: resetPlayer);
  late final _cameraShake = MoveEffect.by(
    Vector2(0, 3),
    InfiniteEffectController(
      ZigzagEffectController(period: 0.2),
    ),
  );

  late final World _world;
  late final CameraComponent _camera;
  late final Player player;
  late final Vector2 _lastSafePosition;
  late final RectangleComponent _fader;
  late final Hud hud;
  late final SpriteSheet _spriteSheet;
  Avalanche? _avalanche;

  int _nSnowmanCollected = 0;
  int _nLives = 3;

  late int _star1;
  late int _star2;
  late int _star3;

  int _nTrailTriggers = 0;
  bool get _isOffTrail => _nTrailTriggers == 0;

  bool _levelCompleted = false;
  bool _levelStarted = false;
  bool _gameOver = false;

  @override
  Future<void> onLoad() async {
    //loading assets is heavy since it loads everything in sync to have less lag you can override as async
    //the map is a 16 by 16
    final map = await TiledComponent.load(
      'Level$currentLevel.tmx',
      Vector2.all(16),
    );
    final tiles = game.images.fromCache('../images/skimaster/tilemap_packed.png');
    _spriteSheet = SpriteSheet(image: tiles, srcSize: Vector2.all(16));

    _star1 = map.tileMap.map.properties.getValue<int>('Star1')!;
    _star2 = map.tileMap.map.properties.getValue<int>('Star2')!;
    _star3 = map.tileMap.map.properties.getValue<int>('Star3')!;

    await _setupWorldAndCamera(map);
    await _handleSpawnPoints(map);
    await _handleTriggers(map);

    _fader = RectangleComponent(
      size: _camera.viewport.virtualSize,
      paint: Paint()..color = game.backgroundColor(),
      children: [OpacityEffect.fadeOut(LinearEffectController(1.5))],
      priority: 1,
    );

    hud = Hud(
      playerSprite: _spriteSheet.getSprite(5, 10),
      snowmanSprite: _spriteSheet.getSprite(5, 9),
      player: player,
      onPausePressed: onPausePressed,
    );

    await _camera.viewport.addAll([_fader, hud]);
    await _camera.viewfinder.add(_cameraShake);
    _cameraShake.pause();
    hud.intervalCountdown.stop();
    _hudCounterStart();
  }

  @override
  void update(double dt) {
    if (hud.intervalCountdown.isRunning()) {
      _cameraShake.pause();
      hud.intervalCountdown.onTick = () {
        hud.elapsedSecs--;
        if (hud.elapsedSecs <= 0) {
          hud.intervalCountdown.stop();
          hud.goDisplayTimer.start();
        }
      };
    }
    hud.goDisplayTimer.update(dt);
    if (!hud.intervalCountdown.isRunning()) {
      if (_levelCompleted || _gameOver) {
        player.timeScale = lerpDouble(
          player.timeScale,
          0,
          _timeScaleRate * dt,
        )!;
      } else {
        if (_isOffTrail && player.active) {
          _resetTimer.update(dt);

          if (!_resetTimer.isRunning()) {
            _resetTimer.start();
          }
          if (_cameraShake.isPaused) {
            _cameraShake.resume();
          }
        } else {
          if (_resetTimer.isRunning()) {
            _resetTimer.stop();
          }
          if (!_cameraShake.isPaused) {
            _cameraShake.pause();
          }
        }
        //Avalanche
        if (_levelStarted && !_levelCompleted && !_gameOver) {
          _avalanche?.moveAvalanche(dt);
        }
      }
    }
  }

  Future<void> _setupWorldAndCamera(TiledComponent map) async {
    // instead of adding the loaded map to gameplay, we add it as a child of world
    _world = World(children: [map]);
    // adding the world to the gameplay component but still wont render the world
    await add(_world);
    //We neet to make the camera look at the world by setting the world as parameter
    _camera = CameraComponent.withFixedResolution(
      width: 320,
      height: 200,
      world: _world,
    );
    await add(_camera);
  }

  Future<void> _handleSpawnPoints(TiledComponent map) async {
    //we should get it from the cache since if we can see the tile mapit means the image is already loaded by flame
    //the image get automatically cached in the global image cache we can save ressources this way

    final spawnPointLayer = map.tileMap.getLayer<ObjectGroup>('SpawnPoint');
    final objects = spawnPointLayer?.objects;

    if (objects != null) {
      for (final object in objects) {
        switch (object.class_) {
          case 'Player':
          //By default, a postion component does not have any visual info
            player = Player(
              priority: 1,
              position: Vector2(object.x, object.y),
              sprite: _spriteSheet.getSprite(5, 10),
            );
            await _world.add(player);
            _camera.follow(player);
            _lastSafePosition = Vector2(object.x, object.y);
            break;
          case 'Snowman':
            final snowmman = Snowman(
              position: Vector2(object.x, object.y),
              sprite: _spriteSheet.getSprite(5, 9),
              onCollected: () => _onSnowmanCollected(),
            );
            _world.add(snowmman);
            break;
          case 'Avalanche':
            _avalanche = Avalanche(
              priority: 1,
              position: Vector2(object.x + object.width / 2, object.y),
            );
            await _world.add(_avalanche!);
            break;
        }
      }
    }
  }

  Future<void> _handleTriggers(TiledComponent map) async {
    //we should get it from the cache since if we can see the tile mapit means the image is already loaded by flame
    //the image get automatically cached in the global image cache we can save ressources this way
    final triggerLayer = map.tileMap.getLayer<ObjectGroup>('Trigger');
    final objects = triggerLayer?.objects;

    if (objects != null) {
      for (final object in objects) {
        switch (object.class_) {
          case 'Trail':
            final vertices = <Vector2>[];
            for (final point in object.polygon) {
              vertices.add(Vector2(point.x + object.x, point.y + object.y));
            }
            //most common setup for hitbox is to add it directly to its component like we did with snomen and player
            //so we added the hitbox to components that extend from positioncomponent
            //however hitobx are also components and can be direcly added to the component tree
            //the only requirement is that they should have at least 1 ancestaor that is a position component
            //so we will add it to the tile component since it derives from the positionComponent
            //we do not add it to the world since its not a position component
            final hitbox = PolygonHitbox(
              vertices,
              collisionType: CollisionType.passive,
              isSolid: true,
            );

            hitbox.onCollisionStartCallback = (_, __) => _onTrailEnter();
            hitbox.onCollisionEndCallback = (_) => _onTrailExit();
            await map.add(hitbox);
            break;
          case 'Checkpoint':
            final checkpoint = RectangleHitbox(
              position: Vector2(object.x, object.y),
              size: Vector2(object.width, object.height),
              collisionType: CollisionType.passive,
            );
            checkpoint.onCollisionStartCallback =
                (_, __) => _onCheckpoint(checkpoint);

            await map.add(checkpoint);
            break;
          case 'Ramp':
            final ramp = RectangleHitbox(
              position: Vector2(object.x, object.y),
              size: Vector2(object.width, object.height),
              collisionType: CollisionType.passive,
            );
            ramp.onCollisionStartCallback = (_, __) => onRamp();

            await map.add(ramp);
            break;
          case 'Start':
            final trailStart = RectangleHitbox(
              position: Vector2(object.x, object.y),
              size: Vector2(object.width, object.height),
              collisionType: CollisionType.passive,
            );
            trailStart.onCollisionStartCallback = (_, __) => _onTrailStart();

            await map.add(trailStart);
            break;
          case 'End':
            final trailEnd = RectangleHitbox(
              position: Vector2(object.x, object.y),
              size: Vector2(object.width, object.height),
              collisionType: CollisionType.passive,
            );
            trailEnd.onCollisionStartCallback = (_, __) => _onTrailEnd();

            await map.add(trailEnd);
            break;
        }
      }
    }
  }

  void _onTrailEnter() {
    ++_nTrailTriggers;
  }

  void _onTrailExit() {
    --_nTrailTriggers;
  }

  void onRamp() {
    final jumpFactor = player.jump();
    final jumpScale = lerpDouble(1, 0.8, jumpFactor)!;
    final jumpDuration = lerpDouble(0, 0.8, jumpFactor)!;

    _camera.viewfinder.add(
      ScaleEffect.by(
        Vector2.all(jumpScale),
        EffectController(
          duration: jumpDuration,
          alternate: true,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  void _onCheckpoint(RectangleHitbox checkpoint) {
    _lastSafePosition.setFrom(checkpoint.absoluteCenter);
    checkpoint.removeFromParent();
  }

  _onTrailStart() {
    player.active = true;
    _levelStarted = true;
    _lastSafePosition.setFrom(player.position);
  }

  void _onTrailEnd() {
    _fader.add(OpacityEffect.fadeIn(LinearEffectController(1.5)));
    player.active = false;
    _levelCompleted = true;
    if (_nSnowmanCollected <= _star3) {
      onLevelCompleted.call(3);
    } else if (_nSnowmanCollected <= _star2) {
      onLevelCompleted.call(2);
    } else if (_nSnowmanCollected <= _star1) {
      onLevelCompleted.call(1);
    }
  }

  void _onSnowmanCollected() {
    _nSnowmanCollected++;
    hud.updateSnowmanCount(_nSnowmanCollected);
    //Set the player speed to 50% of the max and acceleration to 0 and make them lerp back to their initial value
    player.speed *= 0.5;
  }

  void resetPlayer() {
    _cameraShake.pause();
    _fader.add(OpacityEffect.fadeIn(LinearEffectController(0)));
    --_nLives;
    hud.updateLifeCount(_nLives);
    if (_nLives > 0) {
      _fader.add(OpacityEffect.fadeOut(LinearEffectController(2)));
      player.resetTo(_lastSafePosition);
      _avalanche?.resetTo(_lastSafePosition);
      _hudCounterStart();
    } else {
      _gameOver = true;
      _fader.add(OpacityEffect.fadeIn(LinearEffectController(1.5)));
      onGameOver.call();
    }
  }

  void _hudCounterStart() {
    hud.elapsedSecs = 3;
    hud.intervalCountdown.start();
  }
}
