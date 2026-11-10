import 'package:flutter_test/flutter_test.dart';
import 'package:jdonutscodetest/features/rewards/domain/reward_progress.dart';

void main() {
  group('RewardChallenge progress', () {
    test('reports fractional progress and completion correctly', () {
      const challenge = RewardChallenge(
        id: 'visits',
        title: 'Visit three shops',
        completed: 1,
        target: 3,
        points: 2000,
        kind: 'visits',
      );

      expect(challenge.progress, closeTo(1 / 3, 0.0001));
      expect(challenge.isComplete, isFalse);
    });

    test('clamps over-completion and safely handles non-positive targets', () {
      const completed = RewardChallenge(
        id: 'done',
        title: 'Done',
        completed: 8,
        target: 5,
        points: 1,
        kind: 'x',
      );
      const noTarget = RewardChallenge(
        id: 'none',
        title: 'No target',
        completed: 1,
        target: 0,
        points: 1,
        kind: 'x',
      );

      expect(completed.progress, 1);
      expect(completed.isComplete, isTrue);
      expect(noTarget.progress, 0);
      expect(noTarget.isComplete, isFalse);
    });
  });
}
