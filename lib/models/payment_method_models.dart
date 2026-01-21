class PaymentMethod {
  final int id;
  final String methodType;
  final String brand;
  final String cardLast4;
  final int expMonth;
  final int expYear;
  final bool isDefault;
  final String billingName;

  PaymentMethod({
    required this.id,
    required this.methodType,
    required this.brand,
    required this.cardLast4,
    required this.expMonth,
    required this.expYear,
    required this.isDefault,
    required this.billingName,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'] ?? 0,
        methodType: json['methodType'] ?? '',
        brand: json['brand'] ?? '',
        cardLast4: json['cardLast4'] ?? '',
        expMonth: json['expMonth'] ?? 0,
        expYear: json['expYear'] ?? 0,
        isDefault: json['isDefault'] ?? false,
        billingName: json['billingName'] ?? '',
      );
}

class PaymentMethodListResponse {
  final ResponseHeader header;
  final List<PaymentMethod> data;
  final ResponseFooter footer;

  PaymentMethodListResponse({
    required this.header,
    required this.data,
    required this.footer,
  });

  factory PaymentMethodListResponse.fromJson(Map<String, dynamic> json) =>
      PaymentMethodListResponse(
        header: ResponseHeader.fromJson(json['header'] ?? {}),
        data: ((json['data'] ?? []) as List)
            .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
            .toList(),
        footer: ResponseFooter.fromJson(json['footer'] ?? {}),
      );
}

class PaymentMethodResponse {
  final ResponseHeader header;
  final PaymentMethod data;
  final ResponseFooter footer;

  PaymentMethodResponse({
    required this.header,
    required this.data,
    required this.footer,
  });

  factory PaymentMethodResponse.fromJson(Map<String, dynamic> json) =>
      PaymentMethodResponse(
        header: ResponseHeader.fromJson(json['header'] ?? {}),
        data: PaymentMethod.fromJson(json['data'] ?? {}),
        footer: ResponseFooter.fromJson(json['footer'] ?? {}),
      );
}

class BasicBooleanResponse {
  final ResponseHeader header;
  final bool data;
  final ResponseFooter footer;

  BasicBooleanResponse({
    required this.header,
    required this.data,
    required this.footer,
  });

  factory BasicBooleanResponse.fromJson(Map<String, dynamic> json) =>
      BasicBooleanResponse(
        header: ResponseHeader.fromJson(json['header'] ?? {}),
        data: json['data'] == true,
        footer: ResponseFooter.fromJson(json['footer'] ?? {}),
      );
}

class AddPaymentMethodRequest {
  final String methodType;
  final String cardNumber;
  final int expMonth;
  final int expYear;
  final bool setAsDefault;
  final String billingName;
  final String brand;
  final String token;

  AddPaymentMethodRequest({
    required this.methodType,
    required this.cardNumber,
    required this.expMonth,
    required this.expYear,
    required this.setAsDefault,
    required this.billingName,
    required this.brand,
    required this.token,
  });

  Map<String, dynamic> toJson() => {
        'methodType': methodType,
        'cardNumber': cardNumber,
        'expMonth': expMonth,
        'expYear': expYear,
        'setAsDefault': setAsDefault,
        'billingName': billingName,
        'brand': brand,
        'token': token,
      };
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
