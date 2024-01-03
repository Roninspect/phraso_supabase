import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ConnectivityStatus { notDetermined, isConnected, isDisconnected }

final connectionStateNotifierProvider =
    StateNotifierProvider<ConnectionStateNotifier, ConnectivityStatus>((ref) {
  return ConnectionStateNotifier();
});

class ConnectionStateNotifier extends StateNotifier<ConnectivityStatus> {
  ConnectionStateNotifier() : super(ConnectivityStatus.notDetermined) {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        state = ConnectivityStatus.isConnected;
      } else if (result == ConnectivityResult.none) {
        state = ConnectivityStatus.isDisconnected;
      }
    });
  }
}
