import 'package:flutter/material.dart';
import 'notificationManager.dart';
import 'match_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationManager().notifications;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Thông báo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to notification settings
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Hôm nay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (notifications.isEmpty)
            const Center(
              child: Text('Không có thông báo mới'),
            ),
          ...notifications.map((notification) {
            return GestureDetector(
              onTap: () {
                // Điều hướng đến màn hình chi tiết kèo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MatchDetailScreen(
                      time: '10:00',
                      date: '2023-10-10',
                      title: 'Kèo Pickleball Giao hữu',
                      teamName: 'Team A',
                      teamLogo: 'assets/team_a.png',
                      subtitle: 'Giao hữu với Team B',
                      location: 'Sân Pickleball Đức Lợi',
                      fullAddress:
                          '111 Lê Đức Thọ, Phường 14, Gò Vấp, Hồ Chí Minh',
                      level: '2.5',
                      price: '100.000 VNĐ',
                      notes: [
                        'Mang theo vợt',
                        'Đến sớm 15 phút',
                      ],
                      maxParticipants: 12,
                      currentParticipants: 8,
                      matchInfo: {
                        'time': '10:00',
                        'date': '2023-10-10',
                        'title': 'Kèo Pickleball Giao hữu',
                        'teamName': 'Team A',
                        'teamLogo': 'assets/team_a.png',
                        'subtitle': 'Giao hữu với Team B',
                        'location': 'Sân Pickleball Đức Lợi',
                        'fullAddress':
                            '111 Lê Đức Thọ, Phường 14, Gò Vấp, Hồ Chí Minh',
                        'level': '2.5',
                        'price': '100.000 VNĐ',
                        'notes': [
                          'Mang theo vợt',
                          'Đến sớm 15 phút',
                        ],
                        'maxParticipants': 12,
                        'currentParticipants': 8,
                      },
                    ),
                  ),
                );
              },
              child: _buildNotificationItem(
                title: notification['title'],
                message: notification['message'],
                time: notification['time'],
                icon: notification['icon'],
                iconBackgroundColor: notification['iconBackgroundColor'],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    IconData? icon,
    String? imageUrl,
    Color? iconBackgroundColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackgroundColor ?? Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white),
              )
            else if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(message),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
