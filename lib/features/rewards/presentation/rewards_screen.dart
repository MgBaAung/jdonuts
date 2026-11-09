import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jdonutscodetest/global/app_theme.dart';

import '../../../base_architecture/state_management/bloc/api_state.dart';
import '../../shared/motion.dart';
import '../data/reward_model.dart';
import '../domain/reward_progress.dart';
import '../../shared/presentation/widgets.dart';
import 'rewards_bloc.dart';

class RewardsBlocView extends StatelessWidget {
  const RewardsBlocView({
    super.key,
    this.onBack,
    this.points = 680000,
    this.tier = 'Silver',
  });

  final VoidCallback? onBack;
  final int points;
  final String tier;

  @override
  Widget build(BuildContext context) => BlocBuilder<RewardsBloc, ApiState>(
    builder: (context, state) {
      if (state is ApiLoading || state is ApiInitial) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (state is ApiFailure) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message),
                TextButton(
                  onPressed: () => context.read<RewardsBloc>().loadRewards(),
                  child: const Text('Retry'),
                ),
                if (onBack != null)
                  TextButton(onPressed: onBack, child: const Text('Back')),
              ],
            ),
          ),
        );
      }
      if (state is ApiSuccess<List<RewardModel>>) {
        final challenges = state.data
            .map(
              (reward) => RewardChallenge(
                id: reward.id ?? '',
                title: reward.title ?? '',
                completed: reward.completed ?? 0,
                target: reward.target ?? 0,
                points: reward.points ?? 0,
                kind: reward.kind ?? '',
              ),
            )
            .toList();
        return RewardsScreen(
          onBack: onBack,
          points: points,
          tier: tier,
          challenges: challenges,
        );
      }
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    },
  );
}

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({
    super.key,
    this.onBack,
    this.points = 680000,
    this.tier = 'Silver',
    this.challenges = const [],
  });
  final VoidCallback? onBack;
  final int points;
  final String tier;
  final List<RewardChallenge> challenges;
  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController entrance;
  int selectedTab = 0;
  bool reduceMotion = false;

  int get tierIndex => switch (widget.tier.toLowerCase()) {
    'gold' => 1,
    'platinum' => 2,
    _ => 0,
  };

  double get tierProgress => switch (tierIndex) {
    0 => (widget.points / 1000000).clamp(0.0, 1.0),
    1 => ((widget.points - 1000000) / 1000000).clamp(0.0, 1.0),
    _ => 1.0,
  };

  @override
  void initState() {
    super.initState();
    entrance = AnimationController(
      vsync: this,
      duration: MotionDurations.progress,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (reduceMotion) {
      entrance.stop();
      entrance.value = 1;
    } else if (!entrance.isAnimating && entrance.value == 0) {
      entrance.forward();
    }
  }

  @override
  void dispose() {
    entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pointsToNextTier = tierIndex == 0
        ? (1000000 - widget.points).clamp(0, 1000000).toInt()
        : tierIndex == 1
        ? (2000000 - widget.points).clamp(0, 1000000).toInt()
        : 0;
    final challenges = [...widget.challenges]
      ..sort((a, b) => (b.isComplete ? 1 : 0).compareTo(a.isComplete ? 1 : 0));

    return Scaffold(
      backgroundColor: const Color(0xfff2f3f4),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'J’Donuts Rewards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff25252b),
                      ),
                    ),
                    AnimatedBuilder(
                      animation: entrance,
                      builder: (_, child) => Transform.scale(
                        scale: reduceMotion
                            ? 1
                            : Curves.elasticOut
                                  .transform(entrance.value)
                                  .clamp(0.0, 1.15),
                        child: child,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffff7b1b),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Rewards',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                            SizedBox(width: 6),
                            CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.white,
                              child: Text(
                                '3',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 320,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        bottom: 22,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final ringSize = math.min(
                              194.0,
                              constraints.maxWidth * .52,
                            );
                            return Row(
                              children: [
                                Expanded(
                                  child: _TierLadder(
                                    tierIndex: tierIndex,
                                    progress: reduceMotion
                                        ? tierProgress
                                        : tierProgress * entrance.value,
                                    pointsToNextTier: pointsToNextTier,
                                    tier: widget.tier,
                                  ),
                                ),
                                SizedBox(
                                  width: ringSize,
                                  height: ringSize,
                                  child: AnimatedBuilder(
                                    animation: entrance,
                                    builder: (_, _) {
                                      final value = reduceMotion
                                          ? 1.0
                                          : entrance.value;
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CustomPaint(
                                            size: Size.square(ringSize),
                                            painter: _PointsRingPainter(
                                              progress: tierProgress * value,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'Total points',
                                                style: TextStyle(
                                                  color: Color(0xfff05a9c),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                formatMMK(
                                                  (widget.points * value)
                                                      .round(),
                                                ),
                                                style: const TextStyle(
                                                  color: Color(0xffed4d97),
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Positioned(
                        left: 70.h,
                        right: 70.h,
                        bottom: 0,
                        child: _RewardsTabs(
                          selected: selectedTab,
                          onChanged: (value) =>
                              setState(() => selectedTab = value),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          20.height,
          AnimatedSwitcher(
            duration: reduceMotion ? Duration.zero : MotionDurations.tabSwitch,
            switchInCurve: MotionCurves.entrance,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(
                  Tween(begin: const Offset(0, .04), end: Offset.zero),
                ),
                child: child,
              ),
            ),
            child: selectedTab == 0
                ? _ChallengeList(
                    key: const ValueKey('challenges'),
                    challenges: challenges,
                    reduceMotion: reduceMotion,
                  )
                : const _GiftList(key: ValueKey('gifts')),
          ),
        ],
      ),
    );
  }
}

class _TierLadder extends StatelessWidget {
  const _TierLadder({
    required this.tierIndex,
    required this.progress,
    required this.pointsToNextTier,
    required this.tier,
  });
  final int tierIndex, pointsToNextTier;
  final double progress;
  final String tier;

  @override
  Widget build(BuildContext context) {
    final connectorProgress = tierIndex == 0
        ? progress
        : tierIndex == 1
        ? 1 + progress
        : 2.0;
    final descriptions = [
      tierIndex == 0 ? 'You’re here now' : 'Tier achieved',
      tierIndex == 0
          ? '${formatMMK(pointsToNextTier)} pts remaining\nto become Gold'
          : tierIndex == 1
          ? 'You’re here now'
          : 'Gold member',
      tierIndex == 2 ? 'You’re here now' : 'You’ll be here soon',
    ];
    const labels = ['Silver', 'Gold', 'Platinum'];
    const letters = ['S', 'G', 'P'];
    const colors = [Color(0xffc6ccd1), Color(0xffffd65a), Color(0xff55cde0)];
    return Stack(
      children: [
        Positioned(
          left: 15,
          top: 35,
          bottom: 35,
          child: Container(width: 2, color: const Color(0xffe2e5e7)),
        ),
        Positioned(
          left: 15,
          top: 35,
          child: Container(
            width: 2,
            height: (98 * connectorProgress).clamp(0, 196).toDouble(),
            color: const Color(0xff70777d),
          ),
        ),
        Column(
          children: List.generate(
            3,
            (index) => Expanded(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: reduceMotionDuration(context)
                    ? Duration.zero
                    : MotionDurations.cardEntrance +
                          Duration(milliseconds: index * 160),
                curve: MotionCurves.entrance,
                builder: (_, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-12 * (1 - value), 0),
                    child: child,
                  ),
                ),
                child: Row(
                  children: [
                    CustomPaint(
                      size: const Size(31, 35),
                      painter: _TierBadgePainter(
                        color: colors[index],
                        letter: letters[index],
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: index == tierIndex
                                  ? const Color(0xff303138)
                                  : const Color(0xff62666c),
                            ),
                          ),
                          Text(
                            descriptions[index],
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 9,
                              height: 1.2,
                              color: Color(0xff74777c),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool reduceMotionDuration(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);
}

class _TierBadgePainter extends CustomPainter {
  const _TierBadgePainter({required this.color, required this.letter});

  final Color color;
  final String letter;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final shield = Path()
      ..moveTo(w * .5, h * .04)
      ..cubicTo(w * .72, h * .13, w * .87, h * .15, w * .93, h * .2)
      ..lineTo(w * .88, h * .66)
      ..cubicTo(w * .85, h * .82, w * .65, h * .95, w * .5, h)
      ..cubicTo(w * .35, h * .95, w * .15, h * .82, w * .12, h * .66)
      ..lineTo(w * .07, h * .2)
      ..cubicTo(w * .13, h * .15, w * .28, h * .13, w * .5, h * .04)
      ..close();

    canvas.drawPath(shield, Paint()..color = color.withValues(alpha: .2));
    canvas.drawPath(
      shield,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    final starCount = switch (letter) {
      'G' => 2,
      'P' => 3,
      _ => 1,
    };
    final spacing = starCount == 1 ? 0.0 : 4.8;
    for (var starIndex = 0; starIndex < starCount; starIndex++) {
      final centerX = w * .5 + (starIndex - (starCount - 1) / 2) * spacing;
      final star = Path();
      const points = 5;
      for (var i = 0; i < points * 2; i++) {
        final radius = i.isEven ? 2.5 : 1.1;
        final angle = -math.pi / 2 + i * math.pi / points;
        final point = Offset(
          centerX + math.cos(angle) * radius,
          h * .3 + math.sin(angle) * radius,
        );
        if (i == 0) {
          star.moveTo(point.dx, point.dy);
        } else {
          star.lineTo(point.dx, point.dy);
        }
      }
      star.close();
      canvas.drawPath(star, Paint()..color = color);
    }

    final text = TextPainter(
      text: TextSpan(
        text: letter,
        style: const TextStyle(
          color: Color(0xff687078),
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(canvas, Offset((w - text.width) / 2, h * .54));
  }

  @override
  bool shouldRepaint(covariant _TierBadgePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.letter != letter;
}

class _PointsRingPainter extends CustomPainter {
  const _PointsRingPainter({required this.progress});
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * .38;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xffeef0f1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.shortestSide * .23,
    );
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * .23
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [Color(0xfff05a9c), Color(0xffff8cc3), Color(0xffec4b96)],
        transform: GradientRotation(-math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, ring);
    final dash = Paint()
      ..color = const Color(0xffffb5d7)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 20; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * (i + .5) / 20);
      if ((((angle + math.pi / 2 + 2 * math.pi) % (2 * math.pi)) /
              (2 * math.pi)) >
          progress) {
        continue;
      }
      final start =
          center + Offset(math.cos(angle), math.sin(angle)) * (radius - 5);
      final end =
          center +
          Offset(math.cos(angle + .18), math.sin(angle + .18)) * (radius + 3);
      canvas.drawLine(start, end, dash);
    }
  }

  @override
  bool shouldRepaint(covariant _PointsRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _RewardsTabs extends StatelessWidget {
  const _RewardsTabs({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
    height: 44,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    child: Row(
      children: [
        Expanded(child: _tab(context, 'Eat more earn more', 0)),
        const SizedBox(width: 4),
        Expanded(child: _tab(context, 'Gift', 1)),
      ],
    ),
  );
  Widget _tab(BuildContext context, String label, int index) => InkWell(
    onTap: () => onChanged(index),
    borderRadius: BorderRadius.circular(22),
    child: AnimatedContainer(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : MotionDurations.tabSwitch,
      curve: MotionCurves.sharedAxis,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        color: selected == index
            ? const Color(0xff54c9df)
            : const Color(0xffeef0f1),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: selected == index ? Colors.white : const Color(0xff656970),
          ),
        ),
      ),
    ),
  );
}

class _ChallengeList extends StatelessWidget {
  const _ChallengeList({
    super.key,
    required this.challenges,
    required this.reduceMotion,
  });
  final List<RewardChallenge> challenges;
  final bool reduceMotion;
  @override
  Widget build(BuildContext context) {
    if (challenges.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text('No challenges available yet.'),
      );
    }
    return Column(
      children: List.generate(
        challenges.length,
        (index) => TweenAnimationBuilder<double>(
          tween: Tween(begin: reduceMotion ? 1 : 0, end: 1),
          duration: reduceMotion
              ? Duration.zero
              : MotionDurations.cardEntrance +
                    Duration(milliseconds: index * 130),
          curve: MotionCurves.entrance,
          builder: (_, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 16 * (1 - value)),
              child: child,
            ),
          ),
          child: _ChallengeCard(
            challenge: challenges[index],
            reduceMotion: reduceMotion,
          ),
        ),
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.challenge, required this.reduceMotion});
  final RewardChallenge challenge;
  final bool reduceMotion;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
    ),
    child: Row(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(
            begin: reduceMotion ? challenge.progress : 0,
            end: challenge.progress,
          ),
          duration: reduceMotion ? Duration.zero : MotionDurations.progress,
          curve: MotionCurves.entrance,
          builder: (_, value, _) => SizedBox(
            width: 100,
            height: 100,
            child: CustomPaint(
              painter: _ChallengePainter(progress: value, kind: challenge.kind),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff24252a),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${challenge.completed}/${challenge.target}',
                style: const TextStyle(fontSize: 12, color: Color(0xff55565b)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _EarnButton(
                    enabled: challenge.isComplete,
                    reduceMotion: reduceMotion,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${challenge.points} pts',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff505157),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _EarnButton extends StatefulWidget {
  const _EarnButton({required this.enabled, required this.reduceMotion});
  final bool enabled, reduceMotion;
  @override
  State<_EarnButton> createState() => _EarnButtonState();
}

class _EarnButtonState extends State<_EarnButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController pulse;
  bool pressed = false;
  @override
  void initState() {
    super.initState();
    pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant _EarnButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    if (widget.enabled && !widget.reduceMotion) {
      pulse.repeat(reverse: true);
    } else {
      pulse.stop();
      pulse.value = 0;
    }
  }

  @override
  void dispose() {
    pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: pulse,
    builder: (_, child) => Transform.scale(
      scale: pressed
          ? .94
          : (widget.enabled && !widget.reduceMotion
                ? 1 + pulse.value * .035
                : 1),
      child: child,
    ),
    child: GestureDetector(
      onTap: () {},
      onTapDown: (_) => setState(() => pressed = true),
      onTapUp: (_) => setState(() => pressed = false),
      onTapCancel: () => setState(() => pressed = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
        decoration: BoxDecoration(
          color: widget.enabled
              ? const Color(0xff55cade)
              : const Color(0xffe4e6e7),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          'EARN',
          style: TextStyle(
            color: widget.enabled ? Colors.white : Colors.white,
            fontSize: 11,
            letterSpacing: .5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    ),
  );
}

class _GiftList extends StatelessWidget {
  const _GiftList({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: const ListTile(
      leading: CircleAvatar(
        backgroundColor: Color(0xffffe5f1),
        child: Icon(Icons.card_giftcard, color: Color(0xffef5c9b)),
      ),
      title: Text(
        'Free classic donut',
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text('Unlock at 1,000,000 points'),
      trailing: Icon(Icons.lock_outline),
    ),
  );
}

class _ChallengePainter extends CustomPainter {
  const _ChallengePainter({required this.progress, required this.kind});
  final double progress;
  final String kind;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // လက်ရှိအထူ (thickness * 1.3) ဖြင့် 30% ပိုထူအောင် ပြုလုပ်ခြင်း
    final radius = size.shortestSide * .42;
    final thickness = (size.shortestSide * .28) * 1.3;
    final ring = Rect.fromCircle(center: center, radius: radius);

    // ၁။ ဒိုးနတ် မုန့်သားအခြေခံ (Dough base)
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xfff1d3ac)
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness,
    );

    // ၂။ မရောက်သေးသော အပိုင်းအတွက် (White / Greyish base icing)
    canvas.drawArc(
      ring,
      -math.pi / 2,
      2 * math.pi,
      false,
      Paint()
        ..color = const Color(0xffe2e5e8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness * .96
        ..strokeCap = StrokeCap.butt,
    );

    // ၃။ တိုးတက်မှု (Progress / Earned) ရှိမှသာ ပန်းရောင်အိုင်ဆིင်ကို အပိုင်းလိုက် ထပ်ခြယ်ရန်
    final clampedProgress = progress.clamp(0.0, 1.0).toDouble();
    if (clampedProgress > 0) {
      canvas.drawArc(
        ring,
        -math.pi / 2,
        2 * math.pi * clampedProgress,
        false,
        Paint()
          ..color =
              const Color(0xfff45ca5) // ပန်းရောင် Strawberry icing
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness * .96
          ..strokeCap = StrokeCap.butt,
      );
    }

    // ၄။ Sprinkle (အမွှားလေးများ) ထည့်သွင်းခြင်း
    final sprinkles = [
      const Color(0xffffffff),
      const Color(0xff54c9df),
      const Color(0xffffc84c),
      const Color(0xff8bc96f),
    ];
    for (var i = 0; i < 14; i++) {
      final angle = 2 * math.pi * i / 14;
      final sprinkleRadius = radius * 0.82;
      final point =
          center + Offset(math.cos(angle), math.sin(angle)) * sprinkleRadius;
      canvas.save();
      canvas.translate(point.dx, point.dy);
      canvas.rotate(angle + math.pi / 2 + (i.isEven ? .22 : -.18));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 5, height: 2),
          const Radius.circular(1),
        ),
        Paint()..color = sprinkles[i % sprinkles.length],
      );
      canvas.restore();
    }

    // ၅။ အလယ် အပေါက်ဖောက်ခြင်း
    final holeRadius = radius - (thickness / 2);
    canvas.drawCircle(center, holeRadius, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      holeRadius,
      Paint()
        ..color = const Color(0xffd7a46f)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _ChallengePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.kind != kind;
}

class ArcProgressPainter extends CustomPainter {
  const ArcProgressPainter({required this.progress});
  final double progress; // 0.0 မှ 1.0 အထိ

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.7);
    final radius = size.shortestSide * 0.45;
    final strokeWidth = 14.0;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // ၁။ နောက်ခံ မီးခိုးရောင် Arc (Background Arc - 180 ဒီဂရီ)
    final backgroundPaint = Paint()
      ..color = const Color(0xfff0f2f3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi, math.pi, false, backgroundPaint);

    // ၂။ တိုးတက်မှုကိုပြသသော အစိမ်းရောင်/အစိမ်းဖျော့ သို့မဟုတ် လိမ္မော်ရောင် Arc (Progress Arc)
    final progressPaint = Paint()
      ..color =
          const Color(0xffff8736) // လိမ္မော်ရောင် (သို့မဟုတ် လိုချင်သောအရောင်)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // ဘယ်ဘက်မှ ညာဘက်သို့ progress ပမာဏအလိုက် ကွေးညွတ်ပြသရန်
    final sweepAngle = math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(rect, math.pi, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ArcProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

//you can use drink reward

// SizedBox(
//   width: 200,
//   height: 120,
//   child: Stack(
//     alignment: Alignment.center,
//     children: [
//       CustomPaint(
//         size: const Size(200, 120),
//         painter: ArcProgressPainter(progress: 0.75), // 75% ပြရန်
//       ),
//       // အလယ်မှာပြမည့် ပုံ (သို့မဟုတ်) အချိုရည်ခွက်
//       Positioned(
//         bottom: 0,
//         child: Image.asset(
//           'assets/images/coffee.png',
//           width: 60,
//           height: 80,
//         ),
//       ),
//     ],
//   ),
// )
