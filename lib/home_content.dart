import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vnb_ios/create_options_screen.dart';
import 'package:flutter_vnb_ios/notifications_screen.dart';
import 'package:flutter_vnb_ios/profile_notifier.dart' as notifier;
import 'package:flutter_vnb_ios/profile_screen.dart' as screen;
import 'package:flutter_vnb_ios/profile_screen.dart';
import 'package:intl/intl.dart';
import 'api_service.dart';
import 'tournament.dart';
import 'tournament_detail_screen.dart';
import 'match_detail_screen.dart';
import 'match.dart';
import 'notificationManager.dart';

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
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  final ScrollController _timelineScrollController = ScrollController();
  final ScrollController _matchesScrollController = ScrollController();
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _matchesScrollController.addListener(_syncScroll);
    _timelineScrollController.addListener(_syncScroll);
  }

  void _syncScroll() {
    if (!_isUserScrolling) {
      _isUserScrolling = true;
      if (_matchesScrollController.hasClients &&
          _timelineScrollController.hasClients) {
        _timelineScrollController.jumpTo(_matchesScrollController.offset);
        _matchesScrollController.jumpTo(_timelineScrollController.offset);
      }
      _isUserScrolling = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(notifier.profileProvider);
    final notificationManager = ref.watch(
        notificationManagerProvider); // Sử dụng notificationManagerProvider

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
                    child: profileAsync != null // Kiểm tra null
                        ? CircleAvatar(
                            radius: 20,
                            backgroundImage: profileAsync.avatarUrl != null
                                ? NetworkImage(profileAsync.avatarUrl!)
                                : const AssetImage('assets/ava.png')
                                    as ImageProvider,
                          )
                        : const CircularProgressIndicator(), // Hiển thị khi dữ liệu đang tải hoặc bị lỗi
                  ),
                  const SizedBox(width: 12),
                  profileAsync != null // Kiểm tra null
                      ? Text(
                          profileAsync.fullName ??
                              'No Name', // Sử dụng giá trị mặc định nếu fullName là null
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const Spacer(),
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons
                            .notifications_outlined), // Biểu tượng thông báo
                        if (notificationManager.unreadCount >
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
                                '${notificationManager.unreadCount}', // Hiển thị số lượng thông báo chưa đọc
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
                      notificationManager.markAllAsRead();

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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/default_avatar.jpg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xin chào,',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const Text(
                  'Lê Thành',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClubStories() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // TODO: Replace with actual club stories
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue[100],
                  child: Icon(
                    Icons.sports_tennis,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Club ${index + 1}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline() {
    return SizedBox(
      width: 60,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 24,
        itemBuilder: (context, index) {
          return SizedBox(
            height: 60,
            child: Center(
              child: Text(
                '${index.toString().padLeft(2, '0')}:01',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget _buildMatchItem(Match match) {
  //   return GestureDetector(
  //     onTap: () => _navigateToMatchDetail(match),
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.1),
  //             spreadRadius: 1,
  //             blurRadius: 5,
  //             offset: const Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: Colors.blue.withOpacity(0.1),
  //               borderRadius:
  //                   const BorderRadius.vertical(top: Radius.circular(12)),
  //             ),
  //             child: Row(
  //               children: [
  //                 Text(
  //                   DateFormat('HH:mm').format(match.datetime),
  //                   style: const TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Expanded(
  //                   child: Text(
  //                     match.title,
  //                     style: const TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(12),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.location_on_outlined, size: 16),
  //                     const SizedBox(width: 4),
  //                     Expanded(child: Text(match.location)),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 8),
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.people_outline, size: 16),
  //                     const SizedBox(width: 4),
  //                     Text(
  //                       '${match.currentParticipants}/${match.maxPlayers} Xác nhận tham gia',
  //                     ),
  //                   ],
  //                 ),
  //                 if (match.clubName != null) ...[
  //                   const SizedBox(height: 8),
  //                   Row(
  //                     children: [
  //                       const Icon(Icons.sports_tennis, size: 16),
  //                       const SizedBox(width: 4),
  //                       Text(match.clubName!),
  //                     ],
  //                   ),
  //                 ],
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTournamentItem(Tournament tournament) {
    return GestureDetector(
      onTap: () => _navigateToTournamentDetail(tournament),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tournament.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(tournament.datetime),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16),
                      const SizedBox(width: 4),
                      Expanded(child: Text(tournament.location)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${tournament.currentParticipants}/${tournament.maxPlayers} Đăng ký',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMatchDetail(Match match) {
    // Navigator.push(
    //   context,
    // MaterialPageRoute(
    // builder: (context) => MatchDetailScreen(match: match),
    // ),
    // );
  }

  void _navigateToTournamentDetail(Tournament tournament) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => TournamentDetailScreen(tournament: tournament),
    //   ),
    // );
  }
}
