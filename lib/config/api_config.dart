class ApiConfig {
  // Base URL for API
  // For Android Emulator: use http://10.0.2.2:PORT
  // For iOS Simulator: use http://localhost:PORT or http://127.0.0.1:PORT
  // For Physical Device: use your computer's IP address http://192.168.x.x:PORT
  static const String baseUrl = 'http://10.0.2.2:8080';

  // API Endpoints
  static const String roomsEndpoint = '/rooms/list';
  static const String bookingsEndpoint = '/bookings';
  static const String bookingsFindEndpoint = '/bookings/find';
  static const String bookingsUpdateEndpoint = '/bookings/update';
  static const String bookingsCancelEndpoint = '/bookings/cancel';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String checkTokenEndpoint = '/auth/check-token';
  static const String paymentMethodsEndpoint = '/payment-methods';
  static const String rewardsEndpoint = '/rewards';
  static const String rewardsActivityEndpoint = '/rewards/activity';
  static const String rewardsRedeemEndpoint = '/rewards/redeem';

  // Full URLs
  static String get roomsUrl => '$baseUrl$roomsEndpoint';
  static String get bookingsUrl => '$baseUrl$bookingsEndpoint';
  static String get bookingsFindUrl => '$baseUrl$bookingsFindEndpoint';
  static String get bookingsUpdateUrl => '$baseUrl$bookingsUpdateEndpoint';
  static String get bookingsCancelUrl => '$baseUrl$bookingsCancelEndpoint';
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get checkTokenUrl => '$baseUrl$checkTokenEndpoint';
  static String get paymentMethodsUrl => '$baseUrl$paymentMethodsEndpoint';
  static String get rewardsUrl => '$baseUrl$rewardsEndpoint';
  static String get rewardsActivityUrl => '$baseUrl$rewardsActivityEndpoint';
  static String get rewardsRedeemUrl => '$baseUrl$rewardsRedeemEndpoint';

  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Common headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'accept': '*/*',
  };
}
