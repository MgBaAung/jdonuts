import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:jdonutscodetest/base_architecture/data/local_datasource/hive_local_datasource.dart';
import 'package:jdonutscodetest/base_architecture/data/local_datasource/local_datasource.dart';
import 'package:jdonutscodetest/base_architecture/data/network_datasource/http_network/http_network.dart';
import 'package:jdonutscodetest/base_architecture/data/network_datasource/network_client.dart';
import 'package:jdonutscodetest/features/home/data/banner_model.dart';
import 'package:jdonutscodetest/features/home/domain/banner_entity.dart';
import 'package:jdonutscodetest/features/home/domain/banner_repo.dart';
import 'package:jdonutscodetest/features/home/domain/banner_usecase.dart';
import 'package:jdonutscodetest/features/home/presentation/banner_bloc.dart';
import 'package:jdonutscodetest/features/product/data/product_model.dart';
import 'package:jdonutscodetest/features/product/domain/prodcut_entity.dart';
import 'package:jdonutscodetest/features/product/domain/product_repo.dart';
import 'package:jdonutscodetest/features/product/domain/product_usecase.dart';
import 'package:jdonutscodetest/features/product/presentation/product_bloc.dart';
import 'package:jdonutscodetest/features/rewards/data/reward_model.dart';
import 'package:jdonutscodetest/features/rewards/domain/reward_entity.dart';
import 'package:jdonutscodetest/features/rewards/domain/reward_repo.dart';
import 'package:jdonutscodetest/features/rewards/domain/reward_usecase.dart';
import 'package:jdonutscodetest/features/rewards/presentation/rewards_bloc.dart';
import 'package:jdonutscodetest/features/shop/data/shop_model.dart';
import 'package:jdonutscodetest/features/shop/domain/shop_entity.dart';
import 'package:jdonutscodetest/features/shop/domain/shop_repo.dart';
import 'package:jdonutscodetest/features/shop/domain/shop_usecase.dart';
import 'package:jdonutscodetest/features/shop/presentation/shop_bloc.dart';

import '../../core/local/j_donuts_local_data_source.dart';
import '../../core/network/connectivity_monitor.dart';
import '../../core/session/session_store.dart';
import '../../core/session/hive_session_store.dart';
import '../auth/data/local_auth_repository.dart';
import '../auth/domain/auth_repo.dart';
import '../auth/domain/auth_usecase.dart';
import '../auth/presentation/state_management/auth_flow_cubit.dart';
import 'app_router.dart';

final appGetIt = GetIt.asNewInstance();
final getIt = GetIt.instance;
late final Box<ProdcutEntity> productbox;
late final Box<ShopEntity> shopbox;
late final Box<RewardEntity> rewardbox;
late final Box<BannerEntity> bannerbox;

Future<void> configureJDonutsDependencies({
  required JDonutsLocalDataSource localDataSource,
  SessionStore? sessionStore,
  ConnectivityMonitor? connectivityMonitor,
}) async {
  await appGetIt.reset();
  await getIt.reset();
  getIt.registerLazySingleton<CacheManager>(
    () => CacheManager(
      Config(
        'b2bFreshMoeCache',
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: 350,
      ),
    ),
  );
  await Hive.initFlutter();
  ShopEntity.register();
  RewardEntity.register();
  ProdcutEntity.register();
  BannerEntity.register();

  // add product list in hive local storage
  productbox = await Hive.openBox<ProdcutEntity>('products');
  try {
    final String jsonString = await rootBundle.loadString(
      'assets/data/store_seed.json',
    );
    final Map<String, dynamic> decodedData = json.decode(jsonString);

    final List<dynamic> productList = decodedData['products'] ?? [];
    final productsById = <String, ProdcutModel>{};
    for (final item in productList) {
      final productModel = ProdcutModel().fromMap(item);
      final id = productModel.id;
      if (id == null) continue;
      final existingSeed = productsById[id];
      if (existingSeed == null) {
        productsById[id] = productModel;
      } else {
        existingSeed.isSeasonalSpecial =
            existingSeed.isSeasonalSpecial || productModel.isSeasonalSpecial;
        existingSeed.isPopular =
            existingSeed.isPopular || productModel.isPopular;
        existingSeed.isOrderAgain =
            existingSeed.isOrderAgain || productModel.isOrderAgain;
        existingSeed.isExploreNow =
            existingSeed.isExploreNow || productModel.isExploreNow;
      }
    }

    for (final productModel in productsById.values) {
      final id = productModel.id!;
      final existing = productbox.get(id);
      if (existing == null) {
        await productbox.put(id, ProdcutEntity().fromModel(productModel));
      } else if (existing.imageUrl != productModel.imageUrl ||
          existing.imageAsset != productModel.imageAsset ||
          existing.isSeasonalSpecial != productModel.isSeasonalSpecial ||
          existing.isPopular != productModel.isPopular ||
          existing.isOrderAgain != productModel.isOrderAgain ||
          existing.isExploreNow != productModel.isExploreNow) {
        final oldImageValue = existing.imageUrl;
        existing.imageUrl = productModel.imageUrl;
        existing.imageAsset =
            productModel.imageAsset ??
            (oldImageValue != null && !oldImageValue.startsWith('http')
                ? oldImageValue
                : null);
        existing.isSeasonalSpecial = productModel.isSeasonalSpecial;
        existing.isPopular = productModel.isPopular;
        existing.isOrderAgain = productModel.isOrderAgain;
        existing.isExploreNow = productModel.isExploreNow;
        await productbox.put(id, existing);
      }
    }
  } catch (e) {
    print('Failed to load product seed: $e');
  }

  // add shop list to hive local storage
  shopbox = await Hive.openBox<ShopEntity>('shops');
  try {
    final String jsonString = await rootBundle.loadString(
      'assets/data/store_seed.json',
    );
    final Map<String, dynamic> decodedData = json.decode(jsonString);

    final List<dynamic> shopList = decodedData['shops'] ?? [];
    for (var index = 0; index < shopList.length; index++) {
      final item = Map<String, dynamic>.from(shopList[index]);
      item['id'] ??= 'shop-$index';
      final shopModel = ShopModel().fromMap(item);
      final existing = shopbox.get(shopModel.id);

      if (existing == null) {
        await shopbox.put(shopModel.id, ShopEntity().fromModel(shopModel));
      } else {
        var changed = false;
        if (existing.township == null && shopModel.township != null) {
          existing.township = shopModel.township;
          changed = true;
        }
        if (existing.imageUrl != shopModel.imageUrl) {
          existing.imageUrl = shopModel.imageUrl;
          changed = true;
        }
        if (existing.imageAsset == null && shopModel.imageAsset != null) {
          existing.imageAsset = shopModel.imageAsset;
          changed = true;
        } else if (existing.imageAsset == null &&
            existing.imageUrl != null &&
            !existing.imageUrl!.startsWith('http')) {
          existing.imageAsset = existing.imageUrl;
          existing.imageUrl = shopModel.imageUrl;
          changed = true;
        }
        if (!changed) continue;
        await shopbox.put(shopModel.id, existing);
      }
    }
  } catch (e) {
    print('Failed to load shop seed: $e');
  }

  // add reward list to hive local storage
  rewardbox = await Hive.openBox<RewardEntity>('rewards');
  if (rewardbox.isEmpty) {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/store_seed.json',
      );
      final Map<String, dynamic> decodedData = json.decode(jsonString);

      final List<dynamic> productList = decodedData['rewards'] ?? [];
      for (var item in productList) {
        final rewardModel = RewardModel().fromMap(item);
        final rewardEntity = RewardEntity().fromModel(rewardModel);

        await rewardbox.put(rewardModel.id, rewardEntity);
      }
    } catch (e) {
      print('Failed to load store seed: $e');
    }
  }

  // add banner list to hive local storage
  bannerbox = await Hive.openBox<BannerEntity>('banners');
  if (bannerbox.isEmpty) {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/store_seed.json',
      );
      final Map<String, dynamic> decodedData = json.decode(jsonString);
      final List<dynamic> bannerList = decodedData['banners'] ?? [];
      for (var index = 0; index < bannerList.length; index++) {
        final item = Map<String, dynamic>.from(bannerList[index]);
        item['id'] ??= 'banner-$index';
        final bannerModel = BannerModel().fromMap(item);
        await bannerbox.put(
          bannerModel.id,
          BannerEntity().fromModel(bannerModel),
        );
      }
    } catch (e) {
      print('Failed to load banner seed: $e');
    }
  }

  // products local dependency
  getIt.registerLazySingleton<LocalDataSource<ProdcutModel, ProdcutEntity>>(
    () => HiveLocalDataSourceImpl<ProdcutModel, ProdcutEntity>(
      entityFactory: () => ProdcutEntity(),
      box: productbox,
    ),
  );
  getIt.registerLazySingleton(
    () => ProductRepo(
      networkClient: getIt.call(),
      localDataSource: getIt
          .call<LocalDataSource<ProdcutModel, ProdcutEntity>>(),
    ),
  );
  getIt.registerLazySingleton(
    () => ProductUsecase(repository: getIt<ProductRepo>()),
  );
  getIt.registerFactory(
    () => ProductBloc(crudUsecase: getIt<ProductUsecase>()),
  );

  // shops local dependency
  getIt.registerLazySingleton<LocalDataSource<ShopModel, ShopEntity>>(
    () => HiveLocalDataSourceImpl<ShopModel, ShopEntity>(
      entityFactory: () => ShopEntity(),
      box: shopbox,
    ),
  );
  getIt.registerLazySingleton(
    () => ShopRepo(
      networkClient: getIt.call(),
      localDataSource: getIt.call<LocalDataSource<ShopModel, ShopEntity>>(),
    ),
  );
  getIt.registerLazySingleton(() => ShopUsecase(repository: getIt<ShopRepo>()));
  getIt.registerFactory(() => ShopBloc(crudUsecase: getIt<ShopUsecase>()));

  // reward local dependency
  getIt.registerLazySingleton<LocalDataSource<RewardModel, RewardEntity>>(
    () => HiveLocalDataSourceImpl<RewardModel, RewardEntity>(
      entityFactory: () => RewardEntity(),
      box: rewardbox,
    ),
  );
  getIt.registerLazySingleton(
    () => RewardRepo(
      networkClient: getIt.call(),
      localDataSource: getIt.call<LocalDataSource<RewardModel, RewardEntity>>(),
    ),
  );
  getIt.registerLazySingleton(
    () => RewardUsecase(repository: getIt<RewardRepo>()),
  );
  getIt.registerFactory(() => RewardsBloc(crudUsecase: getIt<RewardUsecase>()));

  // banner local dependency
  getIt.registerLazySingleton<LocalDataSource<BannerModel, BannerEntity>>(
    () => HiveLocalDataSourceImpl<BannerModel, BannerEntity>(
      entityFactory: () => BannerEntity(),
      box: bannerbox,
    ),
  );
  getIt.registerLazySingleton(
    () => BannerRepo(
      networkClient: getIt.call(),
      localDataSource: getIt.call<LocalDataSource<BannerModel, BannerEntity>>(),
    ),
  );
  getIt.registerLazySingleton(
    () => BannerUsecase(repository: getIt<BannerRepo>()),
  );
  getIt.registerFactory(() => BannerBloc(crudUsecase: getIt<BannerUsecase>()));

  getIt.registerLazySingleton<NetworkClient>(() => HttpNetworkClient());

  appGetIt.registerSingleton<JDonutsLocalDataSource>(localDataSource);
  appGetIt.registerSingleton<SessionStore>(
    sessionStore ?? HiveSessionStore(localDataSource),
  );
  appGetIt.registerSingleton<ConnectivityMonitor>(
    connectivityMonitor ?? ConnectivityMonitor(),
  );

  final authRepository = LocalAuthRepository(
    localDataSource,
    appGetIt<SessionStore>(),
  );
  appGetIt.registerSingleton<AuthRepository>(authRepository);

  appGetIt.registerLazySingleton<AuthUsecase>(
    () => AuthUsecase(appGetIt<AuthRepository>()),
  );
  appGetIt.registerFactory<AuthFlowCubit>(
    () => AuthFlowCubit(appGetIt<AuthUsecase>()),
  );
  appGetIt.registerSingleton<GoRouter>(
    createJDonutsRouter(
      auth: appGetIt<AuthUsecase>(),
      createProductBloc: () => getIt<ProductBloc>(),
      createBannerBloc: () => getIt<BannerBloc>(),
      createRewardsBloc: () => getIt<RewardsBloc>(),
      createShopBloc: () => getIt<ShopBloc>(),
    ),
    dispose: (router) => router.dispose(),
  );
}
