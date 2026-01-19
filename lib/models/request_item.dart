class RequestItem {
  final int id;
  final String companyName;
  final String status; // PENDING / APPROVED / REJECTED

  RequestItem({
    required this.id,
    required this.companyName,
    required this.status,
  });

  factory RequestItem.fromJson(Map<String, dynamic> json) {
    return RequestItem(
      id: json['id'],
      companyName: json['companyName'],
      status: json['status'],
    );
  }
}
