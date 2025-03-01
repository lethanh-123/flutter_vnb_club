class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  final List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;

  List<Map<String, dynamic>> get notifications => _notifications;

  int get unreadCount => _unreadCount;

  void addNotification(Map<String, dynamic> notification) {
    _notifications.insert(0, notification);
    _unreadCount++; // Tăng số lượng thông báo chưa đọc
  }

  void markAllAsRead() {
    _unreadCount = 0; // Đánh dấu tất cả thông báo là đã đọc
  }
}
