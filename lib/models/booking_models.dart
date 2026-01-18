class GuestInfo {
  final String? guestCode;
  final String name;
  final String email;
  final String phoneNumber;

  GuestInfo({
    this.guestCode,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'guestCode': guestCode,
    'name': name,
    'email': email,
    'phoneNumber': phoneNumber,
  };

  factory GuestInfo.fromJson(Map<String, dynamic> json) => GuestInfo(
    guestCode: json['guestCode'],
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
  );
}

class BookingRequest {
  final String roomCode;
  final GuestInfo guest;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final String paymentMethod;
  final int? paymentMethodId;
  final int numberOfGuests;
  final int adult;
  final int child;
  final double totalPayment;

  BookingRequest({
    required this.roomCode,
    required this.guest,
    required this.checkInDate,
    required this.checkOutDate,
    required this.paymentMethod,
    this.paymentMethodId,
    required this.numberOfGuests,
    required this.adult,
    required this.child,
    required this.totalPayment,
  });

  Map<String, dynamic> toJson() => {
    'roomCode': roomCode,
    'guest': guest.toJson(),
    'checkInDate': checkInDate.toUtc().toIso8601String(),
    'checkOutDate': checkOutDate.toUtc().toIso8601String(),
    'paymentMethod': paymentMethod,
    'paymentMethodId': paymentMethodId,
    'numberOfGuests': numberOfGuests,
    'adult': adult,
    'child': child,
    'totalPayment': totalPayment,
  };
}

class BookingData {
  final String checkinCode;
  final String guestCode;
  final String roomCode;
  final String guestName;
  final String guestEmail;
  final String phoneNumber;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numberOfGuests;
  final int adult;
  final int child;
  final String paymentMethod;
  final double roomRate;
  final double serviceFee;
  final double taxes;
  final double totalAmount;
  final String status;
  final String message;

  BookingData({
    required this.checkinCode,
    required this.guestCode,
    required this.roomCode,
    required this.guestName,
    required this.guestEmail,
    required this.phoneNumber,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.adult,
    required this.child,
    required this.paymentMethod,
    required this.roomRate,
    required this.serviceFee,
    required this.taxes,
    required this.totalAmount,
    required this.status,
    required this.message,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
    checkinCode: json['checkinCode'] ?? '',
    guestCode: json['guestCode'] ?? '',
    roomCode: json['roomCode'] ?? '',
    guestName: json['guestName'] ?? '',
    guestEmail: json['guestEmail'] ?? '',
    phoneNumber: json['phoneNumber'] ?? '',
    checkInDate: json['checkInDate'] != null
        ? DateTime.parse(json['checkInDate'].toString())
        : DateTime.now(),
    checkOutDate: json['checkOutDate'] != null
        ? DateTime.parse(json['checkOutDate'].toString())
        : DateTime.now(),
    numberOfGuests: json['numberOfGuests'] ?? 0,
    adult: json['adult'] ?? 0,
    child: json['child'] ?? 0,
    paymentMethod: json['paymentMethod'] ?? '',
    roomRate: (json['roomRate'] ?? 0).toDouble(),
    serviceFee: (json['serviceFee'] ?? 0).toDouble(),
    taxes: (json['taxes'] ?? 0).toDouble(),
    totalAmount: (json['totalAmount'] ?? 0).toDouble(),
    status: json['status'] ?? '',
    message: json['message'] ?? '',
  );
}

class BookingResponse {
  final ResponseHeader header;
  final BookingData data;
  final ResponseFooter footer;

  BookingResponse({
    required this.header,
    required this.data,
    required this.footer,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      BookingResponse(
        header: ResponseHeader.fromJson(json['header'] ?? {}),
        data: BookingData.fromJson(json['data'] ?? {}),
        footer: ResponseFooter.fromJson(json['footer'] ?? {}),
      );
}

class ResponseHeader {
  final int status;
  final String message;

  ResponseHeader({required this.status, required this.message});

  factory ResponseHeader.fromJson(Map<String, dynamic> json) => ResponseHeader(
    status: json['status'] ?? 0,
    message: json['message'] ?? '',
  );
}

class ResponseFooter {
  final int count;

  ResponseFooter({required this.count});

  factory ResponseFooter.fromJson(Map<String, dynamic> json) =>
      ResponseFooter(count: json['count'] ?? 0);
}

class BookingListItem {
  final String checkinCode;
  final String roomCode;
  final String roomName;
  final String roomImage;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;
  final String status;
  final bool isCheckout;
  final bool isCancelled;
  final int numberOfGuests;
  final int adult;
  final int child;

  BookingListItem({
    required this.checkinCode,
    required this.roomCode,
    required this.roomName,
    required this.roomImage,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.status,
    required this.isCheckout,
    required this.isCancelled,
    required this.numberOfGuests,
    required this.adult,
    required this.child,
  });

  factory BookingListItem.fromJson(Map<String, dynamic> json) =>
      BookingListItem(
        checkinCode: json['checkinCode'] ?? '',
        roomCode: json['roomCode'] ?? '',
        roomName: json['roomName'] ?? '',
        roomImage: json['roomImage'] ?? '',
        checkInDate: json['checkInDate'] != null
            ? DateTime.parse(json['checkInDate'].toString())
            : DateTime.now(),
        checkOutDate: json['checkOutDate'] != null
            ? DateTime.parse(json['checkOutDate'].toString())
            : DateTime.now(),
        totalPrice: (json['totalPrice'] ?? 0).toDouble(),
        status: json['status'] ?? '',
        isCheckout: json['isCheckout'] ?? false,
        isCancelled: json['isCancelled'] ?? false,
        numberOfGuests: json['numberOfGuests'] ?? 0,
        adult: json['adult'] ?? 0,
        child: json['child'] ?? 0,
      );
}

class BookingListResponse {
  final ResponseHeader header;
  final List<BookingListItem> data;
  final ResponseFooter footer;

  BookingListResponse({
    required this.header,
    required this.data,
    required this.footer,
  });

  factory BookingListResponse.fromJson(Map<String, dynamic> json) =>
      BookingListResponse(
        header: ResponseHeader.fromJson(json['header'] ?? {}),
        data:
            (json['data'] as List<dynamic>?)
                ?.map(
                  (item) =>
                      BookingListItem.fromJson(item as Map<String, dynamic>),
                )
                .toList() ??
            [],
        footer: ResponseFooter.fromJson(json['footer'] ?? {}),
      );
}
