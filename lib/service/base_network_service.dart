import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';

class BaseNetworkService extends GetxController {
  late final FlutterP2pConnection p2p;

  BaseNetworkService() {
    p2p = FlutterP2pConnection();
  }

  @override
  void onClose() {
    p2p.unregister();
    super.onClose();
  }

  @override
  void dispose() {
    p2p.unregister();
    super.dispose();
  }
}
