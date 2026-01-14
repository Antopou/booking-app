class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImage;
  final String membershipLevel;
  final int totalStays;
  final int upcomingStays;
  final int rewardPoints;
  final String? firstName;
  final String? lastName;
  final DateTime? dateOfBirth;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImage,
    required this.membershipLevel,
    required this.totalStays,
    required this.upcomingStays,
    required this.rewardPoints,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      profileImage: json['profileImage'] as String?,
      membershipLevel: json['membershipLevel'] as String,
      totalStays: json['totalStays'] as int,
      upcomingStays: json['upcomingStays'] as int,
      rewardPoints: json['rewardPoints'] as int,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
    );
  }

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return name;
  }
}

class UserProfileResponse {
  final int status;
  final String message;
  final UserProfile data;

  UserProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: json['header']['status'] as int,
      message: json['header']['message'] as String,
      data: UserProfile.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class UpdatePersonalInfoRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime dateOfBirth;
  final String? profileImage;

  UpdatePersonalInfoRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      if (profileImage != null) 'profileImage': profileImage,
    };
  }
}
