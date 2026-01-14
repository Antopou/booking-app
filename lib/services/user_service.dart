import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booking_app/config/api_config.dart';
import 'package:booking_app/models/user_profile_models.dart';
import 'package:booking_app/services/auth_service.dart';

class UserService {
  final AuthService _authService = AuthService();

  Future<UserProfileResponse> getProfile() async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token available');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/users/profile');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please log in again');
    }

    if (response.statusCode != 200) {
      throw Exception('Error fetching profile: ${response.statusCode}');
    }

    final jsonData = json.decode(response.body);
    return UserProfileResponse.fromJson(jsonData);
  }

  Future<UserProfileResponse> updatePersonalInfo(
      UpdatePersonalInfoRequest request) async {
    final token = await _authService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('No authentication token available');
    }

    final url = Uri.parse('${ApiConfig.baseUrl}/users/profile/personal-info');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(request.toJson()),
    );

    if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please log in again');
    }

    if (response.statusCode != 200) {
      throw Exception('Error updating profile: ${response.statusCode}');
    }

    final jsonData = json.decode(response.body);
    return UserProfileResponse.fromJson(jsonData);
  }
}
