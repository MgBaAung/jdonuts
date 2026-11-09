import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jdonutscodetest/base_architecture/core/api_response.dart';
import 'package:jdonutscodetest/base_architecture/core/master_object.dart';
import 'package:jdonutscodetest/base_architecture/data/network_datasource/network_client.dart';
import 'package:jdonutscodetest/base_architecture/domain/repository/api_repository.dart';
import 'package:jdonutscodetest/base_architecture/domain/usecase/baste_usecase.dart';
import 'package:jdonutscodetest/core/result.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_entity.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_repo.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_usecase.dart';
import 'package:jdonutscodetest/features/home/data/banner_model.dart';
import 'package:jdonutscodetest/features/home/presentation/banner_bloc.dart';
import 'package:jdonutscodetest/features/home/presentation/home_bottom_cubit.dart';
import 'package:jdonutscodetest/features/home/presentation/home_screen.dart';
import 'package:jdonutscodetest/features/product/data/product_model.dart';
import 'package:jdonutscodetest/features/product/presentation/product_bloc.dart';
import 'package:jdonutscodetest/features/rewards/data/reward_model.dart';
import 'package:jdonutscodetest/features/rewards/presentation/rewards_bloc.dart';
import 'package:jdonutscodetest/features/shop/data/shop_model.dart';
import 'package:jdonutscodetest/features/shop/presentation/shop_bloc.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home loads seeded sections and navigates to nearby shops', (
    tester,
  ) async {
    GetIt.I.registerSingleton<CacheManager>(
      CacheManager(Config('home-flow-test-cache')),
    );
    addTearDown(GetIt.I.reset);
    final auth = AuthUsecase(_TestAuthRepository());
    final products = ProductBloc(
      crudUsecase: CrudUseCase<ProdcutModel>(
        repository: _SeedRepository<ProdcutModel>(_productData),
      ),
    );
    final banners = BannerBloc(
      crudUsecase: CrudUseCase<BannerModel>(
        repository: _SeedRepository<BannerModel>(_bannerData),
      ),
    );
    final shops = ShopBloc(
      crudUsecase: CrudUseCase<ShopModel>(
        repository: _SeedRepository<ShopModel>(_shopData),
      ),
    );
    final rewards = RewardsBloc(
      crudUsecase: CrudUseCase<RewardModel>(
        repository: _SeedRepository<RewardModel>((_) => <dynamic>[]),
      ),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HomeBottomCubit()),
          BlocProvider(create: (_) => products..loadProducts()),
          BlocProvider(create: (_) => banners..loadBanners()),
          BlocProvider(create: (_) => shops..loadShops()),
          BlocProvider(create: (_) => rewards..loadRewards()),
        ],
        child: MaterialApp(home: HomeScreen(auth: auth)),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Hania Tester'), findsOneWidget);
    expect(find.text('Seasonal specials'), findsOneWidget);
    expect(find.text('Blueberry Glaze'), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Shops'));
    await tester.pumpAndSettle();

    expect(find.text('Nearby shops'), findsOneWidget);
    expect(find.text('Central Boulevard'), findsOneWidget);
  });
}

class _SeedRepository<T extends MasterObject<T>> extends ApiRepository<T> {
  _SeedRepository(this.payload) : super(networkClient: _UnusedNetworkClient());

  final dynamic Function(String endpoint) payload;

  @override
  Future<ApiResponse<R>> get<R>(
    String endPoint,
    R Function(dynamic) parser, {
    Map<String, dynamic>? queryParams,
    bool isList = false,
  }) async => ApiResponse<R>(
    success: true,
    statusCode: 200,
    data: parser(payload(endPoint)),
  );
}

class _UnusedNetworkClient implements NetworkClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestAuthRepository implements AuthRepository {
  static const member = AuthEntity(
    phone: '+959123456789',
    firstName: 'Hania',
    lastName: 'Tester',
    tier: 'Silver',
    points: 320000,
    nextTierPoints: 1000000,
  );

  @override
  Future<Result<String?>> currentPhone() async =>
      const Success<String?>('+959123456789');

  @override
  Future<Result<AuthEntity?>> profile(String phone) async =>
      const Success(member);

  @override
  Future<Result<bool>> isRegistered(String phone) async => const Success(true);

  @override
  Future<Result<void>> login(String phone) async => const Success(null);

  @override
  Future<Result<void>> logout() async => const Success(null);

  @override
  Future<Result<void>> register(AuthEntity member) async => const Success(null);
}

dynamic _productData(String endpoint) => [
  {
    'id': 'blueberry',
    'code': 'DON-002',
    'name': 'Blueberry Glaze',
    'description': 'A fluffy donut topped with blueberry glaze.',
    'priceMmk': 3800,
    'color': 4292924415,
    'emoji': '🫐',
    'imageUrl': 'https://images.unsplash.com/photo-1701866991174-89ae56e35cdc',
    'isSeasonalSpecial': true,
    'isPopular': true,
    'isOrderAgain': true,
    'isExploreNow': true,
  },
];

dynamic _bannerData(String endpoint) => [
  {
    'id': 'welcome',
    'title': 'We are now at',
    'subtitle': 'Central Boulevard!',
    'color': 4287323382,
    'imageAsset': 'assets/images/products/pink-sprinkle.jpg',
  },
];

dynamic _shopData(String endpoint) => [
  {
    'id': 'central',
    'name': 'Central Boulevard',
    'address': 'Corner of 27th Street',
    'distance': '0.8 km',
    'imageUrl': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a',
  },
];
