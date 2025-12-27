class Room {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String type;
  final double pricePerNight;
  final int maxGuests;
  final double sizeInSqMeters;
  final double rating;
  final List<String> amenities;
  final List<String> imageUrls;
  final bool isFavorite;

  Room({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.type,
    required this.pricePerNight,
    required this.maxGuests,
    required this.sizeInSqMeters,
    this.rating = 4.5,
    this.amenities = const [
      'Free WiFi',
      'Air Conditioning',
      'TV',
      'Minibar',
      'Safe',
    ],
    this.imageUrls = const [],
    this.isFavorite = false,
  });

  Room copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    String? type,
    double? pricePerNight,
    int? maxGuests,
    double? sizeInSqMeters,
    double? rating,
    List<String>? amenities,
    List<String>? imageUrls,
    bool? isFavorite,
  }) {
    return Room(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      maxGuests: maxGuests ?? this.maxGuests,
      sizeInSqMeters: sizeInSqMeters ?? this.sizeInSqMeters,
      rating: rating ?? this.rating,
      amenities: amenities ?? this.amenities,
      imageUrls: imageUrls ?? this.imageUrls,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // Sample data
  static List<Room> get sampleRooms => [
        Room(
          id: '1',
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
          id: '2',
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
          id: '3',
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
