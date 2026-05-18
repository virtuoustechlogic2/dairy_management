class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => message;
}

class DatabaseException extends AppException {
  DatabaseException(super.message);
}

class PdfGenerationException extends AppException {
  PdfGenerationException(super.message);
}

class ShareException extends AppException {
  ShareException(super.message);
}
