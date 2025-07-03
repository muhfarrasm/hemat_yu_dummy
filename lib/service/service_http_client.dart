import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hematyu_app_dummy_fix/service/secure_storage_service.dart';

class ServiceHttpClient {
  final _client = http.Client();
  final SecureStorageService _storage = SecureStorageService();
  final String baseUrl = 'http://10.0.2.2:8000/api';

  SecureStorageService get storage => _storage;

  Future<Map<String, String>> _getHeaders({bool authorized = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authorized) {
      final token = await _storage.getToken();
      print('🔐 Token: $token');
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    print('📡 Headers: $headers');
    return headers;
  }

  Future<http.Response> post(
    String path,
    dynamic body, {
    bool authorized = false,
  }) async {
    final url = Uri.parse('$baseUrl$path');
    final headers = await _getHeaders(authorized: authorized);

    print('📤 POST Request to: $url');
    print('📤 Body: ${jsonEncode(body)}');

    final response = await _client.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    print('✅ Response Status: ${response.statusCode}');
    print('✅ Response Body: ${response.body}');
    return response;
  }

  Future<http.StreamedResponse> postMultipart(
    String path, {
    required Map<String, String> fields,
    File? file,
    bool authorized = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final token = await _storage.getToken();

    final request = http.MultipartRequest('POST', uri);

    if (authorized && token != null) {
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
    }

    request.fields.addAll(fields);

    if (file != null) {
      final fileName = file.path.split('/').last;
      request.files.add(await http.MultipartFile.fromPath(
        'bukti_transaksi',
        file.path,
      ));
    }

    print('📤 Multipart Request to: $uri');
    print('📤 Fields: $fields');
    print('📤 File: ${file?.path}');

    return await request.send();
  }

  Future<http.Response> get(String path, {bool authorized = false}) async {
    final url = Uri.parse('$baseUrl$path');
    final headers = await _getHeaders(authorized: authorized);

    print('📤 GET Request to: $url');

    final response = await _client.get(
      url,
      headers: headers,
    );

    print('✅ Response Status: ${response.statusCode}');
    print('✅ Response Body: ${response.body}');
    return response;
  }

  Future<void> clearToken() async => await _storage.clearToken();
}
