class Room {
  final int id;
  final String roomCode;
  final String roomTypeName;
  final String title;
  final String description;
  final String imageUrl;
  final String type;
  final int pricePerNight;
  final int maxGuests;
  final double sizeInSqMeters;
  final double rating;
  final int totalReviews;
  final List<String> amenities;
  final List<String> imageUrls;
  final bool isFavorite;
  
  // Amenity flags from API
  final bool hasWifi;
  final bool hasTv;
  final bool hasAc;
  final bool hasBreakfast;
  final bool hasParking;

  Room({
    required this.id,
    required this.roomCode,
    required this.roomTypeName,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
    required this.sizeInSqMeters,
    this.rating = 4.5,
    this.totalReviews = 0,
    this.amenities = const [
      'Free WiFi',
      'Air Conditioning',
      'TV',
      'Minibar',
      'Safe',
    ],
    this.imageUrls = const [],
    this.isFavorite = false,
    this.hasWifi = false,
    this.hasTv = false,
    this.hasAc = false,
    this.hasBreakfast = false,
    this.hasParking = false,
  });

  // Factory constructor for API data
  factory Room.fromJson(Map<String, dynamic> json) {
    // Handle both single image string and image array
    List<String> images = [];
    String mainImage = '';
    
    if (json['image'] is List) {
      images = (json['image'] as List).map((e) => e.toString()).toList();
      mainImage = images.isNotEmpty ? images[0] : '';
    } else if (json['image'] is String) {
      mainImage = json['image'];
      images = [mainImage];
    }
    
    // Build amenities list based on flags
    List<String> amenitiesList = [];
    if (json['hasWifi'] == true) amenitiesList.add('Free WiFi');
    if (json['hasTv'] == true) amenitiesList.add('Smart TV');
    if (json['hasAc'] == true) amenitiesList.add('Air Conditioning');
    if (json['hasBreakfast'] == true) amenitiesList.add('Breakfast Included');
    if (json['hasParking'] == true) amenitiesList.add('Free Parking');
    
    return Room(
      id: (json['id'] ?? 0) is int ? json['id'] : (json['id'] as num).toInt(),
      roomCode: json['roomCode'] ?? '',
      roomTypeName: json['roomTypeName'] ?? '',
      title: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: mainImage,
      type: json['roomTypeName'] ?? '',
      pricePerNight: (json['pricePerNight'] ?? 0) is int 
          ? json['pricePerNight'] 
          : (json['pricePerNight'] as num).toInt(),
      maxGuests: 2,
      sizeInSqMeters: 30.0,
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: (json['totalReviews'] ?? 0) is int 
          ? json['totalReviews'] 
          : (json['totalReviews'] as num).toInt(),
      imageUrls: images,
      amenities: amenitiesList.isNotEmpty ? amenitiesList : ['Standard Room Amenities'],
      hasWifi: json['hasWifi'] ?? false,
      hasTv: json['hasTv'] ?? false,
      hasAc: json['hasAc'] ?? false,
      hasBreakfast: json['hasBreakfast'] ?? false,
      hasParking: json['hasParking'] ?? false,
    );
  }

  // Convert to the format expected by the UI widgets
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'roomCode': roomCode,
      'category': roomTypeName,
      'name': title,
      'description': description,
      'price': pricePerNight,
      'image': imageUrl,
      'rating': rating,
      'reviews': totalReviews,
    };
  }

  Room copyWith({
    int? id,
    String? roomCode,
    String? roomTypeName,
    String? title,
    String? description,
    String? imageUrl,
    String? type,
    int? pricePerNight,
    int? maxGuests,
    double? sizeInSqMeters,
    double? rating,
    int? totalReviews,
    List<String>? amenities,
    List<String>? imageUrls,
    bool? isFavorite,
    bool? hasWifi,
    bool? hasTv,
    bool? hasAc,
    bool? hasBreakfast,
    bool? hasParking,
  }) {
    return Room(
      id: id ?? this.id,
      roomCode: roomCode ?? this.roomCode,
      roomTypeName: roomTypeName ?? this.roomTypeName,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      maxGuests: maxGuests ?? this.maxGuests,
      sizeInSqMeters: sizeInSqMeters ?? this.sizeInSqMeters,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      amenities: amenities ?? this.amenities,
      imageUrls: imageUrls ?? this.imageUrls,
      isFavorite: isFavorite ?? this.isFavorite,
      hasWifi: hasWifi ?? this.hasWifi,
      hasTv: hasTv ?? this.hasTv,
      hasAc: hasAc ?? this.hasAc,
      hasBreakfast: hasBreakfast ?? this.hasBreakfast,
      hasParking: hasParking ?? this.hasParking,
    );
  }

  // Sample data
  static List<Room> get sampleRooms => [
        Room(
          id: 1,
          roomCode: 'ROOM-00001',
          roomTypeName: 'Deluxe',
          title: 'Deluxe Ocean View',
          description: 'Spacious room with a stunning ocean view and modern amenities.',
          imageUrl: 'https://images.unsplash.com/photo-1564500084-03f0c02f6c3f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
          type: 'Deluxe',
          pricePerNight: 250,
          maxGuests: 2,
          sizeInSqMeters: 45,
          rating: 4.7,
          imageUrls: [
            'https://images.unsplash.com/photo-1564500084-03f0c02f6c3f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
            'https://images.unsplash.com/photo-1566665797739-1674de7a421a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
            'https://images.unsplash.com/photo-1566665797739-1674de7a421a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
          ],
        ),
        Room(
          id: 2,
          roomCode: 'ROOM-00002',
          roomTypeName: 'Single',
          title: 'Classic Single Room',
          description: 'Cozy and comfortable room for solo travelers.',
          imageUrl: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
          type: 'Single',
          pricePerNight: 120,
          maxGuests: 1,
          sizeInSqMeters: 25,
          rating: 4.2,
          imageUrls: [
            'https://images.unsplash.com/photo-1590490360182-c33d57733427?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
            'https://images.unsplash.com/photo-1566665797739-1674de7a421a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
          ],
        ),
        Room(
          id: 3,
          roomCode: 'ROOM-00003',
          roomTypeName: 'Suite',
          title: 'Luxury Suite',
          description: 'Elegant suite with separate living area and premium amenities.',
          imageUrl: 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
          type: 'Suite',
          pricePerNight: 350,
          maxGuests: 4,
          sizeInSqMeters: 65,
          rating: 4.9,
          imageUrls: [
            'https://images.unsplash.com/photo-1566665797739-1674de7a421a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
            'https://images.unsplash.com/photo-1564500084-03f0c02f6c3f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
          ],
        ),
      ];
}
