import 'dart:convert';
import 'dart:io';

import '../utils/message_encryption.dart';
import 'client_api.dart';

class Client implements ClientAPI {
  WebSocket _socket;
  MessageEncryption _messageEncryption;

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

      _messageEncryption = MessageEncryption();
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

  @override
  void sendMessage(String message) {
    var encodeList = utf8.encode(message);
    _socket.add(encodeList);
  }

  @override
  List<BigInt> getPublicKey() {
    return _messageEncryption.publicKey;
  }
}
