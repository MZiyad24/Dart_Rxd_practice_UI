import 'dart:convert';
import 'package:http/http.dart' as http;
import './storage_service.dart';

class ApiService {
  final String _baseUrl = "http://localhost:3000";
  final StorageService _storage = StorageService();

  Future<http.Response> get(String endpoint) async {
    final token = await _storage.getToken();
    print("Making GET request to $_baseUrl$endpoint with token: ${token != null ? "[REDACTED]" : "None"}");
    
    return await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final token = await _storage.getToken();
    
    return await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(String endpoint, Map<String, dynamic> body) async {
    final token = await _storage.getToken();
    
    return await http.patch(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final token = await _storage.getToken();
    
    return await http.delete(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }
}