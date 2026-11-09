import 'package:jdonutscodetest/base_architecture/domain/repository/api_repository_with_local.dart';
import 'package:jdonutscodetest/features/product/data/product_model.dart';
import 'package:jdonutscodetest/features/product/domain/prodcut_entity.dart';

class ProductRepo
    extends ApiRepositoryWithLocalStorage<ProdcutModel, ProdcutEntity> {
  ProductRepo({required super.networkClient, required super.localDataSource});
}
