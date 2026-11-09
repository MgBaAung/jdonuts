import 'package:jdonutscodetest/base_architecture/domain/repository/api_repository_with_local.dart';
import 'package:jdonutscodetest/features/rewards/data/reward_model.dart';
import 'package:jdonutscodetest/features/rewards/domain/reward_entity.dart';

class RewardRepo
    extends ApiRepositoryWithLocalStorage<RewardModel, RewardEntity> {
  RewardRepo({required super.networkClient, required super.localDataSource});
}
