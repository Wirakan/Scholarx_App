enum NotificationType { status, announcement }

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String? statusLabel;
  final DateTime createdAt;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    this.statusLabel,
    required this.createdAt,
    this.isRead = false,
  });
}