import 'dart:convert';
import 'dart:math';

void main() {
  var message = 'hello world!';

  var p = BigInt.from(53);
  var q = BigInt.from(59);

  var asciiCodec = AsciiCodec();

  var publicKey = getPublicKey(p, q);
  var n = publicKey[0].toInt();
  var e = publicKey[1].toInt();

  var d = getPrivateKey(p, q).toInt();

  var encodeList =
      asciiCodec.encode(message).map((element) => element.toInt()).toList();
  print(encodeList);

  var temp = asciiCodec
      .encode(message)
      .map((element) => BigInt.from(pow(element, e) % n))
      .toList();

  var encryptedList = temp.map((e) => e.toInt()%125).toList();

  print(encryptedList);
  var encryptedMessage = asciiCodec.decode(encryptedList);

  print(encryptedMessage);

  var decodeList = temp.map((BigInt element) => element.pow(d)).toList();

  var finalList = decodeList
      .map((BigInt element) => (element % BigInt.from(n)).toInt())
      .toList();

  print(finalList);

  var decryptedMessage = asciiCodec.decode(finalList);
  print(decryptedMessage);
}

BigInt getN(BigInt p, BigInt q) {
  return p * q;
}

BigInt getPhiN(BigInt p, BigInt q) {
  return (p - BigInt.one) * (q - BigInt.one);
}

BigInt gcd(BigInt p, BigInt q) {
  if (q == BigInt.zero) {
    return p;
  }

  return gcd(q, p % q);
}

Iterable<BigInt> get positiveIntegers sync* {
  var i = BigInt.zero;
  while (true) {
    i = i + BigInt.one;
    yield i;
  }
}

BigInt getE(BigInt p, BigInt q) {
  var phiN = getPhiN(p, q);

  var temp = positiveIntegers
      .skipWhile((value) {
        return value < BigInt.two;
      })
      .take((phiN - BigInt.two).toInt())
      .toList();

  var e = BigInt.zero;

  for (e in temp) {
    if (gcd(e, phiN) == BigInt.one) {
      break;
    }
  }

  return e;
}

List<BigInt> getPublicKey(BigInt p, BigInt q) {
  return [getN(p, q), getE(p, q)];
}

BigInt getPrivateKey(BigInt p, BigInt q) {
  var i = BigInt.one;

  var temp = positiveIntegers.skip(1).take(11).toList();

  for (i in temp) {
    var x = BigInt.one + (i * getPhiN(p, q));

    if (x % getE(p, q) == BigInt.zero) {
      return x ~/ getE(p, q);
    }
  }

  return BigInt.zero;
}
