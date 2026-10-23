import 'notifications_models.dart';

const mockNotifications = [
  AppNotificationItem(
    title: 'New Trip Assigned',
    message: 'Trip TRP-2026-073 has been assigned to your route.',
    timeLabel: '5 min ago',
    isUnread: true,
    icon: 'assignment',
  ),
  AppNotificationItem(
    title: 'Trip Updated',
    message: 'Stop 4 has been marked as navigating by dispatch.',
    timeLabel: '20 min ago',
    isUnread: true,
    icon: 'update',
  ),
  AppNotificationItem(
    title: 'Trip Cancelled',
    message: 'Trip TRP-2026-066 was cancelled by the admin team.',
    timeLabel: 'Today, 08:15',
    isUnread: false,
    icon: 'cancel',
  ),
  AppNotificationItem(
    title: 'Delivery Reminder',
    message: '3 stops remain on your active trip for today.',
    timeLabel: 'Today, 07:40',
    isUnread: false,
    icon: 'alarm',
  ),
];