/// Request model for user registration
class RegisterRequest {
  final String name;
  final String email;
  final String password;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}

/// Request model for user login
class LoginRequest {
  final String identifier;
  final String password;

  LoginRequest({
    required this.identifier,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'password': password,
    };
  }
}

/// Response model for authentication
class AuthResponse {
  final ResponseHeader header;
  final AuthData data;
  final ResponseFooter footer;

  AuthResponse({
    required this.header,
    required this.data,
    required this.footer,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      header: ResponseHeader.fromJson(json['header']),
      data: AuthData.fromJson(json['data']),
      footer: ResponseFooter.fromJson(json['footer']),
    );
  }
}

/// Response header structure
class ResponseHeader {
  final int status;
  final String message;

  ResponseHeader({
    required this.status,
    required this.message,
  });

  factory ResponseHeader.fromJson(Map<String, dynamic> json) {
    return ResponseHeader(
      status: json['status'],
      message: json['message'],
    );
  }
}

/// Authentication data containing tokens
class AuthData {
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  AuthData({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
      expiresIn: json['expiresIn'],
    );
  }
}

/// Response footer structure
class ResponseFooter {
  final int count;

  ResponseFooter({
    required this.count,
  });

  factory ResponseFooter.fromJson(Map<String, dynamic> json) {
    return ResponseFooter(
      count: json['count'],
    );
  }
}

  /// Response model for token validation
  class TokenValidationResponse {
    final ResponseHeader header;
    final TokenValidationData data;
    final ResponseFooter footer;

    TokenValidationResponse({
      required this.header,
      required this.data,
      required this.footer,
    });

    factory TokenValidationResponse.fromJson(Map<String, dynamic> json) {
      return TokenValidationResponse(
        header: ResponseHeader.fromJson(json['header']),
        data: TokenValidationData.fromJson(json['data']),
        footer: ResponseFooter.fromJson(json['footer']),
      );
    }
  }

  /// Token validation data
  class TokenValidationData {
    final bool valid;
    final String message;
    final int userId;
    final String username;

    TokenValidationData({
      required this.valid,
      required this.message,
      required this.userId,
      required this.username,
    });

    factory TokenValidationData.fromJson(Map<String, dynamic> json) {
      return TokenValidationData(
        valid: json['valid'],
        message: json['message'],
        userId: json['userId'],
        username: json['username'],
      );
    }
  }
