import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Combines [connectivity_plus] with a real DNS probe.
class ConnectivityMonitor {
  ConnectivityMonitor({
    Connectivity? connectivity,
    Future<bool> Function()? probe,
  }) : _connectivity = connectivity ?? Connectivity(),
       _probe = probe ?? _lookupReachability;

  final Connectivity _connectivity;
  final Future<bool> Function() _probe;

  Stream<bool> get onStatusChanged async* {
    yield await isOnline();
    await for (final _ in _connectivity.onConnectivityChanged) {
      yield await isOnline();
    }
  }

  Future<bool> isOnline() async {
    final links = await _connectivity.checkConnectivity();
    final hasInterface = links.any(
      (link) =>
          link == ConnectivityResult.mobile ||
          link == ConnectivityResult.wifi ||
          link == ConnectivityResult.ethernet,
    );
    if (!hasInterface) return false;
    return _probe();
  }

  static Future<bool> _lookupReachability() async {
    try {
      final result = await InternetAddress.lookup(
        'example.com',
      ).timeout(const Duration(seconds: 2));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
