import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:booking_app/models/room_model.dart';
import 'package:booking_app/config/api_config.dart';

class RoomService {
  /// Fetches all rooms from the API
  Future<List<Room>> fetchRooms() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.roomsUrl),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        // Check if the response has the expected structure
        if (jsonData['header']?['status'] == 200 && jsonData['data'] != null) {
          final List<dynamic> roomsJson = jsonData['data'];
          return roomsJson.map((json) => Room.fromJson(json)).toList();
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching rooms: $e');
    }
  }

  /// Fetches rooms filtered by type
  Future<List<Room>> fetchRoomsByType(String roomType) async {
    final allRooms = await fetchRooms();
    if (roomType == 'All Rooms') {
      return allRooms;
    }
    return allRooms.where((room) => room.roomTypeName == roomType).toList();
  }
  
  /// Fetches a single room by ID
  Future<Room> fetchRoomById(int roomId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/rooms/find/$roomId'),
        headers: ApiConfig.defaultHeaders,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        // Check if the response has the expected structure
        if (jsonData['header']?['status'] == 200 && jsonData['data'] != null) {
          return Room.fromJson(jsonData['data']);
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to load room: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching room: $e');
    }
  }
}
