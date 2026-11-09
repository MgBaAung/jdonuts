import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/result.dart';
import '../auth/domain/auth_usecase.dart';
import '../auth/presentation/auth_screens.dart';
import '../home/presentation/home_screen.dart';
import '../home/presentation/banner_bloc.dart';
import '../home/presentation/home_bottom_cubit.dart';
import '../shared/motion.dart';
import '../product/data/product_model.dart';
import '../product/domain/product.dart';
import '../product/presentation/product_bloc.dart';
import '../product/presentation/product_screen.dart';
import '../../base_architecture/state_management/bloc/api_state.dart';
import '../rewards/presentation/rewards_bloc.dart';
import '../rewards/presentation/rewards_screen.dart';
import '../shop/presentation/shop_bloc.dart';
import 'app_route_args.dart';

GoRouter createJDonutsRouter({
  required AuthUsecase auth,
  required ProductBloc Function() createProductBloc,
  required BannerBloc Function() createBannerBloc,
  required RewardsBloc Function() createRewardsBloc,
  required ShopBloc Function() createShopBloc,
}) => GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final session = await auth.currentPhone();
    final phone = switch (session) {
      Success<String?>(:final value) => value,
      Failed<String?>() => null,
    };
    final path = state.matchedLocation;
    if (path == '/') return phone == null ? '/onboarding' : '/home';
    final protected =
        path == '/home' || path == '/rewards' || path.startsWith('/product/');
    if (phone == null && protected) return '/onboarding';
    if (phone != null &&
        const {
          '/onboarding',
          '/phone',
          '/otp',
          '/name',
          '/dob',
        }.contains(path)) {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          _page(context, state, const OnboardingScreen()),
    ),
    GoRoute(
      path: '/phone',
      pageBuilder: (context, state) => _page(
        context,
        state,
        PhoneScreen(registration: state.extra as bool? ?? true),
      ),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) {
        final args = state.extra! as OtpRouteArgs;
        return _page(
          context,
          state,
          OtpScreen(phone: args.phone, registration: args.registration),
        );
      },
    ),
    GoRoute(
      path: '/name',
      pageBuilder: (context, state) =>
          _page(context, state, NameScreen(phone: state.extra! as String)),
    ),
    GoRoute(
      path: '/dob',
      pageBuilder: (context, state) {
        final args = state.extra! as RegistrationRouteArgs;
        return _page(
          context,
          state,
          BirthDateScreen(
            phone: args.phone,
            firstName: args.firstName,
            lastName: args.lastName,
          ),
        );
      },
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) =>
          _page(context, state, WelcomeScreen(phone: state.extra! as String)),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _page(
        context,
        state,
        _SessionHome(
          auth: auth,
          createBannerBloc: createBannerBloc,
          createRewardsBloc: createRewardsBloc,
          createProductBloc: createProductBloc,
          createShopBloc: createShopBloc,
        ),
      ),
    ),
    GoRoute(
      path: '/product/:id',
      pageBuilder: (context, state) => _page(
        context,
        state,
        _ProductRoute(
          id: state.pathParameters['id']!,
          createBloc: createProductBloc,
        ),
      ),
    ),
    GoRoute(
      path: '/rewards',
      pageBuilder: (context, state) =>
          _page(context, state, _RewardsRoute(createBloc: createRewardsBloc)),
    ),
  ],
);

CustomTransitionPage<void> _page(
  BuildContext context,
  GoRouterState state,
  Widget child,
) => CustomTransitionPage<void>(
  key: state.pageKey,
  child: child,
  transitionDuration: MediaQuery.disableAnimationsOf(context)
      ? Duration.zero
      : MotionDurations.stepTransition,
  transitionsBuilder: (context, animation, secondary, child) =>
      MediaQuery.disableAnimationsOf(context)
      ? child
      : FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(
              Tween(
                begin: const Offset(.04, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: MotionCurves.sharedAxis)),
            ),
            child: child,
          ),
        ),
);

class _SessionHome extends StatelessWidget {
  const _SessionHome({
    required this.auth,
    required this.createBannerBloc,
    required this.createRewardsBloc,
    required this.createProductBloc,
    required this.createShopBloc,
  });
  final AuthUsecase auth;
  final BannerBloc Function() createBannerBloc;
  final RewardsBloc Function() createRewardsBloc;
  final ProductBloc Function() createProductBloc;
  final ShopBloc Function() createShopBloc;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => HomeBottomCubit()),
      BlocProvider(create: (_) => createBannerBloc()..loadBanners()),
      BlocProvider(create: (_) => createRewardsBloc()..loadRewards()),
      BlocProvider(create: (_) => createProductBloc()..loadProducts()),
      BlocProvider(create: (_) => createShopBloc()..loadShops()),
    ],
    child: HomeScreen(auth: auth),
  );
}

class _ProductRoute extends StatelessWidget {
  const _ProductRoute({required this.id, required this.createBloc});
  final String id;
  final ProductBloc Function() createBloc;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => createBloc()..loadProducts(),
    child: _ProductRouteView(id: id),
  );
}

class _ProductRouteView extends StatelessWidget {
  const _ProductRouteView({required this.id});
  final String id;

  @override
  Widget build(BuildContext context) => BlocBuilder<ProductBloc, ApiState>(
    builder: (context, state) {
      if (state is ApiLoading || state is ApiInitial)
        return const _LoadingPage();
      if (state is ApiFailure) return _RouteError(message: state.message);
      if (state is ApiSuccess<List<ProdcutModel>>) {
        final matches = state.data.where((product) => product.id == id);
        if (matches.isEmpty)
          return const _RouteError(message: 'Product not found.');
        final item = matches.first;
        return ProductScreen(
          product: DonutProduct(
            id: item.id ?? id,
            code: item.code ?? '',
            name: item.name ?? '',
            description: item.description ?? '',
            price: item.priceMmk ?? 0,
            color: item.color ?? 0,
            emoji: item.emoji ?? '🍩',
            imageUrl: item.imageUrl ?? '',
            imageAsset: item.imageAsset,
            isNew: item.discountPercent != null,
            discountPercent: item.discountPercent,
            isSeasonalSpecial: item.isSeasonalSpecial,
            isPopular: item.isPopular,
            isOrderAgain: item.isOrderAgain,
            isExploreNow: item.isExploreNow,
          ),
        );
      }
      return const _LoadingPage();
    },
  );
}

class _RewardsRoute extends StatelessWidget {
  const _RewardsRoute({required this.createBloc});
  final RewardsBloc Function() createBloc;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => createBloc()..loadRewards(),
    child: const RewardsBlocView(),
  );
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _RouteError extends StatelessWidget {
  const _RouteError({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message),
          TextButton(
            onPressed: () => context.go('/home'),
            child: const Text('Go home'),
          ),
        ],
      ),
    ),
  );
}
