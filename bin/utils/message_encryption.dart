import 'dart:convert';
import 'dart:io';

import 'dart:math';

import 'prime_generator.dart';

class MessageEncryption {
  List<BigInt> privateKey;
  List<BigInt> publicKey;

  MessageEncryption() {
    var p = BigInt.from(53);
    var q = BigInt.from(59);

    print('$p $q');

    publicKey = _getPublicKey(p, q);
    privateKey = _getPrivateKey(p, q);

    print('Public key : $publicKey');
    print('Private key : $privateKey');
  }

  BigInt _getN(BigInt p, BigInt q) {
    return p * q;
  }

  BigInt _getPhiN(BigInt p, BigInt q) {
    return (p - BigInt.one) * (q - BigInt.one);
  }

  BigInt _gcd(BigInt p, BigInt q) {
    if (q == BigInt.zero) {
      return p;
    }

    return _gcd(q, p % q);
  }

  List<BigInt> _eea(BigInt p, BigInt q) {
    if (p % q == BigInt.zero) {
      return [q, BigInt.zero, BigInt.one];
    } else {
      var l = _eea(q, p % q);
      l[1] = l[1] - ((p ~/ q) * l[2]);
      return [l[0], l[2], l[1]];
    }
  }

  BigInt _multiInv(BigInt p, BigInt q) {
    var l = _eea(p, q);
    var gcd = l[0];
    var s = l[1];

    if (gcd != BigInt.one) {
      return BigInt.zero;
    } else {
      return s % q;
    }
  }

  Iterable<BigInt> get positiveIntegers sync* {
    var i = BigInt.zero;
    while (true) {
      i = i + BigInt.one;
      yield i;
    }
  }

  BigInt _getE(BigInt p, BigInt q) {
    var e = BigInt.zero;

    var i = BigInt.one;

    while (i < BigInt.from(1e2)) {
      if (_gcd(i, _getPhiN(p, q)) == BigInt.one) {
        e = i;
      }
      i = i + BigInt.one;
    }

    return e;
  }

  List<BigInt> _getPublicKey(BigInt p, BigInt q) {
    return [_getN(p, q), _getE(p, q)];
  }

  List<BigInt> _getPrivateKey(BigInt p, BigInt q) {
    return [_getN(p, q), _multiInv(p, q)];
  }

  List<BigInt> encryptMessage(String message, List<BigInt> publicKey) {
    var n = publicKey[0];
    var e = publicKey[1];

    var encodeList = utf8.encode(message);

    var encryptedList = encodeList.map((element) {
      return BigInt.from(element).modPow(e, n);
    }).toList();

    return encryptedList;
  }

  List<int> decryptMessage(
      List<BigInt> encryptedMessage, List<BigInt> privateKey) {
    var n = privateKey[0];
    var d = privateKey[1];

    var decodeList = encryptedMessage.map((BigInt element) {
      return element.modPow(d, n).toInt();
    }).toList();

    return decodeList;
  }

  void gcd(BigInt p, BigInt q) {
    print(_gcd(p, q));
  }
}

void main(List<String> args) {
  var messageEncryption = MessageEncryption();

  var message = 'a';

  var encryptedMessage =
      messageEncryption.encryptMessage(message, messageEncryption.publicKey);

  var decryptedMessage = messageEncryption.decryptMessage(
      encryptedMessage, messageEncryption.privateKey);

  var l = utf8.decode(encryptedMessage.map((e) {
    return (e % BigInt.from(128)).toInt();
  }).toList());

  print('Original message :  $message');

  print('Original utf8 encode : ${utf8.encode(message)}');

  print('Encoded message : ${encryptedMessage}');

  print('Decoded message : ${decryptedMessage}');
}
