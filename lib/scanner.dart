import 'lox.dart';
import 'token.dart';
import 'token_type.dart';

const int char_0 = 48;
const int char_9 = 57;
const int char_a = 97;
const int char_z = 122;
const int char_A = 65;
const int char_Z = 90;
const int char__ = 95;

class Scanner {
  final String _source;
  final List<Token> _tokens = [];
  int _start = 0;
  int _current = 0;
  int _line = 1;
  int char_9 = '9'.codeUnitAt(0);

  static final Map<String, TokenType> _keywords = {
    "and": TokenType.AND,
    "class": TokenType.CLASS,
    "else": TokenType.ELSE,
    "false": TokenType.FALSE,
    "for": TokenType.FOR,
    "fun": TokenType.FUN,
    "if": TokenType.IF,
    "nil": TokenType.NIL,
    "or": TokenType.OR,
    "print": TokenType.PRINT,
    "return": TokenType.RETURN,
    "super": TokenType.SUPER,
    "this": TokenType.THIS,
    "true": TokenType.TRUE,
    "var": TokenType.VAR,
    "while": TokenType.WHILE
  };

  Scanner(this._source);

  List<Token> scanTokens() {
    while (!_isAtEnd()) {
      // We are at the beginning of the next lexeme.
      _start = _current;
      _scanToken();
    }

    _tokens.add(Token(TokenType.EOF, "", null, _line));
    return _tokens;
  }

  bool _isAtEnd() => _current >= _source.length;

  void _scanToken() {
    String c = _advance();
    switch (c) {
      case '(':
        _addToken(TokenType.LEFT_PAREN);
        break;
      case ')':
        _addToken(TokenType.RIGHT_PAREN);
        break;
      case '{':
        _addToken(TokenType.LEFT_BRACE);
        break;
      case '}':
        _addToken(TokenType.RIGHT_BRACE);
        break;
      case ',':
        _addToken(TokenType.COMMA);
        break;
      case '.':
        _addToken(TokenType.DOT);
        break;
      case '-':
        _addToken(TokenType.MINUS);
        break;
      case '+':
        _addToken(TokenType.PLUS);
        break;
      case ';':
        _addToken(TokenType.SEMICOLON);
        break;
      case '*':
        _addToken(TokenType.STAR);
        break;
      case '!':
        _addToken(_match('=') ? TokenType.BANG_EQUAL : TokenType.BANG);
        break;
      case '=':
        _addToken(_match('=') ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
        break;
      case '<':
        _addToken(_match('=') ? TokenType.LESS_EQUAL : TokenType.LESS);
        break;
      case '>':
        _addToken(_match('=') ? TokenType.GREATER_EQUAL : TokenType.GREATER);
        break;
      case '/':
        if (_match('/')) {
          // A comment goes until the end of the line.
          while (_peek() != '\n' && !_isAtEnd()) {
            _advance();
          }
        } else {
          _addToken(TokenType.SLASH);
        }
        break;

      case ' ':
      case '\r':
      case '\t':
        // Ignore whitespace.
        break;

      case '\n':
        _line++;
        break;

      case '"':
        _string();
        break;

      default:
        if (_isDigit(c)) {
          _number();
        } else if (_isAlpha(c)) {
          _identifier();
        } else {
          Lox.error(_line, "Unexpected character.");
        }
        break;
    }
  }

  String _advance() => _source[_current++];

  void _addToken(TokenType type, {Object? literal}) {
    String text = _source.substring(_start, _current);
    _tokens.add(Token(type, text, literal, _line));
  }

  bool _match(String expected) {
    if (_isAtEnd()) return false;
    if (_source[_current] != expected) return false;

    _current++;
    return true;
  }

  String _peek() {
    if (_isAtEnd()) return '';
    return _source[_current];
  }

  void _string() {
    while (_peek() != '"' && !_isAtEnd()) {
      if (_peek() == '\n') _line++;
      _advance();
    }

    if (_isAtEnd()) {
      Lox.error(_line, "Unterminated string.");
      return;
    }

    // The closing ".
    _advance();

    // Trim the surrounding quotes.
    String value = _source.substring(_start + 1, _current - 1);
    _addToken(TokenType.STRING, literal: value);
  }

  bool _isDigit(String c) =>
      c.codeUnitAt(0) >= char_0 && c.codeUnitAt(0) <= char_9;

  void _number() {
    while (_isDigit(_peek())) {
      _advance();
    }

    // Look for a fractional part.
    if (_peek() == '.' && _isDigit(_peekNext())) {
      // Consume the "."
      _advance();

      while (_isDigit(_peek())) {
        _advance();
      }
    }

    _addToken(TokenType.NUMBER,
        literal: double.parse(_source.substring(_start, _current)));
  }

  String _peekNext() {
    if (_current + 1 >= _source.length) return '';
    return _source[_current + 1];
  }

  void _identifier() {
    while (_isAlphaNumeric(_peek())) {
      _advance();
    }

    String text = _source.substring(_start, _current);
    TokenType type = _keywords[text] ?? TokenType.IDENTIFIER;
    _addToken(type);
  }

  bool _isAlpha(String c) {
    var cUnit = c.codeUnitAt(0);
    return (cUnit >= char_a && cUnit <= char_z) ||
        (cUnit >= char_A && cUnit <= char_Z) ||
        cUnit == char__;
  }

  bool _isAlphaNumeric(String c) {
    return _isAlpha(c) || _isDigit(c);
  }
}
