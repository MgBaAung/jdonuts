import 'package:jdonutscodetest/base_architecture/domain/usecase/baste_usecase.dart';
import 'package:jdonutscodetest/features/shop/data/shop_model.dart';

class ShopUsecase extends CrudUseCase<ShopModel> {
  ShopUsecase({required super.repository});
}
