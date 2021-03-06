import 'dart:convert';
import 'dart:io';

import 'models/key_pair_exchange_message.dart';
import 'models/message.dart';

void main() async {
  var address = InternetAddress.loopbackIPv4;
  var port = 4042;

  try {
    var server = await HttpServer.bind(address, port);

    print('Sever started at ${server.address.address}:${server.port}');

    server.listen(
      (HttpRequest request) async {
        var webSocket = await WebSocketTransformer.upgrade(request);

        // ignore: prefer_single_quotes
        print("Incoming request from ${request.connectionInfo.remoteAddress}");

        webSocket.listen(
          (data) {
            print(
                'Request from ${request?.connectionInfo?.remoteAddress}  --> ${utf8.decode(data)}');

            var json = jsonDecode(utf8.decode(data));

            var message = Message.fromJson(json);

            if (message.type == MessageType.keyPairExchange) {
              var clientPublicKeyPair = KeyPairExchangeMessage.fromJson(json);

              print(clientPublicKeyPair.toJson());
            }
          },
        );

        stdin.listen(
          (data) {
            webSocket.add('${utf8.decode(data)}');
          },
          onDone: () {
            print('Input stream closed.');
          },
          onError: (error) {
            // ignore: prefer_single_quotes
            print("Input stream error occurred. Error : ${error}");
          },
          cancelOnError: false,
        );
      },
    );
  } catch (error) {
    print('${error}');
  }
}

String readLine() {
  return stdin.readLineSync();
}
