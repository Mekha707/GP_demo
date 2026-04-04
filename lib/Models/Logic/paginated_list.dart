class PaginatedList<T> {
  final List<T> items;
  final int pageNumber;
  final int totalCount;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  PaginatedList({
    required this.items,
    required this.pageNumber,
    required this.totalCount,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory PaginatedList.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedList(
      items:
          (json['items'] as List?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
      pageNumber: json['pageNumber'] as int,
      totalCount: json['totalCount'] as int,
      pageSize: json['pageSize'] as int,
      totalPages: json['totalPages'] as int,
      hasPreviousPage: json['hasPreviousPage'] as bool,
      hasNextPage: json['hasNextPage'] as bool,
    );
  }
}
