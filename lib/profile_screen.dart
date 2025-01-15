import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dupr_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dupr_client.dart';
import 'dupr_login_screen.dart';
import 'pickleball_profile_screen.dart';
import 'providers.dart' as app_provider;
import 'profile.dart';
import 'api_service.dart';
import 'settings_screen.dart';

final profileProvider = FutureProvider<Profile>((ref) async {
  try {
    final apiService = ApiService();
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt('userId');
    print('Loading profile for userId: $userId'); // Debug log

    if (userId == null) {
      throw Exception('Vui lòng đăng nhập lại');
    }

    final profile = await apiService.getProfile(userId);
    print('Loaded profile: ${profile.fullName}'); // Debug log
    return profile;
  } catch (e) {
    print('Profile provider error: $e'); // Debug log
    throw e;
  }
});

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
// Trong ProfileScreen khi cập nhật profile

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Map<String, dynamic>? duprRatings;
  bool isDuprLoggedIn = false;
  Future<Profile>? _profileFuture;
  final _apiService = ApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkDuprLogin();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      print('Loaded userId: $userId'); // Debug log

      if (userId == null) {
        throw Exception('UserId không tồn tại');
      }

      if (!mounted) return;

      // Gọi API và cập nhật state
      setState(() {
        _profileFuture = _apiService.getProfile(userId);
      });

      // Debug log kết quả
      _profileFuture?.then((profile) {
        print('Profile loaded successfully: ${profile.fullName}');
      }).catchError((error) {
        print('Error loading profile: $error');
      });
    } catch (e) {
      print('Error in _loadProfile: $e'); // Debug log
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkDuprLogin() async {
    final isLoggedIn = ref.read(app_provider.isLoggedInProvider);
    setState(() {
      isDuprLoggedIn = isLoggedIn;
    });
  }

  Future<void> _navigateToDupr() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (isDuprLoggedIn) {
        final client = ref.read(app_provider.duprClientProvider);
        final prefs = ref.read(app_provider.sharedPreferencesProvider);

        if (prefs == null) {
          throw Exception('SharedPreferences chưa được khởi tạo');
        }

        final userId = prefs.getString('userId');
        final token = prefs.getString('token');

        if (userId == null || token == null) {
          throw Exception('Không tìm thấy thông tin đăng nhập');
        }

        final playerResponse = await client.getPlayerRatings(userId, token);

        if (mounted && playerResponse != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PickleballProfileScreen(
                playerData: playerResponse,
                onBackPressed: (ratings) {
                  setState(() {
                    duprRatings = ratings;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          );
        }
      } else {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DuprLoginScreen(),
          ),
        );

        if (result != null) {
          setState(() {
            duprRatings = result;
            isDuprLoggedIn = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDuprRatings(Map<String, dynamic>? ratings) {
    if (ratings == null) return 'NR';

    final singles = ratings['singles'];
    final doubles = ratings['doubles'];
    final confidence = ratings['confidence'];

    List<String> ratingParts = [];

    if (singles != null && singles != 'NR') {
      ratingParts.add('S:$singles');
    }

    if (doubles != null && doubles != 'NR') {
      ratingParts.add('D:$doubles');
    }

    if (ratingParts.isEmpty) return 'NR';

    String result = ratingParts.join(' ');
    if (confidence != null) {
      result += ' (${confidence.round()}%)';
    }

    return result;
  }

  Future<void> _refreshProfile() async {
    await _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Hồ sơ'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // TODO: Show help/about
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Lỗi: $error'),
        ),
        data: (profile) => RefreshIndicator(
          onRefresh: () => ref.refresh(profileProvider.future),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildProfileHeader(profile),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSportsSection(profile),
                      const SizedBox(height: 16),
                      _buildCommunitiesSection(profile),
                      const SizedBox(height: 16),
                      _buildAchievementsSection(profile),
                      const SizedBox(height: 16),
                      _buildStatsSection(profile),
                      const SizedBox(height: 16),
                      _buildPersonalInfoSection(profile),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Profile profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            backgroundImage: profile.avatarUrl != null
                ? NetworkImage(profile.avatarUrl!)
                : null,
            child: profile.avatarUrl == null
                ? Text(
                    profile.fullName?.substring(0, 2).toUpperCase() ?? 'NA',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            profile.fullName ?? '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '@${profile.username}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          if (profile.bio != null && profile.bio!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                profile.bio!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSportsSection(Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Môn thể thao',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              if (profile.stats?['pickleball'] != null)
                _buildSportItem(
                  'Pickleball',
                  '🏓',
                  'Trình độ: ${profile.stats?['pickleball']['highest_rating'] ?? 'N/A'}',
                  isPrimary: profile.primarySportId == 1,
                ),
              if (profile.stats?['tennis'] != null)
                _buildSportItem(
                  'Tennis',
                  '🎾',
                  'Trình độ: Khá',
                  isPrimary: profile.primarySportId == 2,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection(Profile profile) {
    final achievements = profile.achievements;
    if (achievements == null || achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thành tích',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: achievements.entries.map((entry) {
                final sport = entry.key;
                final data = entry.value as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sport.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    ...data.entries.map((stat) => Text(
                          '${stat.key}: ${stat.value}',
                          style: TextStyle(color: Colors.grey[600]),
                        )),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(Profile profile) {
    final stats = profile.stats;
    if (stats == null || stats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thống kê',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: stats.entries.map((entry) {
                final sport = entry.key;
                final data = entry.value as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sport.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    ...data.entries.map((stat) => Text(
                          '${stat.key}: ${stat.value}',
                          style: TextStyle(color: Colors.grey[600]),
                        )),
                    const SizedBox(height: 8),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              _buildInfoTile(
                icon: Icons.person_outline,
                label: 'Giới tính',
                value: profile.gender ?? 'Chưa cập nhật',
              ),
              _buildInfoTile(
                icon: Icons.calendar_today,
                label: 'Độ tuổi',
                value: profile.ageGroup ?? 'Chưa cập nhật',
              ),
              _buildInfoTile(
                icon: Icons.access_time,
                label: 'Ngày tham gia',
                value: _formatDate(profile.createdAt),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportItem(
    String name,
    String icon,
    String level, {
    bool isPrimary = false,
  }) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 24)),
      title: Row(
        children: [
          Text(name),
          if (isPrimary)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.star, color: Colors.amber, size: 20),
            ),
        ],
      ),
      subtitle: Text(level),
    );
  }

  Widget _buildCommunitiesSection(Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cộng đồng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: FutureBuilder<List<String>>(
            future: _loadCommunityNames(profile.preferredCommunities),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Lỗi: ${snapshot.error}');
              }

              final communities = snapshot.data ?? [];
              return Column(
                children: communities
                    .map((name) => ListTile(
                          leading: const Icon(Icons.group),
                          title: Text(name),
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<List<String>> _loadCommunityNames(List<int> communityIds) async {
    // TODO: Implement API call to get community names by IDs
    // Temporary mock data
    return ['Hồ Chí Minh', 'Hà Nội'];
  }

  // Helper function để lấy data từ DUPR API
  Future<Map<String, dynamic>> getDuprPlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final token = prefs.getString('token');

    if (userId == null || token == null) {
      throw Exception('Không tìm thấy thông tin đăng nhập');
    }

    final client = ref.read(
        app_provider.duprClientProvider); // Sử dụng provider để lấy DuprClient
    try {
      final response = await client.getPlayerRatings(userId, token);
      if (response == null) {
        throw Exception('Không nhận được dữ liệu từ server');
      }
      return response;
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin người chơi: ${e.toString()}');
    }
  }
}
