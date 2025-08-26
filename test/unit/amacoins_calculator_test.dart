import 'package:flutter_test/flutter_test.dart';

int award(int base, {int bonus = 0}) => base + bonus;

void main() {
  test('calcula AmaCoins', () {
    expect(award(100, bonus: 20), 120);
  });
}
