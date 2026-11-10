import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonutscodetest/core/result.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_entity.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_repo.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_usecase.dart';
import 'package:jdonutscodetest/features/auth/presentation/auth_screens.dart';
import 'package:jdonutscodetest/features/auth/presentation/state_management/auth_flow_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('phone screen reports invalid input after submit', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: PhoneScreen(registration: true)),
    );
    await tester.enterText(find.byType(TextField), '123');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text('Enter a valid Myanmar phone number'), findsOneWidget);
  });

  testWidgets('OTP screen reports an incorrect code and counts attempts', (
    tester,
  ) async {
    await tester.pumpWidget(
      _withAuthCubit(
        const OtpScreen(phone: '+959123456789', registration: true),
      ),
    );

    final fields = find.byType(TextField);
    for (var index = 0; index < 6; index++) {
      await tester.enterText(fields.at(index), '0');
    }
    await tester.tap(find.text('VERIFY'));
    await tester.pump();

    expect(find.text('Incorrect code. 2 attempts remaining.'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(6));
  });

  testWidgets(
    'name screen validates required first name and allowed characters',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: NameScreen(phone: '+959254135592')),
      );

      await tester.tap(find.text('CONTINUE'));
      await tester.pump();
      expect(find.text('This field is required'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'Hania2');
      await tester.tap(find.text('CONTINUE'));
      await tester.pump();
      expect(find.text('Use letters and spaces only'), findsOneWidget);
    },
  );

  testWidgets('birth-date screen rejects an impossible calendar date', (
    tester,
  ) async {
    await tester.pumpWidget(
      _withAuthCubit(
        const BirthDateScreen(
          phone: '+959254135592',
          firstName: 'Hania',
          lastName: 'Tester',
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('birth-month')), '2');
    await tester.enterText(find.byKey(const Key('birth-day')), '29');
    await tester.enterText(find.byKey(const Key('birth-year')), '2019');
    await tester.pump();

    expect(find.text('Enter a valid calendar date'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });
}

Widget _withAuthCubit(Widget child) => BlocProvider(
  create: (_) => AuthFlowCubit(AuthUsecase(_UnusedAuthRepository())),
  child: MaterialApp(home: child),
);

class _UnusedAuthRepository implements AuthRepository {
  @override
  Future<Result<bool>> isRegistered(String phone) async => const Success(false);

  @override
  Future<Result<void>> register(AuthEntity member) async => const Success(null);

  @override
  Future<Result<void>> login(String phone) async => const Success(null);

  @override
  Future<Result<void>> logout() async => const Success(null);

  @override
  Future<Result<String?>> currentPhone() async => const Success(null);

  @override
  Future<Result<AuthEntity?>> profile(String phone) async =>
      const Success(null);
}
