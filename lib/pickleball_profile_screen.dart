import 'package:flutter/material.dart';
import 'skill_level_dialog.dart';

class PickleballProfileScreen extends StatefulWidget {
  final Map<String, dynamic> playerData;
  final Function(Map<String, dynamic>) onBackPressed;

  const PickleballProfileScreen({
    Key? key,
    required this.playerData,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  State<PickleballProfileScreen> createState() =>
      _PickleballProfileScreenState();
}

class _PickleballProfileScreenState extends State<PickleballProfileScreen> {
  late String selfRating;

  @override
  void initState() {
    super.initState();
    selfRating = '2.75'; // Giá trị mặc định
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.playerData['result'];
    final ratings = result['ratings'];
    print('ratings ${ratings['singles']}');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Trả về ratings khi ấn nút back
            widget.onBackPressed({
              'singles': ratings['singles'],
              'doubles': ratings['doubles'],
              'confidence': ratings['doublesConfidence'],
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CD080),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.sports_tennis,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pickleball',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    // result['fullName'] ??
                    'User Admin', // Lấy tên từ response
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    result['shortAddress'] ?? '', // Lấy địa chỉ từ response
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Stats section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('TRẬN ĐẤU', '16'),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  _buildStatItem('HOẠT ĐỘNG', '5'),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                  _buildStatItem('GIẢI THƯỞNG', '0'),
                ],
              ),
            ),

            // Navigation tabs
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  _buildTab('Profile', true),
                  _buildTab('Trận đấu', false),
                  _buildTab('Huấn luyện', false, icon: Icons.sports),
                ],
              ),
            ),

            // Ratings section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRatingCard(
                    'DUPR',
                    ratings['singles'] ?? 'NR',
                    'Đánh đơn',
                  ),
                  _buildRatingCard(
                    'DUPR',
                    ratings['doubles'] ?? 'NR',
                    'Đánh đôi',
                    confidence: null,
                  ),
                  _buildRatingCard(
                    'TRÌNH (TỰ\nĐÁNH GIÁ)',
                    selfRating, // Sử dụng selfRating ở đây
                    '',
                    showChangeButton: true,
                    onRatingChanged: (newRating) {
                      // Thêm callback
                      setState(() {
                        selfRating = newRating;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Additional Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DUPR ID: ${result['duprId']}'),
                  Text('Tuổi: ${result['age']}'),
                  Text('Giới tính: ${_formatGender(result['gender'])}'),
                  Text(
                      'Email đã xác thực: ${result['verifiedEmail'] ? 'Có' : 'Không'}'),
                  Text('Trạng thái: ${_formatStatus(result['status'])}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatGender(String? gender) {
    switch (gender) {
      case 'MALE':
        return 'Nam';
      case 'FEMALE':
        return 'Nữ';
      default:
        return 'Không xác định';
    }
  }

  String _formatStatus(String? status) {
    switch (status) {
      case 'ACTIVE':
        return 'Đang hoạt động';
      default:
        return status ?? 'Không xác định';
    }
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String text, bool isActive, {IconData? icon}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isActive ? Colors.blue : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 16, color: Colors.grey[600]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingCard(
    String title,
    String rating,
    String subtitle, {
    String? confidence,
    bool showChangeButton = false,
    Function(String)? onRatingChanged, // Thêm callback parameter
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title == 'DUPR')
                Image.asset(
                  'assets/dupr.jpg',
                  height: 24,
                )
              else
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                rating, // Hiển thị rating hiện tại
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (confidence != null)
                Text(
                  confidence,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              if (showChangeButton)
                TextButton(
                  onPressed: () async {
                    final result = await showDialog<String>(
                      context: context,
                      builder: (context) => SkillLevelDialog(
                        currentLevel: rating, // Truyền rating hiện tại
                      ),
                    );

                    if (result != null && onRatingChanged != null) {
                      onRatingChanged(result); // Gọi callback khi có thay đổi
                      print('Đã cập nhật level mới: $result');
                    }
                  },
                  child: const Text(
                    'Thay đổi',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
