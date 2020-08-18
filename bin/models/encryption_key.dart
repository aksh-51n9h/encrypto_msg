class EncryptionKey {
  final List<BigInt> keyPair;

  EncryptionKey({this.keyPair});

  factory EncryptionKey.fromJson(dynamic json) {
    return EncryptionKey();
  }

  Map<String, dynamic> toJson() {
    return {
      '0': keyPair[0].toString(),
      '1': keyPair[1].toString(),
    };
  }
}
