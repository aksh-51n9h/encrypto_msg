import 'dart:io';

import 'dart:math';

void main() {
  var file = File('./bin/utils/primes.txt');

  var startTime = DateTime.now();

  var numberList = List<BigInt>.generate(
      sqrt(1e7).toInt(), (index) => BigInt.from(index + 2),
      growable: false);

  for (var i = 0; i < numberList.length; i++) {
    if (numberList[i] == BigInt.zero) {
      continue;
    }

    for (var j = numberList.indexOf(numberList[i]) + 1;
        j < numberList.length;
        j++) {
      if (numberList[j] != BigInt.zero &&
          numberList[j] % numberList[i] == BigInt.zero) {
        numberList[j] = BigInt.zero;
      }
    }
  }

  var primeList =
      numberList.where((element) => element != BigInt.zero).toList().join(",");

  var endTime = DateTime.now();

  print(endTime.difference(startTime).inMilliseconds);

  file.writeAsStringSync(primeList);
}
