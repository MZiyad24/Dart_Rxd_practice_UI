import 'dart:convert';
import '../services/api.dart';
import '../services/storage_service.dart';
import '../models/user.dart';

class AuthService {
  final String baseUrl = "http://localhost:3000"; 
  final StorageService _storageService = StorageService();
  final ApiService api = ApiService();

  Future<bool> signup(User user) async {
    try {
      final response = await api.post('/auth/signup',  
        {
          "name": user.name,
          "email": user.email,
          "password": user.password,
          "confirmPassword": user.password,
          "gender": user.gender?.toLowerCase() ?? '',
          "level": int.parse(user.level?.toString() ?? '1'),
        }
      );
      
      if (response.statusCode == 201) {
        String? token = jsonDecode(response.body)['idToken'];
        if(token != null) {
          await _storageService.saveToken(token);
        }
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? "Signup failed");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {     
    try {
      final response = await api.post(
        '/auth/login',
        {
          "email": email,
          "password": password,
        }
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    await _storageService.deleteToken();
  }
}