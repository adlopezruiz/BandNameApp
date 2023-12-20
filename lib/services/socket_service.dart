import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  // Getters
  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    _socket = IO.io(
        'http://10.0.2.2:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    // socket.on('nuevo-mensaje', (data) {
    //   print('Nuevo mensaje: ');
    //   print('Nombre: ${data['nombre']}');
    //   print('Mensaje: ${data['mensaje']}');
    //   print(data.containsKey('mensaje2') ? data['mensaje2'] : 'No hay data');
    // });
  }
}
