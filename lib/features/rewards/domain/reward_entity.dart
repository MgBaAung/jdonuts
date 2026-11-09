
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:jdonutscodetest/base_architecture/core/base_entity.dart';
import 'package:jdonutscodetest/features/rewards/data/reward_model.dart';

part 'reward_entity.g.dart';

@HiveType(typeId: 2)
class RewardEntity extends BaseEntity<RewardModel, RewardEntity> {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  int? completed;
  @HiveField(3)
  int? target;
  @HiveField(4)
  int? points;
  @HiveField(5)
  String? kind;

  RewardEntity({
    this.id,
    this.title,
    this.completed,
    this.target,
    this.points,
    this.kind,
  });

  @override
  RewardEntity fromModel(RewardModel model) => RewardEntity(
    id: model.id,
    title: model.title,
    completed: model.completed,
    target: model.target,
    points: model.points,
    kind: model.kind,
  );

  @override
  RewardModel toModel() => RewardModel(
    id: id,
    title: title,
    completed: completed,
    target: target,
    points: points,
    kind: kind,
  );

   static void register() {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RewardEntityAdapter());
    }
  }
}

