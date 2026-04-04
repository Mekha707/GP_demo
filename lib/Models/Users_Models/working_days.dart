class WorkingDays {
  final bool isSaturdayOpen;
  final bool isSundayOpen;
  final bool isMondayOpen;
  final bool isTuesdayOpen;
  final bool isWednesdayOpen;
  final bool isThursdayOpen;
  final bool isFridayOpen;

  WorkingDays({
    required this.isSaturdayOpen,
    required this.isSundayOpen,
    required this.isMondayOpen,
    required this.isTuesdayOpen,
    required this.isWednesdayOpen,
    required this.isThursdayOpen,
    required this.isFridayOpen,
  });

  factory WorkingDays.fromJson(Map<String, dynamic> json) {
    return WorkingDays(
      isSaturdayOpen: json['isSaturdayOpen'] ?? false,
      isSundayOpen: json['isSundayOpen'] ?? false,
      isMondayOpen: json['isMondayOpen'] ?? false,
      isTuesdayOpen: json['isTuesdayOpen'] ?? false,
      isWednesdayOpen: json['isWednesdayOpen'] ?? false,
      isThursdayOpen: json['isThursdayOpen'] ?? false,
      isFridayOpen: json['isFridayOpen'] ?? false,
    );
  }

  factory WorkingDays.defaultDays() {
    return WorkingDays(
      isSaturdayOpen: false,
      isSundayOpen: false,
      isMondayOpen: false,
      isTuesdayOpen: false,
      isWednesdayOpen: false,
      isThursdayOpen: false,
      isFridayOpen: false,
    );
  }
}
