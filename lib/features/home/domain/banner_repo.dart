
import 'package:jdonutscodetest/base_architecture/domain/repository/api_repository_with_local.dart';
import 'package:jdonutscodetest/features/home/data/banner_model.dart';
import 'package:jdonutscodetest/features/home/domain/banner_entity.dart';

class BannerRepo extends ApiRepositoryWithLocalStorage<BannerModel,BannerEntity>{
  BannerRepo({required super.networkClient, required super.localDataSource});
}