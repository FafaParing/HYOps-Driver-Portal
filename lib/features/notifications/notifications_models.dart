class AppNotificationItem {
  const AppNotificationItem({
    required this.title,
    required this.message,
    required this.timeLabel,
    required this.isUnread,
    required this.icon,
  });

  final String title;
  final String message;
  final String timeLabel;
  final bool isUnread;
  final String icon;
}