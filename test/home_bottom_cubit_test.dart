import 'package:flutter_test/flutter_test.dart';
import 'package:jdonutscodetest/features/home/presentation/home_bottom_cubit.dart';

void main() {
  group('HomeBottomCubit', () {
    test(
      'selects a tab and ignores duplicate or out-of-range selections',
      () async {
        final cubit = HomeBottomCubit();
        addTearDown(cubit.close);
        final emitted = <int>[];
        final subscription = cubit.stream.listen(emitted.add);
        addTearDown(subscription.cancel);

        cubit.selectTab(2);
        cubit.selectTab(2);
        cubit.selectTab(-1);
        cubit.selectTab(5);
        cubit.selectTab(4);
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state, 4);
        expect(emitted, [2, 4]);
      },
    );
  });
}
