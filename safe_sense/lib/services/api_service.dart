// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // For Android Emulator, use 10.0.2.2 to access localhost
  // For iOS Simulator, use localhost or 127.0.0.1
  // For Real Device, use your computer's IP address (e.g., 192.168.1.100)
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  // Send signup credentials to backend
  Future<Map<String, dynamic>> sendSignupData({
    required String name,
    required int age,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/signup');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'age': age,
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to send data. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Connection error: ${e.toString()}',
      };
    }
  }
}