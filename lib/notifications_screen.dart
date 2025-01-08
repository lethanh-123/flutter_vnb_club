import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          _buildNotificationItem(
            title:
                'PICKLEBALL: [PRESET TEAM/2 HOURS] NEWBIE - 2.5 TEAM NGẪU NHIÊN CÓ QUÀ TẶNG ❤️❤️💥💥',
            message:
                'Thành Nguyễn 3T is looking for 4 players today at 3T Pickleball Club - Sân trong nhà. Can you join?',
            time: '2 phút trước',
            icon: Icons.calendar_today,
            iconBackgroundColor: Colors.amber,
          ),
          _buildNotificationItem(
            title: 'BIG BALLS PICKLE CLUB',
            message: "You've been invited to join Big Balls Pickle Club.",
            time: '7 phút trước',
            imageUrl: 'assets/pickcelball1.jpg',
          ),
          _buildNotificationItem(
            title: 'PICKLEBALL: BIGBALLS X AP: SOCIAL 3.0 (PRIVATE CLUB)',
            message:
                'Kimbap Nguyen is looking for 4 players today at AP Sports Club. Can you join?',
            time: '8 phút trước',
            icon: Icons.calendar_today,
            iconBackgroundColor: Colors.amber,
          ),
          _buildNotificationItem(
            title:
                'PICKLEBALL: 🎾SOCIAL MEET (ALL LEVEL) 4 SÂN 19H-21H D\'LUCKY 458 NGUYỄN TẤT THÀNH, QUẬN 4',
            message:
                'Phương Nguyễn is looking for 24 players today at 458 Đ. Nguyễn Tất Thành. Can you join?',
            time: '25 phút trước',
            icon: Icons.calendar_today,
            iconBackgroundColor: Colors.amber,
          ),
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
