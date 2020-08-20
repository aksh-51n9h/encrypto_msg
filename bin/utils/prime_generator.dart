import 'dart:math';

const PARTS = 16;

BigInt power(BigInt x, BigInt y, BigInt p) {
  var result = BigInt.one;

  x = x % p;
  while (y > BigInt.zero) {
    if ((y & BigInt.one) == BigInt.one) {
      result = (result * x) % p;
    }

    y = y >> 1;
    x = (x * x) % p;
  }

  return result;
}

bool millerTest(BigInt d, BigInt n) {
  var r = BigInt.from(Random().nextInt(100));
  var t = (n - BigInt.from(4)) * r;
  t = t ~/ BigInt.from(100);

  var a = BigInt.two + t;

  var x = power(a, d, n);

  if (x == BigInt.one || x == n - BigInt.one) {
    return true;
  }

  while (d != n - BigInt.one) {
    x = (x * x) % n;
    d = d * BigInt.two;

    if (x == BigInt.one) {
      return false;
    }

    if (x == n - BigInt.one) {
      return true;
    }
  }

  return false;
}

bool isPrime(BigInt n, BigInt k) {
  if (n <= BigInt.one || n == BigInt.from(4)) {
    return false;
  }

  if (n <= BigInt.from(3)) {
    return true;
  }

  var d = n - BigInt.one;

  while (d % BigInt.two == BigInt.zero) {
    d = d ~/ BigInt.two;
  }

  for (var i = 0; i < k.toInt(); i++) {
    if (!millerTest(d, n)) {
      return false;
    }
  }

  return true;
}

BigInt uniformRandom(BigInt bottom, BigInt top) {
  var rnd = Random();
  var res = BigInt.zero;
  do {
    res += BigInt.from(rnd.nextInt(1 << 16));
    res <<= 16;
  } while (res.compareTo(bottom) < 0 || res.compareTo(top) > 0);
  return res;
}

BigInt getRandomNumber() {
  var rand = Random();
  var combinedVal = BigInt.zero;

  for (var i = 0; i < PARTS; i++) {
    var part = rand.nextInt(1 << 16);
    combinedVal <<= 16;
    combinedVal += BigInt.from(part);
  }

  return combinedVal;
}

BigInt getPrimeNumber() {
  while (true) {
    var number = getRandomNumber();

    if (isPrime(number, BigInt.from(100))) {
      return number;
    }
  }
}

void main(List<String> args) {
  var x = getPrimeNumber();
  // print("${isPrime(BigInt.from(7), BigInt.from(4))}");
  print(x);
  // var x = getRandomNumber();

  // var i = 0;
  // print(x);
  // while (i < 100) {
  //   var a = BigInt.two +
  //       (x - BigInt.from(4)) * BigInt.from(1 + Random().nextInt(10));

  //   a = a ~/ BigInt.from(10);
  //   print('$a ${a > BigInt.two} ${a < x}');
  //   i++;
  // }
}
