
import 'package:jdonutscodetest/base_architecture/state_management/bloc/base_bloc.dart';
import 'package:jdonutscodetest/base_architecture/state_management/bloc/api_event.dart';
import 'package:jdonutscodetest/features/rewards/data/reward_model.dart';

class RewardsBloc extends BaseBloc<RewardModel>{
  RewardsBloc({required super.crudUsecase});

  void loadRewards() => add(
    FetchAllDataEvent<RewardModel>(
      endpoint: '/rewards',
      parser: (json) => RewardModel().fromMapList(json as List),
    ),
  );
}
