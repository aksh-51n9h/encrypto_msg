import 'dart:convert';
import 'dart:io';

void main() async {
  var webSocket = await WebSocket.connect('ws://127.0.0.1:4042');
  webSocket.listen((data) {
    print('Message --> ${data}');
  });

  webSocket.add('Hello World!');
}
