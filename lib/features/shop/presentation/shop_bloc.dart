import 'package:jdonutscodetest/base_architecture/state_management/bloc/base_bloc.dart';
import 'package:jdonutscodetest/base_architecture/state_management/bloc/api_event.dart';
import 'package:jdonutscodetest/features/shop/data/shop_model.dart';

class ShopBloc extends BaseBloc<ShopModel> {
  ShopBloc({required super.crudUsecase});

  void loadShops() => add(
    FetchAllDataEvent<ShopModel>(
      endpoint: '/shops',
      parser: (json) => ShopModel().fromMapList(json as List),
    ),
  );
}
