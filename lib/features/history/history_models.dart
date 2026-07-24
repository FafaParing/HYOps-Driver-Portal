class HistoryEntry {
  const HistoryEntry({
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.status,
    required this.kind,
    required this.tripId,
  });

  final String title;
  final String subtitle;
  final String dateLabel;
  final String status;
  final String kind;
  final String tripId;
}