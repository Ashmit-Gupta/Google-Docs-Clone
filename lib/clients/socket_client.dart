import 'package:google_docs_clone/constants/constants.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  io.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = io.io(kHost, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.onConnect((_) {
      Logger().i('Connected to the socket server');
    });

    socket!.onConnectError((err) {
      Logger().e('Socket connection error: $err');
    });
    
    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
