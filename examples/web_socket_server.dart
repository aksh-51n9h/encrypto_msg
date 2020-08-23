import 'dart:convert';
import 'dart:io';

void main() async {
  var address = InternetAddress.loopbackIPv4;
  var port = 4042;

  var server = await HttpServer.bind(address, port);

  print('Sever started at ${server.address.address}:${server.port}');

  server.listen((HttpRequest request) async {
    print('Incoming request from ${request.connectionInfo.remoteAddress}');

    var webSocket = await WebSocketTransformer.upgrade(request);

    webSocket.listen((data) {
      print(
          'Message from ${request?.connectionInfo?.remoteAddress}  --> ${data}');

      webSocket.add('Message recieved!');
    });
  });
}
