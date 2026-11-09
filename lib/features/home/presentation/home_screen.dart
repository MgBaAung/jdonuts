import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonutscodetest/core/result.dart';
import 'package:jdonutscodetest/features/home/presentation/component/explore_shop_item.dart';
import 'package:jdonutscodetest/global/app_theme.dart';
import 'package:jdonutscodetest/global/extension/num_extension.dart';

import '../../../base_architecture/state_management/bloc/api_state.dart';
import '../../auth/domain/auth_usecase.dart';
import '../../auth/domain/auth_entity.dart';
import '../../home/data/banner_model.dart';
import '../../shared/motion.dart';
import '../../product/data/product_model.dart';
import '../../product/domain/product.dart';
import '../../product/presentation/product_bloc.dart';
import '../../rewards/presentation/rewards_bloc.dart';
import '../../rewards/presentation/rewards_screen.dart';
import '../../shared/presentation/widgets.dart';
import '../../shop/data/shop_model.dart';
import '../../shop/presentation/shop_bloc.dart';
import 'banner_bloc.dart';
import 'home_bottom_cubit.dart';
import 'component/order_again_item.dart';
import 'component/popular_product_item.dart';
import 'component/seasonal_special_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.auth});

  final AuthUsecase auth;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int bannerIndex = 0;
  late final PageController bannerController;
  Timer? bannerTimer;
  late final Future<AuthEntity?> memberProfile;
  Color appBarColor = Color(0xffffeddd);

  @override
  void initState() {
    super.initState();
    memberProfile = _loadMemberProfile();
    bannerController = PageController(viewportFraction: .91);
    if (!WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations) {
      bannerTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!mounted || !bannerController.hasClients) return;
        final state = context.read<BannerBloc>().state;
        if (state is! ApiSuccess<List<BannerModel>> || state.data.isEmpty) {
          return;
        }
        bannerIndex = (bannerIndex + 1) % state.data.length;
        bannerController.animateToPage(
          bannerIndex,
          duration: MotionDurations.tabSwitch,
          curve: MotionCurves.entrance,
        );
      });
    }
  }

  @override
  void dispose() {
    bannerTimer?.cancel();
    bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<HomeBottomCubit, int>(
    builder: (context, selectedTab) {
      if (selectedTab == 0) {
        appBarColor = Color(0xffffeddd);
      } else {
        appBarColor = Colors.transparent;
      }
      return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: appBarColor),
          backgroundColor: appBarColor,
          toolbarHeight: 0,
        ),
        backgroundColor: const Color(0xfff3f4f6),
        body: SafeArea(child: _selectedPage(selectedTab)),
        bottomNavigationBar: _HomeBottomNavigation(
          selectedIndex: selectedTab,
          onSelected: context.read<HomeBottomCubit>().selectTab,
        ),
      );
    },
  );

  Widget _selectedPage(int selectedTab) => switch (selectedTab) {
    0 => _homePage(),
    1 => const RewardsBlocView(),
    2 => _shopsPage(),
    3 => const Center(child: Text('Your orders')),
    _ => Center(
      child: FilledButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout),
        label: const Text('Sign out'),
      ),
    ),
  };

  Widget _homePage() => RefreshIndicator(
    onRefresh: _refresh,
    child: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _memberHeader()),
        BlocBuilder<ProductBloc, ApiState>(
          builder: (context, state) {
            if (state is ApiFailure) {
              return SliverToBoxAdapter(child: _error(state.message));
            }
            if (state is! ApiSuccess<List<ProdcutModel>>) {
              return const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final products = state.data.map(_toProduct).toList();
            return SliverList.list(
              children: [
                _section(
                  'Seasonal specials',
                  products.where((p) => p.isSeasonalSpecial).toList(),
                  _ProductCollection.seasonal,
                ),
                _section(
                  'Popular 🔥',
                  products.where((p) => p.isPopular).toList(),
                  _ProductCollection.popular,
                ),
                _section(
                  'Order again',
                  products.where((p) => p.isOrderAgain).toList(),
                  _ProductCollection.orderAgain,
                ),
              ],
            );
          },
        ),
        SliverToBoxAdapter(child: _exploreSection()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    ),
  );

  Future<AuthEntity?> _loadMemberProfile() async {
    final phoneResult = await widget.auth.currentPhone();
    if (phoneResult case Success<String?>(:final value)) {
      final phone = value;
      if (phone == null || phone.isEmpty) return null;
      final profileResult = await widget.auth.profile(phone);
      if (profileResult case Success<AuthEntity?>(:final value)) return value;
    }
    return null;
  }

  Widget _memberHeader() => FutureBuilder<AuthEntity?>(
    future: memberProfile,
    builder: (context, snapshot) {
      final member = snapshot.data;
      final name = member == null
          ? 'Donut lover'
          : '${member.firstName} ${member.lastName}'.trim();
      final remaining = member == null
          ? 1290
          : (member.nextTierPoints - member.points).clamp(0, 999999999);
      final initials = member == null || member.firstName.isEmpty
          ? 'J'
          : member.firstName.substring(0, 1).toUpperCase();
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
        decoration: const BoxDecoration(
          color: Color(0xffffeddd),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xfff7a266), Color(0xffed4e9c)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 24,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                          color: Color(0xff24212a),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${member?.tier ?? 'Bronze'} member',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff6c6670),
                        ),
                      ),
                    ],
                  ),
                ),

                Material(
                  color: const Color(0xfffa7b18),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                  ),
                  child: InkWell(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          (member?.notifications ?? 0) == 0
                              ? 'You are all caught up.'
                              : 'You have ${member!.notifications} notifications.',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(22),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 9,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 18,
                            height: 18,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${member?.notifications ?? 0}',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Color(0xfffa7b18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            14.height,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .92),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$remaining points left to become Gold Member',
                style: const TextStyle(fontSize: 12, color: Color(0xff55515a)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            20.height,
            SizedBox(height: 145, child: _bannerView()),
          ],
        ),
      );
    },
  );

  Widget _bannerView() => BlocBuilder<BannerBloc, ApiState>(
    builder: (context, state) {
      if (state is ApiFailure) return _error(state.message);
      if (state is! ApiSuccess<List<BannerModel>>) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state.data.isEmpty) {
        return const Center(child: DonutIllustration(size: 70));
      }
      return PageView.builder(
        controller: bannerController,
        itemCount: state.data.length,
        onPageChanged: (index) => setState(() => bannerIndex = index),
        itemBuilder: (context, index) {
          final banner = state.data[index];
          return Container(
            margin: const EdgeInsets.only(left: 0, right: 8, top: 5, bottom: 0),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Color(banner.color ?? 0xffd26376),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        banner.title ?? '',
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        banner.subtitle ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                OfflineImage(
                  asset: banner.imageAsset ?? "",
                  width: 82,
                  height: 82,
                  fallback: const DonutIllustration(size: 70),
                ),
              ],
            ),
          );
        },
      );
    },
  );

  Widget _section(
    String title,
    List<DonutProduct> products,
    _ProductCollection collection,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      if (products.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('No items available yet.'),
        )
      else
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _collectionItem(collection, products[index]),
          ),
        ),
    ],
  );

  Widget _exploreSection() => BlocBuilder<ShopBloc, ApiState>(
    builder: (context, shopState) {
      final shops = shopState is ApiSuccess<List<ShopModel>>
          ? shopState.data
          : null;
      final shopList = shops ?? const <ShopModel>[];
      return Container(
        margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
        padding: const EdgeInsets.only(top: 30, bottom: 16),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/explore.jpeg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      shops == null
                          ? 'Find a J’Donut shop near you!😋'
                          : 'There are ${shops.length} J’Donut shops near you!😋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: 16.leftSpacing,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.read<HomeBottomCubit>().selectTab(2),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                    child: Text(
                      'EXPLORE NOW',
                      style: TextStyle(
                        color: Color(0xff39bdd4),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .4,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            20.height,
            if (shopState is ApiFailure)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TextButton(
                  onPressed: () => context.read<ShopBloc>().loadShops(),
                  child: const Text(
                    'Could not load shops. Tap to retry.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            else if (shopState is ApiInitial || shopState is ApiLoading)
              const SizedBox(
                height: 270,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            else if (shopList.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'No nearby shops available yet.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            else
              SizedBox(
                height: 286,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: shopList.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (context, index) =>
                      ExploreShopItem(shop: shopList[index]),
                ),
              ),
          ],
        ),
      );
    },
  );

  Widget _collectionItem(_ProductCollection collection, DonutProduct product) {
    final onTap = () => context.push('/product/${product.id}');
    if (collection == _ProductCollection.seasonal) {
      return SeasonalSpecialItem(product: product, onTap: onTap);
    }
    if (collection == _ProductCollection.orderAgain) {
      return OrderAgainItem(product: product, onTap: onTap);
    }
    return PopularProductItem(product: product, onTap: onTap);
  }

  DonutProduct _toProduct(ProdcutModel model) => DonutProduct(
    id: model.id ?? '',
    code: model.code ?? '',
    name: model.name ?? '',
    description: model.description ?? '',
    price: model.priceMmk ?? 0,
    color: model.color ?? 0xfff1c7ce,
    emoji: model.emoji ?? '🍩',
    imageUrl: model.imageUrl ?? '',
    imageAsset: model.imageAsset,
    discountPercent: model.discountPercent,
    isSeasonalSpecial: model.isSeasonalSpecial,
    isPopular: model.isPopular,
    isOrderAgain: model.isOrderAgain,
    isExploreNow: model.isExploreNow,
  );

  Widget _shopsPage() => BlocBuilder<ShopBloc, ApiState>(
    builder: (context, state) {
      if (state is ApiFailure) return _error(state.message);
      if (state is! ApiSuccess<List<ShopModel>>) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Nearby shops',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          ...state.data.map(
            (shop) => Card(
              child: ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: Text(shop.name ?? 'J’Donuts'),
                subtitle: Text(
                  [shop.address, shop.township]
                          .whereType<String>()
                          .where((part) => part.trim().isNotEmpty)
                          .join(', ') +
                      (shop.distance == null ? '' : ' · ${shop.distance}'),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget _error(String message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          TextButton(onPressed: _reload, child: const Text('Retry')),
        ],
      ),
    ),
  );

  Future<void> _refresh() async {
    _reload();
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }

  void _reload() {
    context.read<ProductBloc>().loadProducts();
    context.read<BannerBloc>().loadBanners();
    context.read<ShopBloc>().loadShops();
    context.read<RewardsBloc>().loadRewards();
  }

  Future<void> _logout() async {
    final result = await widget.auth.logout();
    if (mounted && result is Success<void>) context.go('/onboarding');
  }
}

enum _ProductCollection { seasonal, popular, orderAgain }

class _HomeBottomNavigation extends StatelessWidget {
  const _HomeBottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.workspace_premium_outlined, label: 'Rewards'),
    (icon: Icons.storefront_outlined, label: 'Shops'),
    (icon: Icons.account_balance_wallet_outlined, label: 'Orders'),
    (icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 18),
    decoration: const BoxDecoration(
      color: Color(0xff53c9e0),
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (var index = 0; index < _items.length; index++)
                _item(context, index, _items[index]),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _item(
    BuildContext context,
    int index,
    ({IconData icon, String label}) item,
  ) {
    final selected = index == selectedIndex;
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: () => onSelected(index),
        borderRadius: BorderRadius.circular(30),
        child: Center(
          child: AnimatedContainer(
            duration: MotionDurations.tabSwitch,
            curve: MotionCurves.entrance,
            padding: selected
                ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                : const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: selected ? const Color(0xffed4e9c) : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: selected
                  ? Border.all(color: Colors.white, width: 1.5)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 21, color: Colors.white),
                if (selected) ...[
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
