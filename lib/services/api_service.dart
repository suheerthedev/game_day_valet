import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:game_day_valet/app/app.locator.dart';
import 'package:game_day_valet/services/api_exception.dart';
import 'package:game_day_valet/services/logger_service.dart';
// import 'package:game_day_valet/services/connectivity_service.dart';
import 'package:game_day_valet/services/secure_storage_service.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final _secureStorageService = locator<SecureStorageService>();
  // final _connectivityService = locator<ConnectivityService>();

  Future<Map<String, String>> _getHeaders({bool isMultiPart = false}) async {
    final token = await _secureStorageService.getToken();
    return {
      'Accept': 'application/json',
      // 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> getPusherHeaders() async {
    final token = await _secureStorageService.getToken();
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      if (token != null) 'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  Future<Map<String, String>> _getPaymentHeaders() async {
    final token = await _secureStorageService.getToken();
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Future<void> _checkConnectivity() async {
  //   if (!await _connectivityService.hasInternetConnection()) {
  //     throw NoInternetException();
  //   }
  // }

  Future<dynamic> get(String url) async {
    // await _checkConnectivity();
    try {
      final headers = await _getHeaders();
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    // await _checkConnectivity();
    try {
      final headers = await _getHeaders();
      final response = await http
          .post(Uri.parse(url), headers: headers, body: body)
          .timeout(const Duration(seconds: 30));

      logger.info('Response: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    }
  }

  Future<dynamic> postTextAndMultiPart(
      String url, Map<String, String> body, List<File> files) async {
    // await _checkConnectivity();
    try {
      final headers = await _getHeaders(isMultiPart: true);

      final request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headers);

      request.fields.addAll(body);

      for (File file in files) {
        request.files
            .add(await http.MultipartFile.fromPath('profile_image', file.path));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      logger.info('Response: ${response.body}');

      return _handleMultiPartResponse(response.statusCode, response.body);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    }
  }

  Future<dynamic> postPayment(String url, Map<String, dynamic> body) async {
    // await _checkConnectivity();
    try {
      final headers = await _getPaymentHeaders();
      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      logger.info('Response: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    }
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    // await _checkConnectivity();
    try {
      final headers = await _getHeaders();
      final response = await http
          .put(Uri.parse(url), body: body, headers: headers)
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    }
  }

  Future<dynamic> delete(String url, {Map<String, dynamic>? body}) async {
    // await _checkConnectivity();
    try {
      final headers = await _getHeaders();
      final response = await http
          .delete(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    }
  }

  Future<dynamic> postMultiPart(String url, List<File> files) async {
    // await _checkConnectivity();
    try {
      final headers = await _getHeaders(isMultiPart: true);
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      for (File file in files) {
        request.files
            .add(await http.MultipartFile.fromPath('attachment[]', file.path));
      }

      final response =
          await request.send().timeout(const Duration(seconds: 30));
      final responseBody = await response.stream.bytesToString();
      return _handleMultiPartResponse(response.statusCode, responseBody);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    }
  }

  dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
      case 201:
        return decoded;
      case 422:
        return decoded;
      case 400:
        throw ApiException(
            decoded['message'] ?? "Bad Request", response.statusCode);
      case 401:
        throw UnauthorizedException();
      case 404:
        throw ApiException("Resource not found", 404);
      default:
        throw ApiException("Something went wrong", response.statusCode);
    }
  }

  dynamic _handleMultiPartResponse(int statusCode, String body) {
    final decoded = jsonDecode(body);
    switch (statusCode) {
      case 200:
      case 201:
        return decoded;
      case 400:
      case 422:
        throw ApiException(decoded['message'] ?? "Bad Request", statusCode);
      case 401:
        throw UnauthorizedException();
      default:
        throw ApiException("Something went wrong", statusCode);
    }
  }
}
