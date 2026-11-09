import 'package:jdonutscodetest/base_architecture/state_management/bloc/base_bloc.dart';
import 'package:jdonutscodetest/base_architecture/state_management/bloc/api_event.dart';
import 'package:jdonutscodetest/features/product/data/product_model.dart';

class ProductBloc extends BaseBloc<ProdcutModel> {
  ProductBloc({required super.crudUsecase});

  void loadProducts() => add(
    FetchAllDataEvent<ProdcutModel>(
      endpoint: '/products',
      parser: (json) => ProdcutModel().fromMapList(json as List),
    ),
  );
}
