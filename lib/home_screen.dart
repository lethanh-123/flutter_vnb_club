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
import 'tournament.dart';
import 'match.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'court_management_screen.dart';
import 'user_management_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  DateTime? _lastPressedAt;
  List<Match> matches = [];
  List<Tournament> tournaments = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;

    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final result = await ApiService.getMatchesAndTournaments();

      if (!mounted) return;

      setState(() {
        matches = (result['matches'] as List).cast<Match>();
        tournaments = (result['tournaments'] as List).cast<Tournament>();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        error = e.toString();
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeContent(
        matches: matches,
        tournaments: tournaments,
        isLoading: isLoading,
        error: error,
        onRefresh: _fetchData,
      ),
      const ClubJoinScreen(),
      const CommunityScreen(),
      const StatisticsScreen(),
      const ManagementScreen(),
    ];

    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt!) >
                const Duration(seconds: 2)) {
          _lastPressedAt = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nhấn back lần nữa để thoát'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
        await SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              activeIcon: Icon(Icons.group),
              label: 'CLB',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              activeIcon: Icon(Icons.people),
              label: 'Cộng đồng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'Thống kê',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Quản lý',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<Match> matches;
  final List<Tournament> tournaments;
  final bool isLoading;
  final String? error;
  final Future<void> Function() onRefresh;

  const HomeContent({
    Key? key,
    required this.matches,
    required this.tournaments,
    required this.isLoading,
    this.error,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lỗi: $error'),
            ElevatedButton(
              onPressed: onRefresh,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/ava.png'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'User Admin',
                    style: TextStyle(
                      fontSize: 16,
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

            // Tournaments section
            if (tournaments.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Giải đấu sắp diễn ra',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tournaments.length,
                  itemBuilder: (context, index) {
                    final tournament = tournaments[index];
                    return _buildTournamentCard(tournament);
                  },
                ),
              ),
            ],

            // Today's matches section
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
              child: matches.isEmpty
                  ? const Center(
                      child: Text('Không có trận đấu nào hôm nay'),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline column
                        SizedBox(
                          width: 60,
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: false),
                            child: ListView.builder(
                              padding: EdgeInsets.zero, // Thêm vào
                              physics:
                                  const ClampingScrollPhysics(), // Thêm vào
                              itemCount: matches.length,
                              itemBuilder: (context, index) {
                                final match = matches[index];
                                return Container(
                                  height:
                                      120, // Chiều cao cố định giống với match item
                                  alignment: Alignment.center, // Căn giữa text
                                  child: _TimelineItem(
                                    time: DateFormat('HH:mm')
                                        .format(match.datetime),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Vertical timeline line
                        Container(
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        // Matches column
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: ScrollConfiguration.of(context)
                                .copyWith(scrollbars: false),
                            child: ListView.builder(
                              padding: EdgeInsets.zero, // Thêm vào
                              physics:
                                  const ClampingScrollPhysics(), // Thêm vào
                              itemCount: matches.length,
                              itemBuilder: (context, index) {
                                final match = matches[index];
                                return Container(
                                  height: 120, // Chiều cao cố định
                                  child: _buildMatchItem(
                                    context: context,
                                    match: match,
                                  ),
                                );
                              },
                            ),
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

  Widget _buildTournamentCard(Tournament tournament) {
    return Container(
      width: 200,
      height: 110, // Thêm chiều cao cố định
      margin:
          const EdgeInsets.only(right: 12, top: 4, bottom: 4), // Giảm margin
      padding: const EdgeInsets.all(8), // Giảm padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Thêm dòng này
        children: [
          Text(
            tournament.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13, // Giảm font size
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2), // Giảm spacing
          Text(
            DateFormat('dd/MM/yyyy HH:mm').format(tournament.datetime),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11, // Giảm font size
            ),
          ),
          const SizedBox(height: 2), // Giảm spacing
          Text(
            tournament.location,
            style: const TextStyle(fontSize: 11), // Giảm font size
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2), // Giảm spacing
          Text(
            '${tournament.currentParticipants}/${tournament.maxPlayers} người tham gia',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 11, // Giảm font size
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchItem({
    required BuildContext context,
    required Match match,
  }) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => MatchDetailScreen(match: match),
        //   ),
        // );
      },
      child: Container(
        height: 120, // Chiều cao cố định
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8), // Giảm padding
        child: Row(
          children: [
            Image.asset(
              'assets/match.jpg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Thêm dòng này
                children: [
                  Text(
                    match.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Giảm font size
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Giảm spacing
                  Text(
                    match.location,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12, // Giảm font size
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4), // Giảm spacing
                  Text(
                    '${match.currentParticipants}/${match.maxPlayers} Xác nhận tham gia',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12, // Giảm font size
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

  const _TimelineItem({required this.time});

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildManagementTile(
            context,
            icon: Icons.sports_tennis,
            title: 'Quản lý sân',
            subtitle: 'Thêm, sửa, xóa sân thi đấu',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CourtManagementScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          _buildManagementTile(
            context,
            icon: Icons.people,
            title: 'Quản lý người dùng',
            subtitle: 'Phân quyền, quản lý thành viên',
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
    );
  }

  Widget _buildManagementTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor, size: 32),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
      ),
    );
  }
}
