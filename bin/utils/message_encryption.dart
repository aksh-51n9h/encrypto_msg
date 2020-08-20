import 'dart:convert';
import 'dart:io';

import 'dart:math';

import 'prime_generator.dart';

class MessageEncryption {
  List<BigInt> privateKey;
  List<BigInt> publicKey;

  MessageEncryption() {
    var p = getPrimeNumber();
    var q = getPrimeNumber();

    print('$p $q');

    publicKey = _getPublicKey(p, q);
    privateKey = _getPrivateKey(p, q);

    // print('Public key : $publicKey');
  }

  BigInt _getN(BigInt p, BigInt q) {
    return p * q;
  }

  BigInt _getPhiN(BigInt p, BigInt q) {
    return (p - BigInt.one) * (q - BigInt.one);
  }

  BigInt _gcd(BigInt p, BigInt q) {
    return p.gcd(q);
  }

  Iterable<BigInt> get positiveIntegers sync* {
    var i = BigInt.zero;
    while (true) {
      i = i + BigInt.one;
      yield i;
    }
  }

  BigInt _getE(BigInt p, BigInt q) {
    var phiN = _getPhiN(p, q);

    var temp = positiveIntegers
        .skipWhile((value) {
          return value < BigInt.two;
        })
        .take((phiN - BigInt.two).toInt())
        .toList();

    var e = BigInt.zero;

    for (e in temp) {
      if (_gcd(e, phiN) == BigInt.one) {
        break;
      }
    }

    return e;
  }

  List<BigInt> _getPublicKey(BigInt p, BigInt q) {
    return [_getN(p, q), _getE(p, q)];
  }

  List<BigInt> _getPrivateKey(BigInt p, BigInt q) {
    var i = BigInt.one;

    var temp = positiveIntegers.skip(1).take(11).toList();

    for (i in temp) {
      var x = BigInt.one + (i * _getPhiN(p, q));

      if (x % _getE(p, q) == BigInt.zero) {
        return [_getN(p, q), x ~/ _getE(p, q)];
      }
    }

    return [BigInt.zero, BigInt.zero];
  }

  List<BigInt> encryptMessage(String message, List<BigInt> publicKey) {
    var n = publicKey[0].toInt();
    var e = publicKey[1].toInt();

    var encodeList = utf8.encode(message);

    var encryptedList =
        encodeList.map((element) => BigInt.from(pow(element, e) % n)).toList();
    return encryptedList;
  }

  List<int> decryptMessage(
      List<BigInt> encryptedMessage, List<BigInt> privateKey) {
    var n = privateKey[0].toInt();
    var d = privateKey[1].toInt();

    var decodeList =
        encryptedMessage.map((BigInt element) => element.pow(d)).toList();

    var finalList = decodeList
        .map((BigInt element) => (element % BigInt.from(n)).toInt())
        .toList();

    return finalList;
  }
}

void main(List<String> args) {
  var messageEncryption = MessageEncryption();

  stdin.transform(Utf8Decoder()).transform(LineSplitter()).listen(
    (message) {
      var encryptedMessage = messageEncryption.encryptMessage(
          message, messageEncryption.publicKey);

      var decryptedMessage = messageEncryption.decryptMessage(
          encryptedMessage, messageEncryption.privateKey);

      print(
          'Encoded message : ${utf8.decode(encryptedMessage.map((e) => e.toInt() % 128).toList())}');

      print('Decoded message : ${utf8.decode(decryptedMessage)}');
    },
  );
}
