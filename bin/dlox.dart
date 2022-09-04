// TODO: https://craftinginterpreters.com/scanning.html#recognizing-lexemes

import 'dart:io';

import 'package:dlox/lox.dart';

var hadError = false;

void main(List<String> args) {
  if (args.length > 1) {
    print('Usage: dlox [script]');
    exit(64);
  } else if (args.length == 1) {
    Lox.runFile(args[0]);
  } else {
    Lox.runPrompt();
  }
}
