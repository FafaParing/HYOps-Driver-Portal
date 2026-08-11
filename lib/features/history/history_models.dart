class HistoryEntry {
  const HistoryEntry({
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.status,
    required this.kind,
    required this.tripId,
    required this.products,
    required this.address,
    required this.deliveryTime,
    required this.receiptNumber,
  });

  final String title;
  final String subtitle;
  final String dateLabel;
  final String status;
  final String kind;
  final String tripId;
  final List<String> products;
  final String address;
  final String deliveryTime;
  final String receiptNumber;
}