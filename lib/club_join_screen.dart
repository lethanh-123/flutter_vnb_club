import 'package:flutter/material.dart';
import 'match_screen.dart';
import 'tournament_screen.dart';
import 'coach_screen.dart';
import 'club_detail_screen.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'club.dart';
import 'sport.dart';
import 'club_detail_screen.dart';
import 'api_service.dart';

class ClubJoinScreen extends StatefulWidget {
  const ClubJoinScreen({Key? key}) : super(key: key);

  @override
  State<ClubJoinScreen> createState() => _ClubJoinScreenState();
}

class _ClubJoinScreenState extends State<ClubJoinScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  List<Club> _clubs = [];
  List<Sport> _sports = [];
  Sport? _selectedSport;
  bool _isLoading = true;
  String? _error;
  int _selectedTab = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {});
    _loadClubs(); // Chỉ cần gọi _loadClubs
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTab = _tabController.index;
        _selectedSport = _sports[_tabController.index];
      });
      _loadClubs();
    }
  }

  Future<void> _loadClubs() async {
    if (!mounted) return; // Kiểm tra mounted trước khi thực hiện

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      if (!mounted) return; // Kiểm tra lại mounted sau delay

      final clubs = await ApiService.fetchClubs(
        sportId: _selectedSport?.id?.toString(),
        searchQuery: _searchQuery,
      );

      if (!mounted) return; // Kiểm tra lại mounted sau khi gọi API

      setState(() {
        _clubs = clubs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // Kiểm tra mounted trước khi setState trong catch

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tham gia CLB'),
        bottom: _sports.isEmpty
            ? null
            : TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: _sports
                    .map((sport) => Tab(
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/sports/${sport.icon ?? 'default.png'}',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(sport.name),
                            ],
                          ),
                        ))
                    .toList(),
              ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _loadClubs();
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm từ khoá...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
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
              // _buildTab('NGƯỜI CHƠI', Icons.person, 3),
              _buildTab('HLV', Icons.sports, 4),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab CLB
                Column(
                  children: [
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
                // Center(child: Text('Trang Người chơi')),
                const CoachScreen(),
              ],
            ),
          ),
        ],
      ),
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

  Widget _buildClubList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadClubs,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_clubs.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy CLB nào'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadClubs,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _clubs.length,
        itemBuilder: (context, index) {
          final club = _clubs[index];
          return _buildClubCard(club);
        },
      ),
    );
  }

  Widget _buildClubCard(Club club) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () =>
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ClubDetailScreen(
            //       clubId: club.id,
            //       clubName: club.name,
            //       clubLogo: club.logo ?? 'assets/club_default.png',
            //       coverImage: 'assets/club_cover.jpg',
            //       type: club.privacyType,
            //       sport: club.sport?.name ?? 'Unknown Sport',
            //       level: club.skillLevel?.level ?? 'All Levels',
            //       memberCount: club.memberCount,
            //       description: club.description ?? '',
            //     ),
            //   ),
            // )
            {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Club Logo
              CircleAvatar(
                radius: 30,
                backgroundImage: club.logo != null
                    ? NetworkImage(club.logo!)
                    : const AssetImage('assets/match.jpg') as ImageProvider,
              ),
              const SizedBox(width: 12),
              // Club Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            club.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          club.privacyType == 'public'
                              ? Icons.public
                              : Icons.lock,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      club.description ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16),
                        const SizedBox(width: 4),
                        Text('${club.memberCount} thành viên'),
                        const SizedBox(width: 12),
                        if (club.skillLevel != null) ...[
                          const Icon(Icons.sports, size: 16),
                          const SizedBox(width: 4),
                          Text(club.skillLevel!.level),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
