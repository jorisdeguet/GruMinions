import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:gru_minions/modes/ski_master/game/actors/player.dart';

import '../game.dart';

// ignore: camel_case_types
class Snowman extends PositionComponent
    with CollisionCallbacks, HasGameReference<SkiMasterGame> {
  Snowman({super.position, required Sprite sprite, this.onCollected})
      : _body = SpriteComponent(sprite: sprite, anchor: Anchor.center);

  final SpriteComponent _body;
  final VoidCallback? onCollected;

  late final _particlePaint = Paint()..color = game.backgroundColor();

  static final _random = Random();
  static Vector2 _randomVector(double scale) {
    return Vector2(2 * _random.nextDouble() - 1, 2 * _random.nextDouble() - 1)
      ..normalize()
      ..scale(scale);
  }

  @override
  FutureOr<void> onLoad() async {
    await add(_body);
    //Collision to passive make it so that passives items wont collide together
    //This makes it so that it has less data to computer incase they collide saving performances
    await add(
      CircleHitbox.relative(
        1,
        parentSize: _body.size,
        anchor: Anchor.center,
        collisionType: CollisionType.passive,
      ),
    );
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Player) {
      _collect();
    }
  }

  //Opacity can only be appllied component that expose a paint object and have visual element
  //Snowman is just a visual element without any paint so we need to target the body
  void _collect() {
    if (game.sfxValueNotifier.value) {
      FlameAudio.play(SkiMasterGame.snowmanSfx);
    }
    addAll([
      OpacityEffect.fadeOut(
        LinearEffectController(0.4),
        target: _body,
        onComplete: removeFromParent,
      ),
      ScaleEffect.by(
        Vector2.all(1.2),
        LinearEffectController(0.4),
      ),
    ]);

    parent?.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 30,
          lifespan: 1,
          generator: (index) {
            return MovingParticle(
              to: _randomVector(16),
              child: ScalingParticle(
                to: 0,
                child: CircleParticle(
                  radius: 2 + _random.nextDouble() * 3,
                  paint: _particlePaint,
                ),
              ),
            );
          },
        ),
      ),
    );
    onCollected?.call();
  }
}