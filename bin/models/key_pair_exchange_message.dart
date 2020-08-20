import 'message.dart';

class KeyPairExchangeMessage extends Message {
  final List<BigInt> keyPair;

  KeyPairExchangeMessage({MessageType type, this.keyPair}) : super(type: type);

  factory KeyPairExchangeMessage.fromJson(dynamic json) {
    return KeyPairExchangeMessage(
      type: MessageType.values[json['type']],
      keyPair: [
        BigInt.parse(json['0'], radix: 10),
        BigInt.parse(json['1'], radix: 10),
      ],
    );
  }

  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json['0'] = keyPair[0].toString();
    json['1'] = keyPair[1].toString();

    return json;
  }
}
