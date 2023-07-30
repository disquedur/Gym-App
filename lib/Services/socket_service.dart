import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:injectable/injectable.dart';

@injectable
class SocketService {
  static late IO.Socket socket;
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  void connect() {
    socket = IO.io(
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      },
    );

    socket.connect();

    socket.on("connect", (_) {
      print("Socket connected");
    });

    socket.on("connect_error", (err) {
      print("connect_error due to ${err.message}");
    });

    socket.on("disconnect", (_) {
      print("disconnected Socket");
    });
  }

  void disconnect() {
    socket.disconnect();
    print("disconnected Socket");
  }

  void send(String event, [dynamic data]) {
    print("In send socket $event");
    if (!isSocketAlive()) connect();
    if (data != null) {
      socket.emit(event, data);
    } else {
      socket.emit(event);
    }
  }

  get socketId {
    return socket.id;
  }

  get userSocket {
    return socket;
  }

  bool isSocketAlive() {
    return socket.id != null && socket.connected;
  }

  void on(String event, dynamic Function(dynamic) action) {
    print("setting on $event");
    socket.on(event, action);
  }
}
