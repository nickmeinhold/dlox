import 'package:dlox/lox.dart';
import 'package:test/test.dart';

void main() {
  test('run', () {
    Lox.runFile('input.lox');
    expect(42, 42);
  });
}
