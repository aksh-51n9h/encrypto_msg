import 'encryption_key.dart';

class PublicKey extends EncryptionKey {
  PublicKey(List<BigInt> keyPair) : super(keyPair: keyPair);

  BigInt get n => keyPair[0];
  BigInt get e => keyPair[1];
}
