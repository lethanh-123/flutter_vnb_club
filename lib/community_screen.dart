import 'package:flutter/material.dart';
import 'post_detail_sheet.dart';
import 'club_selection_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cộng đồng',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClubSelectionScreen(),
                ),
              );
            },
            child: const Text(
              'Viết bài',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildPostItem(
            context: context,
            clubName: 'Pickleball Social Quận 4',
            authorName: 'Phương Nguyễn',
            timeAgo: '20 phút trước',
            content: '''Social hôm nay 👇 👇

🎊🎉🔥♦️ Social - All levels -4 sân- 7pm-9pm - D'lucky 458 Nguyễn Tất Thành, quận 4

⏰ T4, ngày 8 Th01 lúc 19:00

📍 458 Đ. Nguyễn Tất Thành

Đăng ký: https://reclub.co/m/HJQBF7

Zalo đặt chỗ: 0947 114 445''',
            eventCard: _buildEventCard(),
          ),
          _buildPostItem(
            context: context,
            clubName: 'PICKLE CHILL CLUB',
            authorName: 'Cơ Chỉ',
            timeAgo: 'một giờ trước',
            content: '''Social hôm nay 👇 👇

🎊🎉🔥♦️ Social - All levels -4 sân- 7pm-9pm - D'lucky 458 Nguyễn Tất Thành, quận 4

⏰ T4, ngày 8 Th01 lúc 19:00

📍 458 Đ. Nguyễn Tất Thành

Đăng ký: https://reclub.co/m/HJQBF7

Zalo đặt chỗ: 0947 114 445''', // Empty content for second post
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem({
    required BuildContext context, // Thêm context vào parameters
    required String clubName,
    required String authorName,
    required String timeAgo,
    String? postType,
    required String content,
    Widget? eventCard,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/pic.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clubName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$authorName • $timeAgo',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => PostDetailSheet(
                        clubName: clubName,
                        authorName: authorName,
                        postTime: 'Thứ tư, ngày 8 Tháng 1 lúc 10:36',
                      ),
                    );
                  },
                ),
              ],
            ),
            if (content.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(content),
            ],
            if (eventCard != null) ...[
              const SizedBox(height: 12),
              eventCard,
            ],
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_outlined),
                  label: const Text('React'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.comment_outlined),
                  label: const Text('Bình luận'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'T4',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '08/01',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '19:00',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'RSVP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'PICKLEBALL SOCIAL QUẬN 4',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '🎊🎉🔥♦️ Social - All levels -4 sân- 7pm-9pm - D\'lucky 458 N...',
                      ),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          const Text('458 Đ. Nguyễn Tất Thành'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text('13/32'),
                          SizedBox(width: 8),
                          CircleAvatar(radius: 12),
                          CircleAvatar(radius: 12),
                          CircleAvatar(radius: 12),
                          CircleAvatar(radius: 12),
                          Text('+11'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
