

class RewardChallenge {
  const RewardChallenge({required this.id, required this.title, required this.completed, required this.target, required this.points, required this.kind});
  final String id, title, kind;
  final int completed, target, points;
  double get progress => target <= 0 ? 0 : (completed / target).clamp(0, 1).toDouble();
  bool get isComplete => target > 0 && completed >= target;
}
