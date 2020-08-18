import 'dart:convert';

void main() {
  var intList = List.generate(128, (index) => index);

  print(utf8.decode(intList));
}
