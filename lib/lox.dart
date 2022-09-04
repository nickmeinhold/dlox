import 'dart:io';

import 'scanner.dart';
import 'token.dart';

class Lox {
  static var hadError = false;

  static void runFile(String path) {
    String source = File(path).readAsStringSync();
    _run(source);
  }

  static void runPrompt() {
    for (;;) {
      print('> ');
      var line = stdin.readLineSync();
      if (line == null) break;
      _run(line);
    }
  }

  static void _run(String source) {
    Scanner scanner = Scanner(source);
    List<Token> tokens = scanner.scanTokens();

    // For now, just print the tokens.
    for (Token token in tokens) {
      print('$token\n');
    }
  }

  static void error(int line, String message) {
    _report(line, '', message);
  }

  static void _report(int line, String where, String message) {
    stderr.write('[line $line] Error$where: $message');
    hadError = true;
  }
}
