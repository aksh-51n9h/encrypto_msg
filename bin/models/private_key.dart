import 'encryption_key.dart';

class PrivateKey extends EncryptionKey {
  PrivateKey(List<BigInt> keyPair) : super(keyPair: keyPair);

  BigInt get n => keyPair[0];
  BigInt get d => keyPair[1];
}
