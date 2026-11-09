import 'package:jdonutscodetest/base_architecture/domain/repository/api_repository_with_local.dart';
import 'package:jdonutscodetest/features/shop/data/shop_model.dart';
import 'package:jdonutscodetest/features/shop/domain/shop_entity.dart';

class ShopRepo extends ApiRepositoryWithLocalStorage<ShopModel, ShopEntity> {
  ShopRepo({required super.networkClient, required super.localDataSource});
}
