import 'package:flutter/material.dart';
import 'match_screen.dart';
import 'tournament_screen.dart';
import 'coach_screen.dart';
import 'club_detail_screen.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'club.dart';
import 'sport.dart';
// import '../config/api_config.dart';
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
  List<Club> _clubs = [];
  List<Sport> _sports = [];
  Sport? _selectedSport;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSports();
  }

  Future<void> _fetchSports() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/sports.php'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _sports = (data['data']['sports'] as List)
                .map((sport) => Sport.fromJson(sport))
                .toList();
            _tabController = TabController(length: _sports.length, vsync: this);
            _tabController.addListener(_handleTabSelection);
            _fetchClubs();
          });
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load sports');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedSport = _sports[_tabController.index];
        _fetchClubs();
      });
    }
  }

  Future<void> _fetchClubs() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      String url = '${ApiConfig.baseUrl}/clubs.php';
      if (_selectedSport != null) {
        url += '?sport_id=${_selectedSport!.id}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _clubs = (data['data']['clubs'] as List)
                .map((club) => Club.fromJson(club))
                .where((club) =>
                    _searchQuery.isEmpty ||
                    club.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                .toList();
            _isLoading = false;
          });
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load clubs');
      }
    } catch (e) {
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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _fetchClubs();
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm CLB...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Club List
          Expanded(
            child: _buildClubList(),
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
              onPressed: _fetchClubs,
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
      onRefresh: _fetchClubs,
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
                    : const AssetImage('assets/club_default.png')
                        as ImageProvider,
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
