import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:booking_app/config/api_config.dart';
import 'package:booking_app/models/rewards_models.dart';
import 'package:booking_app/services/auth_service.dart';

class RewardsService {
  final AuthService _authService = AuthService();

  Future<RewardsResponse> getRewards() async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Unauthorized');
      }

      final response = await http.get(
        Uri.parse(ApiConfig.rewardsUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return RewardsResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to load rewards: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RewardsActivityResponse> getRewardsActivity({int limit = 20}) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Unauthorized');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.rewardsActivityUrl}?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return RewardsActivityResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to load rewards activity: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> redeemPoints({
    required int points,
    required String description,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Unauthorized');
      }

      final request = RedeemPointsRequest(
        points: points,
        description: description,
      );

      final response = await http.post(
        Uri.parse(ApiConfig.rewardsRedeemUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to redeem points: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
