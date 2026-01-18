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

  /// Fetch a single booking by checkinCode
  Future<BookingResponse> fetchBookingByCheckinCode(String checkinCode) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available');
      }

      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse(
        '${ApiConfig.bookingsFindUrl}?checkinCode=$checkinCode',
      );
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BookingResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to fetch booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching booking: $e');
    }
  }

  /// Update an existing booking
  Future<void> updateBooking({
    required String checkinCode,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numberOfGuests,
    required int adult,
    required int child,
  }) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available');
      }

      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final body = {
        'checkinCode': checkinCode,
        'checkInDate': checkInDate.toUtc().toIso8601String(),
        'checkOutDate': checkOutDate.toUtc().toIso8601String(),
        'numberOfGuests': numberOfGuests,
        'adult': adult,
        'child': child,
      };

      final response = await http.post(
        Uri.parse(ApiConfig.bookingsUpdateUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update successful, no need to parse response
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else {
        final errorBody = response.body.isNotEmpty
            ? response.body
            : 'Unknown error';
        throw Exception(
          'Failed to update booking: ${response.statusCode} - $errorBody',
        );
      }
    } catch (e) {
      throw Exception('Error updating booking: $e');
    }
  }
}
