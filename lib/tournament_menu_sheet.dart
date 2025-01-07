import 'package:flutter/material.dart';

class TournamentMenuSheet extends StatelessWidget {
  const TournamentMenuSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Giải Pickleball của Lê Tâm',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu items
          _buildMenuItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'DUPR',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            title: 'Quản lý',
          ),
          _buildMenuItem(
            icon: const Icon(Icons.share_outlined),
            title: 'Chia sẻ giải đấu',
          ),
          _buildMenuItem(
            icon: const Icon(Icons.help_outline),
            title: 'Yêu cầu hỗ trợ',
          ),
          _buildMenuItem(
            icon: const Icon(Icons.edit_outlined),
            title: 'Sửa thông tin giải đấu',
          ),
          _buildMenuItem(
            icon: const Icon(Icons.sports_tennis_outlined),
            title: 'Sửa thể thức',
          ),
          _buildMenuItem(
            icon: const Icon(Icons.campaign_outlined),
            title: 'Công bố giải',
          ),
          _buildMenuItem(
            icon: Icon(Icons.delete_outline, color: Colors.red[700]),
            title: 'Xóa giải đấu',
            titleColor: Colors.red[700],
          ),
          const SizedBox(height: 16), // Bottom padding
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required Widget icon,
    required String title,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 32, child: icon),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: titleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
