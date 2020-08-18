import 'dart:convert';
import 'dart:io';

import 'models/client.dart';
import 'models/key_pair_exchange_message.dart';
import 'models/message.dart';

void main() async {
  var client = Client();

  // ignore: unawaited_futures
  Future.delayed(const Duration(seconds: 1)).then(
    (_) {
      var keyPairExchangeMessage = KeyPairExchangeMessage(
        type: MessageType.keyPairExchange,
        keyPair: client.getPublicKey(),
      );

      var jsonEncoded = jsonEncode(keyPairExchangeMessage.toJson());

      client.sendMessage(jsonEncoded);
    },
  );

  stdin.transform(Utf8Decoder()).transform(LineSplitter()).listen(
    (message) {
      client.sendMessage(message);
    },
  );
}
