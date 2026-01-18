import 'dart:convert';
import 'package:booking_app/config/api_config.dart';
import 'package:booking_app/models/payment_method_models.dart';
import 'package:booking_app/services/auth_service.dart';
import 'package:http/http.dart' as http;

class PaymentMethodService {
  final AuthService _authService = AuthService();

  Future<List<PaymentMethod>> fetchPaymentMethods() async {
    final headers = await _authService.getAuthHeaders();
    final response = await http
        .get(Uri.parse(ApiConfig.paymentMethodsUrl), headers: headers)
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please log in again.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load payment methods (${response.statusCode}).');
    }

    final Map<String, dynamic> jsonBody = json.decode(response.body);
    final parsed = PaymentMethodListResponse.fromJson(jsonBody);
    return parsed.data;
  }

  Future<PaymentMethod> addPaymentMethod(AddPaymentMethodRequest request) async {
    final headers = await _authService.getAuthHeaders();
    final response = await http
        .post(
          Uri.parse(ApiConfig.paymentMethodsUrl),
          headers: headers,
          body: json.encode(request.toJson()),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please log in again.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to add payment method (${response.statusCode}).');
    }

    final Map<String, dynamic> jsonBody = json.decode(response.body);
    final parsed = PaymentMethodResponse.fromJson(jsonBody);
    return parsed.data;
  }

  Future<bool> setDefaultPaymentMethod(int id) async {
    final headers = await _authService.getAuthHeaders();
    final response = await http
        .put(
          Uri.parse('${ApiConfig.paymentMethodsUrl}/$id/default'),
          headers: headers,
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please log in again.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
          'Failed to update default payment method (${response.statusCode}).');
    }

    final Map<String, dynamic> jsonBody = json.decode(response.body);
    final parsed = BasicBooleanResponse.fromJson(jsonBody);
    return parsed.data;
  }

  Future<bool> deletePaymentMethod(int id) async {
    final headers = await _authService.getAuthHeaders();
    final response = await http
        .delete(
          Uri.parse('${ApiConfig.paymentMethodsUrl}/$id'),
          headers: headers,
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 401) {
      throw Exception('Unauthorized. Please log in again.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete payment method (${response.statusCode}).');
    }

    final Map<String, dynamic> jsonBody = json.decode(response.body);
    final parsed = BasicBooleanResponse.fromJson(jsonBody);
    return parsed.data;
  }
}
