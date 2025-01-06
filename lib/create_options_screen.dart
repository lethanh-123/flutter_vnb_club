import 'package:flutter/material.dart';
import 'create_match_screen.dart';
import 'create_tournament_screen.dart';

class CreateOptionsScreen extends StatelessWidget {
  const CreateOptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/ava.png'),
            ),
            const SizedBox(width: 12),
            const Text('User Admin'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle),
            color: Colors.blue,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Club stories
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildClubStory(
                    logo: 'assets/ese_tennis.png',
                    name: 'ESE TENNIS',
                    isRequested: true,
                  ),
                  _buildClubStory(
                    logo: 'assets/atp_lab.png',
                    name: 'ATP LAB TOUR',
                  ),
                  _buildClubStory(
                    logo: 'assets/social_pickle.png',
                    name: 'Social Pickleball\nvà Coach Hiếu',
                  ),
                  _buildClubStory(
                    logo: 'assets/ese_pickle.png',
                    name: 'ESE PICKLEBALL',
                  ),
                ],
              ),
            ),

            // Create options
            _buildCreateOption(
              icon: Icons.calendar_today,
              color: Colors.cyan,
              title: 'Tạo kèo',
              description:
                  'Nhanh chóng kết hợp một trò chơi hoặc lớp học với trình tạo trận đấu cơ bản cho các trận đấu vòng tròn thông thường.',
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return const CreateMatchScreen();
                  },
                );
              },
            ),
            _buildCreateOption(
              icon: Icons.emoji_events,
              color: Colors.redAccent,
              title: 'Tạo giải đấu',
              description:
                  'Tổ chức một giải đấu hoặc giải đấu chính thức với tính năng đăng ký, trận đấu và theo dõi số liệu thống kê. Hỗ trợ hầu hết các định dạng phổ biến.',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateTournamentScreen(),
                  ),
                );
              },
            ),
            _buildCreateOption(
              icon: Icons.home,
              color: Colors.amber,
              title: 'Tạo CLB',
              description:
                  'Tập hợp tất cả các thành viên hoặc bạn bè của bạn ở cùng một nơi. Chia sẻ hình ảnh, trò chuyện và tổ chức các hoạt động thường xuyên.',
              onTap: () {
                // TODO: Navigate to create club screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubStory({
    required String logo,
    required String name,
    bool isRequested = false,
  }) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(logo),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isRequested)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Đã yêu cầu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCreateOption({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: color),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
