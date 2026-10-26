class HistoryEntry {
  const HistoryEntry({
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.status,
    required this.kind,
    required this.tripId,
    required this.receiverName,
    required this.products,
    required this.address,
    required this.deliveryDate,
    required this.deliveryTime,
    required this.receiptNumber,
    this.reason,
  });

  final String title;
  final String subtitle;
  final String dateLabel;
  final String status;
  final String kind;
  final String tripId;
  final String receiverName;
  final List<String> products;
  final String address;
  final String deliveryDate;
  final String deliveryTime;
  final String receiptNumber;
  final String? reason;
}