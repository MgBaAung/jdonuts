import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart' as google_fonts;
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jdonutscodetest/base_architecture/core/api_response.dart';
import 'package:jdonutscodetest/base_architecture/core/master_object.dart';
import 'package:jdonutscodetest/base_architecture/data/network_datasource/network_client.dart';
import 'package:jdonutscodetest/base_architecture/domain/repository/api_repository.dart';
import 'package:jdonutscodetest/base_architecture/domain/usecase/baste_usecase.dart';
import 'package:jdonutscodetest/core/result.dart';
import 'package:jdonutscodetest/features/app/app_router.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_entity.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_repo.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_usecase.dart';
import 'package:jdonutscodetest/features/auth/presentation/state_management/auth_flow_cubit.dart';
import 'package:jdonutscodetest/features/home/data/banner_model.dart';
import 'package:jdonutscodetest/features/home/presentation/banner_bloc.dart';
import 'package:jdonutscodetest/features/product/data/product_model.dart';
import 'package:jdonutscodetest/features/product/presentation/product_bloc.dart';
import 'package:jdonutscodetest/features/rewards/data/reward_model.dart';
import 'package:jdonutscodetest/features/rewards/presentation/rewards_bloc.dart';
import 'package:jdonutscodetest/features/shop/data/shop_model.dart';
import 'package:jdonutscodetest/features/shop/presentation/shop_bloc.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('registers a member, opens Home, and views a product', (
    tester,
  ) async {
    google_fonts.GoogleFonts.config.allowRuntimeFetching = false;
    GetIt.I.registerSingleton<CacheManager>(
      CacheManager(Config('registration-product-test-cache')),
    );
    addTearDown(GetIt.I.reset);

    final authRepository = _RegistrationAuthRepository();
    final authUsecase = AuthUsecase(authRepository);
    final authFlow = AuthFlowCubit(authUsecase);
    final router = createJDonutsRouter(
      auth: authUsecase,
      createProductBloc: () => ProductBloc(
        crudUsecase: CrudUseCase<ProdcutModel>(
          repository: _SeedRepository<ProdcutModel>(_productData),
        ),
      ),
      createBannerBloc: () => BannerBloc(
        crudUsecase: CrudUseCase<BannerModel>(
          repository: _SeedRepository<BannerModel>(_bannerData),
        ),
      ),
      createRewardsBloc: () => RewardsBloc(
        crudUsecase: CrudUseCase<RewardModel>(
          repository: _SeedRepository<RewardModel>((_) => <dynamic>[]),
        ),
      ),
      createShopBloc: () => ShopBloc(
        crudUsecase: CrudUseCase<ShopModel>(
          repository: _SeedRepository<ShopModel>(_shopData),
        ),
      ),
    );
    addTearDown(() {
      router.dispose();
      authFlow.close();
    });

    await tester.pumpWidget(
      BlocProvider.value(
        value: authFlow,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text("LET'S GET STARTED"));
    await tester.pumpAndSettle();
    expect(find.text('Enter your phone\nnumber'), findsOneWidget);

    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('VERIFY'));
    await tester.pumpAndSettle();
    expect(find.text('What’s your\nname?'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Hania');
    await tester.enterText(find.byType(TextField).at(1), 'Tester');
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    expect(find.text('What’s your\ndate of birth?'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('birth-month')), '1');
    await tester.enterText(find.byKey(const Key('birth-day')), '1');
    await tester.enterText(find.byKey(const Key('birth-year')), '2000');
    await tester.pump();
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    final visibleText = tester
        .widgetList<Text>(find.byType(Text))
        .map((widget) => widget.data ?? '')
        .join(' | ');
    expect(
      find.text('Welcome to the\nworld of J’Donuts!'),
      findsOneWidget,
      reason: 'Current route text: $visibleText',
    );

    await tester.tap(find.text('LET’S EXPLORE'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Hania Tester'), findsOneWidget);
    expect(find.text('Seasonal specials'), findsOneWidget);

    await tester.tap(find.text('Blueberry Glaze').first);
    await tester.pumpAndSettle();
    expect(find.text('DON-002'), findsOneWidget);
    expect(
      find.text('A fluffy donut topped with blueberry glaze.'),
      findsOneWidget,
    );
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

class _RegistrationAuthRepository implements AuthRepository {
  String? phone;
  AuthEntity? member;

  @override
  Future<Result<String?>> currentPhone() async => Success(phone);

  @override
  Future<Result<AuthEntity?>> profile(String phone) async => Success(member);

  @override
  Future<Result<bool>> isRegistered(String phone) async =>
      Success(this.phone == phone);

  @override
  Future<Result<bool>> login(String phone) async {
    this.phone = phone;
    return const Success(true);
  }

  @override
  Future<Result<void>> logout() async {
    phone = null;
    return const Success(null);
  }

  @override
  Future<Result<void>> register(AuthEntity member) async {
    this.member = member;
    phone = member.phone;
    return const Success(null);
  }
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
    'imageUrl': '',
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
    'imageUrl': '',
  },
];
