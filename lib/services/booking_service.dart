import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booking_app/models/booking_models.dart';
import 'package:booking_app/config/api_config.dart';
import 'package:booking_app/services/auth_service.dart';

class BookingService {
  final AuthService _authService = AuthService();

  /// Create a new booking
  Future<BookingResponse> createBooking(BookingRequest booking) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available');
      }

      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse(ApiConfig.bookingsUrl),
        headers: headers,
        body: jsonEncode(booking.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BookingResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to create booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating booking: $e');
    }
  }

  /// Fetch user's bookings list
  Future<BookingListResponse> fetchBookings() async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available');
      }

      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final response = await http.get(
        Uri.parse(ApiConfig.bookingsUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BookingListResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to fetch bookings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }
}
