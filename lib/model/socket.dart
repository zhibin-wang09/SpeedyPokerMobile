import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  late IO.Socket socket;
  static const String androidEmulator = 'http://10.0.2.2:3000';
  static const String iosEmulator = 'http://127.0.0.1:3000';

  factory SocketService() {
    return _instance;
  }

  SocketService._internal() {
    socket = IO.io(
      iosEmulator, // if using Android emulator, NOT localhost
      IO.OptionBuilder().setTransports([
        'websocket',
      ]).build(), // force WebSocket transport
    );

    socket.onConnect((_) {
      print('Connected to Socket.IO');
    });

    socket.onConnectError((err) => print('Connect Error: $err'));
    socket.onError((err) => print('Error: $err'));
  }

  void emit(String event, dynamic data){
    socket.emit(event, data);
  }
}