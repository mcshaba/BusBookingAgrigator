class CleanerException implements Exception {
  String cause;
  CleanerException(this.cause);

  @override
  String toString() {
    return cause;
  }
}

