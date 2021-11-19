class CustomHttpException implements Exception {
  final String msg;
  final int statusCode;

  CustomHttpException(this.msg, this.statusCode);

  @override
  String toString() {
    return msg;
  }
}
