import 'package:jdonutscodetest/base_architecture/state_management/bloc/base_bloc.dart';
import 'package:jdonutscodetest/base_architecture/state_management/bloc/api_event.dart';
import 'package:jdonutscodetest/features/home/data/banner_model.dart';

class BannerBloc extends BaseBloc<BannerModel> {
  BannerBloc({required super.crudUsecase});

  void loadBanners() => add(
    FetchAllDataEvent<BannerModel>(
      endpoint: '/banners',
      parser: (json) => BannerModel().fromMapList(json as List),
    ),
  );
}
