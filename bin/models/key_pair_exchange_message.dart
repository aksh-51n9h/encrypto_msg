import 'message.dart';

class KeyPairExchangeMessage extends Message {
  final List<BigInt> keyPair;

  KeyPairExchangeMessage({MessageType type, this.keyPair}) : super(type: type);

  factory KeyPairExchangeMessage.fromJson(dynamic json) {
    return KeyPairExchangeMessage(
      type: MessageType.values[json['type']],
      keyPair: [BigInt.zero, BigInt.zero],
    );
  }

  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json['0'] = keyPair[0].toString();
    json['1'] = keyPair[1].toString();

    return json;
  }
}
