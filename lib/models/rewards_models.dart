class RewardsData {
  final int currentPoints;
  final String tierStatus;
  final String nextTier;
  final int pointsToNextTier;
  final int progressPercent;

  RewardsData({
    required this.currentPoints,
    required this.tierStatus,
    required this.nextTier,
    required this.pointsToNextTier,
    required this.progressPercent,
  });

  factory RewardsData.fromJson(Map<String, dynamic> json) {
    return RewardsData(
      currentPoints: json['currentPoints'] ?? 0,
      tierStatus: json['tierStatus'] ?? 'Standard',
      nextTier: json['nextTier'] ?? 'Gold Elite',
      pointsToNextTier: json['pointsToNextTier'] ?? 0,
      progressPercent: json['progressPercent'] ?? 0,
    );
  }
}

class RewardsResponse {
  final Map<String, dynamic> header;
  final RewardsData data;
  final Map<String, dynamic> footer;

  RewardsResponse({
    required this.header,
    required this.data,
    required this.footer,
  });

  factory RewardsResponse.fromJson(Map<String, dynamic> json) {
    return RewardsResponse(
      header: json['header'] ?? {},
      data: RewardsData.fromJson(json['data'] ?? {}),
      footer: json['footer'] ?? {},
    );
  }
}

class RewardsActivityItem {
  final int id;
  final String description;
  final int points;
  final String transactionType;
  final DateTime createdAt;

  RewardsActivityItem({
    required this.id,
    required this.description,
    required this.points,
    required this.transactionType,
    required this.createdAt,
  });

  factory RewardsActivityItem.fromJson(Map<String, dynamic> json) {
    return RewardsActivityItem(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      points: json['points'] ?? 0,
      transactionType: json['transactionType'] ?? 'earned',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}

class RewardsActivityResponse {
  final Map<String, dynamic> header;
  final List<RewardsActivityItem> data;
  final Map<String, dynamic> footer;

  RewardsActivityResponse({
    required this.header,
    required this.data,
    required this.footer,
  });

  factory RewardsActivityResponse.fromJson(Map<String, dynamic> json) {
    final dataList = (json['data'] as List?)
            ?.map((item) => RewardsActivityItem.fromJson(item))
            .toList() ??
        [];
    return RewardsActivityResponse(
      header: json['header'] ?? {},
      data: dataList,
      footer: json['footer'] ?? {},
    );
  }
}

class RedeemPointsRequest {
  final int points;
  final String description;

  RedeemPointsRequest({
    required this.points,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'points': points,
      'description': description,
    };
  }
}
