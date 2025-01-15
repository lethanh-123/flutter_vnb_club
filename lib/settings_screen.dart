import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_sreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Xóa tất cả session data
      await prefs.clear();

      if (!context.mounted) return;

      // Chuyển về trang login và xóa stack navigation
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi đăng xuất: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Cài đặt'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Grid các cài đặt chính
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              padding: const EdgeInsets.all(16),
              children: [
                _buildGridItem(
                  icon: Icons.person_outline,
                  label: 'Tài khoản',
                  onTap: () {
                    // TODO: Navigate to account settings
                  },
                ),
                _buildGridItem(
                  icon: Icons.language,
                  label: 'Ngôn ngữ',
                  subtitle: 'Tiếng Việt',
                  onTap: () {
                    // TODO: Navigate to language settings
                  },
                ),
                _buildGridItem(
                  icon: Icons.notifications_none,
                  label: 'Thông báo',
                  onTap: () {
                    // TODO: Navigate to notification settings
                  },
                ),
              ],
            ),

            // Danh sách các cài đặt khác
            _buildListItem(
              icon: Icons.payment,
              label: 'Cách thanh toán',
              trailing: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.wallet, color: Colors.blue, size: 20),
              ),
            ),
            _buildListItem(
              icon: Icons.calendar_today,
              label: 'Lịch',
            ),
            _buildListItem(
              icon: Icons.block,
              label: 'Danh sách chặn',
            ),
            _buildListItem(
              icon: Icons.thumb_up_outlined,
              label: 'Đánh giá của tôi',
            ),
            _buildListItem(
              icon: Icons.help_outline,
              label: 'Trợ giúp',
            ),

            // Nút đăng xuất
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),

            // Phiên bản app
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Phiên bản: 1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem({
    required IconData icon,
    required String label,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
