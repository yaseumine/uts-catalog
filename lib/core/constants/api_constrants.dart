class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
  // ntar aku ambil ini dari ip laptop aku

  // Auth endpoints
  static const String verifyToken = '/auth/verify-token';

  // Product endpoints
  static const String products = '/products';

  // Timeout
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}
