import 'package:jdonutscodetest/base_architecture/domain/usecase/baste_usecase.dart';
import 'package:jdonutscodetest/features/product/data/product_model.dart';

class ProductUsecase extends CrudUseCase<ProdcutModel> {
  ProductUsecase({required super.repository});
}
