class PaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  PaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'],
      perPage: json['per_page'],
      total: json['total'],
      lastPage: json['last_page'],
    );
  }

  bool get hasMorePages => currentPage < lastPage;
}
