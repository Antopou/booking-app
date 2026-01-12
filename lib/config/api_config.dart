class ApiConfig {
  // Base URL for API
  // For Android Emulator: use http://10.0.2.2:PORT
  // For iOS Simulator: use http://localhost:PORT or http://127.0.0.1:PORT
  // For Physical Device: use your computer's IP address http://192.168.x.x:PORT
  static const String baseUrl = 'http://10.0.2.2:8080';
  
  // API Endpoints
  static const String roomsEndpoint = '/rooms/list';
  static const String bookingsEndpoint = '/bookings';
  
  // Full URLs
  static String get roomsUrl => '$baseUrl$roomsEndpoint';
  static String get bookingsUrl => '$baseUrl$bookingsEndpoint';
  
  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Common headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
}
