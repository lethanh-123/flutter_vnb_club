import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dupr_login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dupr_client.dart';
import 'dupr_login_screen.dart';
import 'pickleball_profile_screen.dart';
import 'providers.dart' as app_provider;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Map<String, dynamic>? duprRatings;
  bool isDuprLoggedIn = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkDuprLogin();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/welcome');
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.green,
                        child: Text(
                          'LT',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'User Admin',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '@le-tam-533',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person_outline),
                        label: const Text('Thêm giới tính và độ tuổi'),
                      ),
                      const Text(
                        'Nói đôi điều về bạn',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Sports section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'THỂ THAO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Thêm'),
                      ),
                    ],
                  ),
                ),
                _buildSportItem(
                  'Cầu lông',
                  '🏸',
                  'Trung bình',
                  null,
                ),
                _buildSportItem(
                  'Pickleball',
                  '🏓',
                  '2.75',
                  null,
                  duprRating: _formatDuprRatings(duprRatings),
                  onDuprTap: _navigateToDupr,
                ),
                _buildSportItem(
                  'Quần vợt',
                  '🎾',
                  'Trung bình',
                  null,
                ),

                // Communities section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CỘNG ĐỒNG',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Thêm'),
                      ),
                    ],
                  ),
                ),

                // Community item
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.blue),
                  title: const Text('Ho Chi Minh City\nMetropolitan Vietnam'),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text('hoạt động'),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSportItem(
    String name,
    String icon,
    String level,
    String? position, {
    String? duprRating,
    String? lobbing,
    VoidCallback? onDuprTap,
  }) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (position != null) ...[
            const Text(
              'TRÌNH (TỰ ĐÁNH GIÁ)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(level),
            const Text(
              'VỊ TRÍ',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(position),
          ] else
            Text(level),
          if (duprRating != null)
            GestureDetector(
              onTap: onDuprTap,
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'DUPR $duprRating',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          if (lobbing != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Lobbing $lobbing',
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
    );
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
