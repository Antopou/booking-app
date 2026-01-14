import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booking_app/config/api_config.dart';
import 'package:booking_app/models/auth_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _tokenKey = 'access_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _expiresInKey = 'expires_in';

  /// Register a new user
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final request = RegisterRequest(
        name: name,
        email: email,
        password: password,
      );

      final response = await http.post(
        Uri.parse(ApiConfig.registerUrl),
        headers: ApiConfig.defaultHeaders,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(json.decode(response.body));
        
        if (authResponse.header.status == 200) {
          await _saveToken(authResponse.data);
          return authResponse;
        } else {
          throw Exception(authResponse.header.message);
        }
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }

  /// Login user with identifier (username or email) and password
  Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final request = LoginRequest(
        identifier: identifier,
        password: password,
      );

      final response = await http.post(
        Uri.parse(ApiConfig.loginUrl),
        headers: ApiConfig.defaultHeaders,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(json.decode(response.body));
        
        if (authResponse.header.status == 200) {
          await _saveToken(authResponse.data);
          return authResponse;
        } else {
          throw Exception(authResponse.header.message);
        }
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  /// Save authentication token to local storage
  Future<void> _saveToken(AuthData authData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, authData.accessToken);
    await prefs.setString(_tokenTypeKey, authData.tokenType);
    await prefs.setInt(_expiresInKey, authData.expiresIn);
    
    // Store expiration timestamp
    final expirationTime = DateTime.now().millisecondsSinceEpoch + 
                           (authData.expiresIn * 1000);
    await prefs.setInt('token_expiration', expirationTime);
  }

  /// Get stored access token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    
    // Check if token is expired
    final expiration = prefs.getInt('token_expiration');
    if (expiration != null && DateTime.now().millisecondsSinceEpoch > expiration) {
      await clearToken();
      return null;
    }
    
    return token;
  }

  /// Get authorization header with token
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    if (token == null) {
      return ApiConfig.defaultHeaders;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final tokenType = prefs.getString(_tokenTypeKey) ?? 'Bearer';
    
    return {
      ...ApiConfig.defaultHeaders,
      'Authorization': '$tokenType $token',
    };
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

   /// Validate the stored token with the server
   Future<TokenValidationResponse?> checkToken() async {
     try {
       final headers = await getAuthHeaders();
     
       // If no token, return null
       if (!headers.containsKey('Authorization')) {
         return null;
       }
     
       final response = await http.get(
         Uri.parse(ApiConfig.checkTokenUrl),
         headers: headers,
       );

       if (response.statusCode == 200) {
         final validationResponse = TokenValidationResponse.fromJson(
           json.decode(response.body)
         );
       
         if (validationResponse.header.status == 200 && validationResponse.data.valid) {
           return validationResponse;
         } else {
           // Token is invalid, clear it
           await clearToken();
           return null;
         }
       } else {
         // Server error or invalid token
         await clearToken();
         return null;
       }
     } catch (e) {
       // Network error or other issues
       await clearToken();
       return null;
     }
   }

  /// Logout user by clearing stored token
  Future<void> logout() async {
    await clearToken();
  }

  /// Clear all stored authentication data
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_tokenTypeKey);
    await prefs.remove(_expiresInKey);
    await prefs.remove('token_expiration');
  }
}
