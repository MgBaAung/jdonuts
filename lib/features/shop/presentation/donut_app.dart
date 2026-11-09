import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonutscodetest/global/app_theme.dart';

import '../../auth/presentation/state_management/auth_flow_cubit.dart';
import '../../app/app_dependencies.dart';

class DonutApp extends StatelessWidget {
  const DonutApp({super.key});
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [BlocProvider(create: (_) => appGetIt<AuthFlowCubit>())],
    child: Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          title: "J'Donuts",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.customTheme,
          routerConfig: appGetIt<GoRouter>(),
        );
      },
    ),
  );
}
