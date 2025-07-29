import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final baseUrl = dotenv.env['BASE_URL'] ?? '';

  static const loginEndPoint = '/login';
  static const registerEndPoint = '/register';
  static const productsEndPoint = '/products';
  // Add more as needed
}
