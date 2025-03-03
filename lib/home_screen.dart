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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dupr_ranking_screen.dart';
import 'street_cred_screen.dart';
import 'category_cards.dart';
import 'providers.dart';
import 'notificationManager.dart';

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
  String _currentStatsView = 'Trận đấu';
  bool _hasNewNotification = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _checkForNewNotifications();
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

  void _checkForNewNotifications() {
    setState(() {
      _hasNewNotification = NotificationManager().unreadCount > 0;
    });
  }

  Widget _getStatsContent() {
    switch (_currentStatsView) {
      case 'Trận đấu':
        return const StatisticsScreen(
          showAppBar: false,
        );
      case 'Xếp hạng':
        return const DuprRankingScreen(
          showBottomNav: false,
          showAppBar: false,
        );
      case 'Độ uy tín':
        return const StreetCredScreen(
          showBottomNav: false,
          showAppBar: false,
        );
      default:
        return const StatisticsScreen(
          showAppBar: false,
        );
    }
  }

  Widget _buildStatisticsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title section based on current view
        _buildStatisticsTitle(),

        // Category selection
        CategoryCards(
          selectedCategory: _currentStatsView,
          onCategorySelected: (category) {
            setState(() {
              _currentStatsView = category;
            });
          },
        ),

        // Content
        Expanded(
          child: _getStatsContent(),
        ),
      ],
    );
  }

  Widget _buildStatisticsTitle() {
    switch (_currentStatsView) {
      case 'Trận đấu':
        return Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 48.0,
            bottom: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thống kê',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Cập nhật hàng ngày',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );

      case 'Xếp hạng':
        return Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 48.0,
            bottom: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Xếp hạng DUPR',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Cập nhật hàng ngày',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );

      case 'Độ uy tín':
        return const Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 48.0,
            bottom: 16.0,
          ),
          child: Text(
            'Street Cred: Bảng xếp hạng',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 3 && _currentStatsView != 'Trận đấu') {
          setState(() {
            _currentStatsView = 'Trận đấu';
          });
          return false;
        }
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
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            HomeContent(
              matches: matches,
              tournaments: tournaments,
              isLoading: isLoading,
              error: error,
              onRefresh: _fetchData,
            ),
            const ClubJoinScreen(),
            const CommunityScreen(),
            _buildStatisticsView(),
            const ManagementScreen(),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                if (index != 3) {
                  _currentStatsView = 'Trận đấu';
                }
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined),
                activeIcon: Icon(Icons.search),
                label: 'Tìm kiếm',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.people_outlined),
                activeIcon: Icon(Icons.people),
                label: 'Cộng đồng',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.bar_chart_outlined),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${NotificationManager().unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                activeIcon: const Icon(Icons.bar_chart),
                label: 'Thống kê',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(
                      Icons.settings,
                      color: _hasNewNotification ? Colors.blue : Colors.grey,
                    ),
                  ],
                ),
                // activeIcon: Icon(
                //   Icons.notifications,
                //   color: _hasNewNotification ? Colors.blue : Colors.grey,
                // ),
                label: 'Quản lý',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({
    Key? key,
    required this.matches,
    required this.tournaments,
    required this.isLoading,
    this.error,
    required this.onRefresh,
  }) : super(key: key);

  final List<Match> matches;
  final List<Tournament> tournaments;
  final bool isLoading;
  final String? error;
  final Future<void> Function() onRefresh;

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  final ScrollController _timelineScrollController = ScrollController();
  final ScrollController _matchesScrollController = ScrollController();
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();

    // Lắng nghe scroll để đồng bộ hóa timeline
    _matchesScrollController.addListener(() {
      if (!_isUserScrolling) {
        _isUserScrolling = true;
        _timelineScrollController.jumpTo(_matchesScrollController.offset);
        _isUserScrolling = false;
      }
    });

    // Lắng nghe scroll để đồng bộ hóa matches
    _timelineScrollController.addListener(() {
      if (!_isUserScrolling) {
        _isUserScrolling = true;
        _matchesScrollController.jumpTo(_timelineScrollController.offset);
        _isUserScrolling = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lỗi: ${widget.error}'),
            ElevatedButton(
              onPressed: widget.onRefresh,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: widget.onRefresh,
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
                    child: profileAsync.when(
                      data: (profile) => CircleAvatar(
                        radius: 20,
                        backgroundImage: const AssetImage('assets/ava.png'),
                      ),
                      loading: () => const CircleAvatar(
                        radius: 20,
                        child: CircularProgressIndicator(),
                      ),
                      error: (_, __) => const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/ava.png'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  profileAsync.when(
                    data: (profile) => Text(
                      profile.fullName ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    loading: () => const Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    error: (_, __) => const Text(
                      'User Admin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons
                            .notifications_outlined), // Biểu tượng thông báo
                        if (NotificationManager().unreadCount >
                            0) // Chỉ hiển thị badge nếu có thông báo chưa đọc
                          Positioned(
                            right: 0, // Đặt badge ở góc phải trên cùng
                            child: Container(
                              padding:
                                  const EdgeInsets.all(2), // Padding cho badge
                              decoration: BoxDecoration(
                                color: Colors.red, // Màu nền của badge
                                borderRadius:
                                    BorderRadius.circular(6), // Bo góc
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 12, // Kích thước tối thiểu
                                minHeight: 12,
                              ),
                              child: Text(
                                '${NotificationManager().unreadCount}', // Hiển thị số lượng thông báo chưa đọc
                                style: const TextStyle(
                                  color: Colors.white, // Màu chữ
                                  fontSize: 8, // Kích thước chữ
                                ),
                                textAlign: TextAlign.center, // Căn giữa chữ
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: () {
                      // Đánh dấu tất cả thông báo là đã đọc khi mở màn hình thông báo
                      NotificationManager().markAllAsRead();

                      // Cập nhật giao diện
                      setState(() {});

                      // Điều hướng đến màn hình thông báo
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
            if (widget.tournaments.isNotEmpty) ...[
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
                  itemCount: widget.tournaments.length,
                  itemBuilder: (context, index) {
                    final tournament = widget.tournaments[index];
                    return _buildTournamentCard(tournament);
                  },
                ),
              ),
            ],

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
            Expanded(
              child: widget.matches.isEmpty
                  ? const Center(
                      child: Text('Không có trận đấu nào hôm nay'),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTimelineColumn(widget.matches),
                        Container(
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        _buildMatchesColumn(context, widget.matches),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineColumn(List<Match> matches) {
    return SizedBox(
      width: 60,
      child: ListView.builder(
        controller: _timelineScrollController,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return Container(
            height: 120,
            alignment: Alignment.center,
            child: Text(
              DateFormat('HH:mm').format(match.datetime),
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTournamentCard(Tournament tournament) {
    return Container(
      width: 200,
      height: 110,
      margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
      padding: const EdgeInsets.all(8),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tournament.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            DateFormat('dd/MM/yyyy HH:mm').format(tournament.datetime),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            tournament.location,
            style: const TextStyle(fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '${tournament.currentParticipants}/${tournament.maxPlayers} người tham gia',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 11,
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
        height: 120,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    match.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    match.location,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${match.currentParticipants}/${match.maxPlayers} Xác nhận tham gia',
                    style: const TextStyle(
                      color: Colors.blue,
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

  Widget _buildMatchesColumn(BuildContext context, List<Match> matches) {
    return Expanded(
      child: ListView.builder(
        controller: _matchesScrollController,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return SizedBox(
            height: 120,
            child: _buildMatchItem(context: context, match: match),
          );
        },
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
