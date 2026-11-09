import 'package:jdonutscodetest/features/no_internet_screen.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static dynamic callData;
  static const loginPage = '/login';
  static const home = '/home';
  static const fruits = '/fruits';
  static const fruitDetail = '/fruitDetail';
  static const password = '/password';
  static const forget = '/forget';
  static const checkout = '/checkout';
  static const orderSummary = '/orderSummary';
  static const orderHistoryDetail = '/orderHistoryDetail';
  static const cartPage = '/cart';
  static const topup = '/topup';
  static const attchment = '/attachment';
  static const bookMark = '/bookMark';
  static const noInternet = '/noInternet';

  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case noInternet:
        return MaterialPageRoute(
          builder: (context) => NoInternetScreen(),
          settings: settings,
        );

      default:
        return null;
    }
  }
}
