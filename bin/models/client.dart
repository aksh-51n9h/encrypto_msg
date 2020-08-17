import 'dart:io';

class Client {
  WebSocket _socket;

  Client() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _socket = await WebSocket.connect('ws://127.0.0.1:4042');

      if (_socket != null) {
        print('Connection established!');

        await _addListener();
      }
    } catch (error) {
      print('Some error has occured! ERROR:$error');
    }
  }

  void _addListener() {
    if (_socket != null) {
      _socket.listen(
        _handleData,
        onDone: _closeConnection,
        onError: _handleError,
        cancelOnError: true,
      );
    }
  }

  void _handleData(Object event) {
    print('Event received: $event');
  }

  void _closeConnection() async {
    await _socket.close();
    print('Connection closed!');
  }

  void _handleError(Object error) {
    print('Some error has occured! Now connection will be closed.');
    print('ERROR:$error');
    _closeConnection();
  }
}
