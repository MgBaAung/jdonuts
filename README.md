# J’Donuts Flutter App

A Flutter customer app prototype for the Madivizion Flutter code test. It includes a local fake-auth flow, an offline-seeded Home and Product detail experience, and a motion-led Rewards screen. No back end is required to run the demo.

## Toolchain

- Flutter 3.47.2 (stable)
- Dart 3.13.2
- Android and iOS are the target mobile platforms. The project also has macOS and web runners.

## Run locally

```sh
flutter pub get
flutter run
```

To select a simulator or emulator explicitly:

```sh
flutter devices
flutter run -d <device-id>
```

The app starts on Onboarding when signed out and opens Home when a Hive session is present.

## Demo authentication

- Start registration from **Let’s get started**, or use **Log In** for the returning-user flow.
- Use demo phone `09254135592` (normalized to `+959254135592`). The six-digit demo OTP is `123456` and is prefilled for this demo phone.
- A first-time registration proceeds through phone, OTP, name, date of birth, Welcome, then Home. A returning registered number goes from OTP to Home.
- The fake account and session are stored locally. Sign out from the Settings tab to clear the session.
- Social sign-in buttons show demo placeholder UI; they do not connect to providers.

## Architecture

The project uses feature-first folders, BLoC/Cubit for state management, GetIt for dependency injection, GoRouter for navigation, and Hive CE for local persistence. Feature domain models and repository contracts are kept separate from presentation code.

### Why the reusable `base_architecture` is here

`lib/base_architecture` holds the common infrastructure: master objects and entities, local/network data-source contracts, Hive data access, repository behavior, CRUD use cases, and the generic API BLoC. Feature modules reuse these pieces rather than copying the same CRUD and state-handling code or reshaping the core for every business feature.

This base architecture is designed to avoid repeatedly modifying the core structure for each feature, allowing you to implement required features as needed. When business logic differs, you can make adjustments within the respective feature's repository, use case, and BLoC. It supports a dual approach: using a generic base path for standard CRUD operations, while enabling feature-specific implementations or overrides when unique business rules are required. Therefore, this base_architecture can be reused in future projects as well.

In short, common infrastructure stays stable while business rules stay in their feature modules. Standard CRUD can follow the base implementation; special behavior can use feature-specific repositories, use cases, or BLoC handlers. This makes the base layer reusable in later projects.

### Folder map

```text
lib/
  base_architecture/
    core/                    # Base entity and master-object types
    data/                    # Local and network data-source abstractions
    domain/                  # Shared repositories and CRUD use cases
    state_management/bloc/   # Generic API events, states, and BaseBloc
  core/
    local/                   # Seeded JSON and Hive-backed local data
    network/                 # Connectivity/reachability monitor
    session/                 # Session-store interface and Hive adapter
    result.dart              # Typed success/failure result
  features/
    app/                     # GetIt registration and GoRouter setup
    auth/                    # Auth domain, local repository, and screens
    home/                    # Banner and Home presentation
    product/                 # Product data, domain, and detail view
    rewards/                 # Reward data, progress, and animated UI
    shop/                    # Shop data and presentation
    shared/                  # Reusable widgets and motion constants
assets/
  data/store_seed.json       # Bundled local products, banners, shops, rewards
  images/                    # Bundled artwork and offline image fallbacks
test/                        # Unit and widget tests
integration_test/            # App-flow integration test
```

### Base CRUD path and custom feature behavior

The common path is `Model/Entity → Repository → UseCase → BaseBloc → View`. For example, `ProductRepo` uses the shared local-storage repository and `ProductBloc` uses `BaseBloc` to load product lists. A feature with additional rules can put them in its repository/use case or add feature-specific BLoC events without placing business logic in a widget.

`appGetIt` is a separate GetIt instance for app-level auth, session, router, and connectivity services. `getIt` is used for feature repositories, use cases, BLoCs, and the shared image cache manager.

## Data and offline behavior

- `assets/data/store_seed.json` is bundled with the app. Startup seeds products, banners, shops, and rewards into typed Hive CE boxes; the member profile and session phone are stored in the local `j_donuts` box.
- Product, banner, shop, and reward views read through their BLoCs. No API server is configured or required for the demo.
- Product and shop records contain HTTPS `imageUrl` values. `CachedNetworkImage` uses the shared `b2bFreshMoeCache` manager (7-day stale period, up to 350 objects). Bundled image assets remain as placeholders/error fallbacks, so a cold offline launch still has artwork.
- The session uses `HiveSessionStore`; it is not stored in `flutter_secure_storage`.
- A connectivity monitor with a DNS probe is registered, but an offline banner and background online data refresh are not connected to Home. The demo has no back end to refresh from.

## Screens and motion

- Onboarding and auth: phone normalization and validation, OTP auto-advance/paste, a five-minute resend timer, three-attempt lockout, name/date validation, and local registration/login.
- Navigation: GoRouter has an auth redirect guard and a `/product/:id` route. Home, Rewards, Shops, Orders, and Settings tabs are shown; Orders is a placeholder.
- Home: member header, auto-playing banner carousel, Seasonal specials, Popular, Order again, and ShopBloc-driven Explore shop cards.
- Product detail: product code/name/price, quantity stepper, total-price feedback, and a local image fallback.
- Rewards: animated points ring/count-up, tier ladder, tabs, challenge progress artwork, staggered challenge entry, and Earn press feedback.
- Named motion durations and curves are in `lib/features/shared/motion.dart`. Route and Rewards motion respond to Reduce Motion; the banner auto-play is disabled when animations are disabled.

## Tests

```sh
flutter test
flutter test integration_test/home_flow_test.dart -d <device-id>
```

Current coverage includes auth validator examples, Hive/session behavior, product DTO mapping, Home tab selection, the Explore product-card widget, and one integration flow. The Explore product-card widget is retained but the Home Explore section now displays ShopBloc cards; that current shop-card view does not yet have a dedicated widget test. At the time of this README update, all 6 unit/widget tests passed and the integration test passed on macOS.

The integration scenario currently verifies **Home → Shops**. The code test asks for **Register → Home → Product detail**. Login/registration validation widget coverage and a full unit-test matrix for every validator rule are also still needed.

## Analyze

```sh
flutter analyze
```

At the time of this README update, analysis reports 22 lint diagnostics (warnings and info-level issues) and exits with a non-zero status. These include future handling in shared repository methods, `http` being used without a direct dependency declaration, type-parameter shadowing, `print` calls, and style lints. The project is not analyzer-clean yet.

## Build artifacts and recording

Build a release APK:

```sh
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`.

Build an iOS Simulator app and zip it:

```sh
flutter build ios --simulator --release
mkdir -p dist
ditto -c -k --sequesterRsrc --keepParent \
  build/ios/iphonesimulator/Runner.app \
  dist/JDonuts-iOS-Simulator.zip
```

The code test also requests a public Git repository and a 2–4 minute screen recording of registration, logout/login, Home, Product detail, Rewards, and airplane-mode behavior. These delivery items are not created by the app’s build/test commands and still need to be prepared for submission.

## Known gaps

- The integration test does not yet cover the requested registration-to-product journey.
- Login and registration widget validation tests and broader validator/use-case unit tests are missing.
- Home loading currently uses progress indicators rather than skeletons. Product sections share one product-list error state.
- Home does not show an offline banner or refresh remote catalog data; there is no configured back end.
- Rewards currently receives default points/tier values instead of consistently reading the signed-in member profile. Product “New” state should also be mapped from its own data field.
- Android/iOS release builds and the requested screen recording have not been produced as part of this README update.

## Time spent

Time spent was not tracked in the project, so it is not reported here.
