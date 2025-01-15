import 'package:flutter/material.dart';
import 'match_detail_screen.dart';
import 'create_options_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';
import 'club_join_screen.dart';
import 'community_screen.dart';
import 'statistics_screen.dart';
import 'court_management_screen.dart';
import 'user_management_screen.dart';
import 'package:flutter/services.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  DateTime? _lastPressedAt;
  final List<Widget> _screens = [
    const HomeContent(),
    const ClubJoinScreen(),
    const CommunityScreen(),
    const StatisticsScreen(),
    const ManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null || 
            DateTime.now().difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          // Lần đầu ấn back hoặc đã quá 2 giây từ lần ấn trước
          _lastPressedAt = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ấn back lần nữa để thoát ứng dụng'),
              duration: Duration(seconds: 4),
            ),
          );
          return false;
        }
        SystemNavigator.pop();
        return false; // Cho phép thoát ứng dụng
      },
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Trang Chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Tìm kiếm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Cộng đồng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Thống kê',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Quản lý',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header với avatar và notification
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/ava.png'),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'User Admin',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateOptionsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Club stories
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildClubStory(
                  logo: 'assets/pickcelball1.jpg',
                  name: 'ESE TENNIS',
                  isRequested: true,
                ),
                _buildClubStory(
                  logo: 'assets/pickcelball1.jpg',
                  name: 'Khét Lẹt\nPickleball - Gò Vấp',
                ),
                _buildClubStory(
                  logo: 'assets/pickcelball1.jpg',
                  name: 'NewBorn\nPickleball',
                ),
                _buildClubStory(
                  logo: 'assets/pickcelball1.jpg',
                  name: 'Oasis Pickleball\nQuận 2',
                ),
              ],
            ),
          ),

          // Hôm nay section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Hôm nay',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),

          // Match list
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Timeline column
                SizedBox(
                  width: 60,
                  child: ListView(
                    children: const [
                      _TimelineItem(time: '7:00'),
                      _TimelineItem(time: '7:30'),
                      _TimelineItem(time: '8:00'),
                    ],
                  ),
                ),
                // Vertical timeline line
                Container(
                  width: 1,
                  color: Colors.grey[300],
                ),
                // Matches column
                Expanded(
                  child: ListView(
                    children: [
                      _buildMatchItem(
                        context: context,
                        time: '7:00',
                        logo: 'assets/match.jpg',
                        title:
                            '[PICKOLAND] ALL LEVEL 7-10AM | MIỄN PHÍ NGƯỜI LẦN ĐẦU',
                        location: 'PickoLand Thảo Điền Pickleball',
                        participants: '3/10 Xác nhận tham gia',
                      ),
                      _buildMatchItem(
                        context: context,
                        time: '7:00',
                        logo: 'assets/match.jpg',
                        title:
                            '[2.5-3.0] Morning Social @PickoLand - PickoNect',
                        location: 'PickoLand Thảo Điền Pickleball',
                        participants: '6/18 Xác nhận tham gia',
                      ),
                      _buildMatchItem(
                        context: context,
                        time: '7:30',
                        logo: 'assets/match.jpg',
                        title: 'Tuyển social',
                        location: 'Pickleball Xuân Anh',
                        participants: '1/12 Xác nhận tham gia',
                      ),
                      _buildMatchItem(
                        context: context,
                        time: '8:00',
                        logo: 'assets/match.jpg',
                        title:
                            'Giao hữu 8h tại 110 Đào sư tích. Pk. Nhà Bè. 60k/người',
                        location: '110 Đ. Đào Sư Tích',
                        participants: '1/8 Xác nhận tham gia',
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
          Stack(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage(logo),
              ),
              if (isRequested)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
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
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchItem({
    required BuildContext context,
    required String time,
    required String logo,
    required String title,
    required String location,
    required String participants,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailScreen(
              time: time,
              date: 'Thứ hai, 6/1',
              title: '🔥 LỚP LOTUS HEALTHY JUICE | 3 TIẾNG - 110K',
              teamName: 'ESE PICKLEBALL',
              teamLogo: logo,
              subtitle: 'Thứ hai hàng tuần',
              location: location,
              fullAddress:
                  '1A Đ. Phú Thuận, Phú Thuận, Quận 7, Hồ Chí Minh 72907, Vietnam',
              level: '2.5 - 3.5 [Trình (tự đánh giá)]',
              price: '110.000 đ',
              notes: [
                'Thời gian: 9:00 - 12:00',
                'Địa điểm: ESE Academy Tennis-Pickleball-Foam tennis',
                'Chặn rời khỏi kèo trước 12 tiếng kèo bắt đầu',
              ],
              maxParticipants: 6,
              currentParticipants: 1,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(logo),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    participants,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
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

class _TimelineItem extends StatelessWidget {
  final String time;

  const _TimelineItem({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildManagementTile(
              context,
              icon: Icons.sports_tennis,
              title: 'Quản lý sân',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CourtManagementScreen(),
                  ),
                );
              },
            ),
            _buildManagementTile(
              context,
              icon: Icons.people,
              title: 'Quản lý người dùng',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserManagementScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
