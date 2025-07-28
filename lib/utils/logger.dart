class Logger {
  static void debug(String tag, String message) {
    // Só imprime em modo debug
    assert(() {
      print('[$tag] $message');
      return true;
    }());
  }
}