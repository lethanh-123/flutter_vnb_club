import 'package:flutter/material.dart';
import 'match_screen.dart';
import 'tournament_screen.dart';
import 'coach_screen.dart';
import 'club_detail_screen.dart';

class ClubJoinScreen extends StatefulWidget {
  const ClubJoinScreen({Key? key}) : super(key: key);

  @override
  State<ClubJoinScreen> createState() => _ClubJoinScreenState();
}

class _ClubJoinScreenState extends State<ClubJoinScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTab = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm bằng từ khoá hoặc mã',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              _buildTab('CLB', Icons.shield, 0),
              _buildTab('KÈO', Icons.calendar_today, 1),
              _buildTab('GIẢI ĐẤU', Icons.emoji_events, 2),
              _buildTab('NGƯỜI CHƠI', Icons.person, 3),
              _buildTab('HLV', Icons.sports, 4),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab CLB
                Column(
                  children: [
                    // Filter Chips cho tab CLB
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          _buildFilterChip(
                              'Ho Chi Minh City Metropolitan', true),
                          _buildFilterChip('Thể thao', false),
                        ],
                      ),
                    ),
                    // Danh sách CLB
                    Expanded(
                      child: _buildClubList(),
                    ),
                  ],
                ),

                // Tab KÈO
                const MatchScreen(), // Trang KÈO riêng biệt

                // Các tab khác
                const TournamentScreen(),
                Center(child: Text('Trang Người chơi')),
                const CoachScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClubList() {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildClubCard(
          logoUrl: 'assets/logo_pic.jpg',
          name: 'SkyPickleball',
          members: 124,
          skillLevel: 'Tất cả trình độ',
          activityTime: 'Th01 4',
          schedule: '6:00',
          description: 'SÁNG THỨ 7 VUI VẺ. SKY PICKLE',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubDetailScreen(
                clubName: 'SkyPickleball',
                clubLogo: 'assets/logo_pic.jpg',
                coverImage: 'assets/pickcelball1.jpg',
                type: 'Công khai',
                sport: 'Pickleball',
                level: 'Tất cả trình độ',
                activities: [
                  Activity(
                    dayOfWeek: 'Thứ bảy',
                    time: '6:00',
                    title: 'SÁNG THỨ 7 VUI VẺ. SKY PICKLE',
                    currentParticipants: 18,
                    maxParticipants: 24,
                  ),
                ],
                admins: [
                  Admin(
                    name: 'Sky Coach',
                    role: 'Coach',
                    avatarUrl: 'assets/coach_2.jpg',
                  ),
                  Admin(
                    name: 'Sky Admin',
                    role: 'Admin',
                    avatarUrl: 'assets/coach_2.jpg',
                  ),
                ],
                memberCount: 124,
                activityCount: 35,
                schedule: 'Mỗi ngày',
                description:
                    'CLB Pickleball dành cho mọi trình độ, tập luyện vui vẻ mỗi sáng.',
              ),
            ),
          ),
        ),
        _buildClubCard(
          logoUrl: 'assets/logo_pic.jpg',
          name: 'D&S Pickleball Club',
          members: 182,
          skillLevel: '3.0',
          activityTime: 'Th01 6',
          schedule: '19:00',
          description: 'HAPPY MONDAY SOCIAL 😊',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubDetailScreen(
                clubName: 'D&S Pickleball Club',
                clubLogo: 'assets/logo_pic.jpg',
                coverImage: 'assets/p2.jpg',
                type: 'Công khai',
                sport: 'Pickleball',
                level: '3.0',
                activities: [
                  Activity(
                    dayOfWeek: 'Thứ hai',
                    time: '19:00',
                    title: 'HAPPY MONDAY SOCIAL',
                    currentParticipants: 22,
                    maxParticipants: 24,
                  ),
                ],
                admins: [
                  Admin(
                    name: 'D&S Coach',
                    role: 'Coach',
                    avatarUrl: 'assets/coach_2.jpg',
                  ),
                  Admin(
                    name: 'D&S Manager',
                    role: 'Admin',
                    avatarUrl: 'assets/coach_2.jpg',
                  ),
                ],
                memberCount: 182,
                activityCount: 42,
                schedule: 'Mỗi ngày',
                description:
                    'CLB Pickleball chuyên nghiệp, tập trung vào người chơi trình độ 3.0+',
              ),
            ),
          ),
        ),
        _buildClubCard(
          logoUrl: 'assets/logo_pic.jpg',
          name: 'TS Sports Club',
          members: 757,
          skillLevel: 'Tất cả trình độ',
          activityTime: 'Hoạt động 2 phút trước',
          schedule: '',
          description: 'Social Everyday Pickleball',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubDetailScreen(
                clubName: 'TS Sports Club',
                clubLogo: 'assets/logo_pic.jpg',
                coverImage: 'assets/p3.jpg',
                type: 'Công khai',
                sport: 'Pickleball',
                level: 'Tất cả trình độ',
                activities: [
                  Activity(
                    dayOfWeek: 'Hàng ngày',
                    time: '8:00',
                    title: 'Social Everyday Pickleball',
                    currentParticipants: 32,
                    maxParticipants: 40,
                  ),
                ],
                admins: [
                  Admin(
                    name: 'TS Head Coach',
                    role: 'Coach',
                    avatarUrl: 'assets/coach_2.jpg',
                  ),
                  Admin(
                    name: 'TS Admin 1',
                    role: 'Admin',
                    avatarUrl: 'assets/coach_2.jpg',
                  ),
                  Admin(
                    name: 'TS Admin 2',
                    role: 'Admin',
                    avatarUrl: 'assets/coach_2.jpg',
                  ),
                ],
                memberCount: 757,
                activityCount: 65,
                schedule: 'Mỗi ngày',
                description:
                    'CLB Pickleball lớn nhất khu vực, chào đón mọi trình độ.',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, IconData icon, int index) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedTab == index ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: _selectedTab == index ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // TODO: Handle filter change
        },
      ),
    );
  }

  Widget _buildClubCard({
    required String logoUrl,
    required String name,
    required int members,
    required String skillLevel,
    required String activityTime,
    required String schedule,
    required String description,
    required VoidCallback onTap, // Thêm parameter onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Club Logo
              CircleAvatar(
                backgroundImage:
                    AssetImage(logoUrl), // Đổi NetworkImage thành AssetImage
                radius: 24,
              ),
              const SizedBox(width: 12),
              // Club Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Club Name
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Member Count and Skill Level
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16),
                        const SizedBox(width: 4),
                        Text('$members Thành viên'),
                        const SizedBox(width: 8),
                        const Icon(Icons.sports_tennis, size: 16),
                        const SizedBox(width: 4),
                        Text(skillLevel),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Activity Time
                    Text(
                      activityTime,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Schedule
              if (schedule.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      schedule,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
