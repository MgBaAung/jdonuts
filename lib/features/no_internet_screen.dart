import 'dart:io';
import 'package:jdonutscodetest/global/app_route_constant.dart';
import 'package:jdonutscodetest/global/app_theme.dart';
import 'package:jdonutscodetest/global/custom_button.dart';
import 'package:jdonutscodetest/global/extension/text_extension.dart';
import 'package:jdonutscodetest/global/navigation_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi)) {
        _refreshData();
        NavigationService.instance.pushNamedAndRemoveUntil(AppRoute.home);
      }
    });
    super.initState();
  }

  void _refreshData() {
    // context.read<TopUpHistoryBloc>().getList(refresh: true);
    // context.read<CategoryBloc>().getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 100, color: Colors.grey.shade400),
              30.height,

              Text("No Internet Connection", style: context.bold(fSize: 24)),
              10.height,
              Text(
                "Please check your internet settings and try again.",
                textAlign: TextAlign.center,
                style: context.regular(fSize: 16, color: Colors.grey.shade600),
              ),
              40.height,

              CustomElevatedButton(
                btnLabel: "Retry",
                onPressedFun: () {
                  if (Platform.isIOS) {
                    Connectivity().checkConnectivity().then((result) {
                      if (result.contains(ConnectivityResult.mobile) ||
                          result.contains(ConnectivityResult.wifi)) {
                        _refreshData();
                        NavigationService.instance.pushNamedAndRemoveUntil(
                          AppRoute.home,
                        );
                      }
                    });
                  }
                },
                fSize: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
