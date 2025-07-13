import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late io.Socket socket;
  static const String androidEmulator = 'http://10.0.2.2:8080';
  static const String iosEmulator = 'http://127.0.0.1:8080';
  var logger = Logger();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal() {
    socket = io.io(
      iosEmulator, // if using Android emulator, NOT localhost
      io.OptionBuilder().setTransports([
        'websocket',
      ]).build(), // force WebSocket transport
    );

    socket.onConnect((_) {
      logger.d('Connected to server ${socket.id}');
    });

    socket.onConnectError((err) => logger.d('Connect Error: $err'));
    socket.onError((err) => logger.d('Error: $err'));
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }
}
