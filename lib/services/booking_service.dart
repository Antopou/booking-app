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

  /// Cancel a booking by checkin code
  Future<bool> cancelBooking(String checkinCode) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available');
      }

      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse('${ApiConfig.baseUrl}/bookings/cancel')
          .replace(queryParameters: {'checkinCode': checkinCode});

      final response = await http.post(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 404) {
        throw Exception('Booking not found');
      } else {
        throw Exception('Failed to cancel booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error cancelling booking: $e');
    }
  }

  /// Update an existing booking
  Future<bool> updateBooking({
    required String checkinCode,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int numberOfGuests,
    required int adults,
    required int children,
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
        'checkInDate': checkInDate.toIso8601String().split('T')[0],
        'checkOutDate': checkOutDate.toIso8601String().split('T')[0],
        'numberOfGuests': numberOfGuests,
        'adult': adults,
        'child': children,
      };

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/bookings/update'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 404) {
        throw Exception('Booking not found');
      } else {
        throw Exception('Failed to update booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating booking: $e');
    }
  }

  /// Find a booking by checkin code
  Future<BookingDetail> findBooking(String checkinCode) async {
    try {
      final token = await _authService.getToken();
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token available');
      }

      final headers = {
        ...ApiConfig.defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final uri = Uri.parse('${ApiConfig.baseUrl}/bookings/find')
          .replace(queryParameters: {'checkinCode': checkinCode});

      final response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final bookingDetail = BookingDetail.fromJson(jsonData['data'] ?? {});
        return bookingDetail;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 404) {
        throw Exception('Booking not found');
      } else {
        throw Exception('Failed to fetch booking: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching booking: $e');
    }
  }
}
