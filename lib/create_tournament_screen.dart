import 'package:flutter/material.dart';
import 'tournament_format_screen.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({Key? key}) : super(key: key);

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  String selectedSport = 'Pickleball';
  final TextEditingController _tournamentNameController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('TẠO GIẢI ĐẤU'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSportsSection(),
          const SizedBox(height: 24),
          _buildDetailsSection(),
          const SizedBox(height: 24),
          _buildRegistrationSection(),
          const SizedBox(height: 24),
          _buildLimitsSection(),
          const SizedBox(height: 24),
          _buildTournamentNameSection(),
          const SizedBox(height: 32),
          _buildContinueButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MÔN THỂ THAO',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSportOption('Aussie Footy', Icons.sports_football),
            const SizedBox(width: 12),
            _buildSportOption('Bóng chuyền', Icons.sports_volleyball),
            const SizedBox(width: 12),
            _buildSportOption('Pickleball', Icons.sports_tennis,
                isSelected: true),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CHI TIẾT',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildSettingItem(
          icon: Icons.location_on,
          title: 'Chọn địa điểm',
          showArrow: true,
        ),
        _buildSettingItem(
          icon: Icons.calendar_today,
          title: 'Thời gian dự kiến bắt đầu giải',
          subtitle:
              'Bạn có thể bắt đầu giải ngay khi có đủ người chơi hoặc đợi chờ.',
          showArrow: true,
        ),
      ],
    );
  }

  Widget _buildRegistrationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'THỜI GIAN ĐĂNG KÝ',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        _buildRegistrationItem('R', 'Mở đăng ký', 'T2 6 Tháng 17:00', 'sửa'),
        _buildRegistrationItem(
            'E', 'Hạn đăng ký sớm', '(không bắt buộc)', 'thêm'),
        _buildRegistrationItem('C', 'Hạn chót đăng ký', '', 'thêm'),
        _buildRegistrationItem('D', 'Thời lượng', '', 'thêm'),
      ],
    );
  }

  Widget _buildLimitsSection() {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.speed,
          title: 'Giới hạn trình độ',
          trailing: const Text('Không'),
          showArrow: true,
        ),
        _buildSettingItem(
          icon: Icons.people,
          title: 'Giới hạn người chơi',
          trailing: const Text('Không'),
          showArrow: true,
        ),
        _buildSettingItem(
          icon: Icons.group,
          title: 'Người tham gia',
          trailing: const Text('Tối đa 8 Đội'),
          subtitle: '2~5 người chơi mỗi đội',
          showArrow: true,
        ),
        _buildSettingItem(
          icon: Icons.attach_money,
          title: 'Phí giải đấu',
          trailing: const Text('Không'),
          showArrow: true,
        ),
        _buildSettingItem(
          icon: Icons.lock_outline,
          title: 'Bảo mật',
          trailing: const Text('Công khai'),
          showArrow: true,
        ),
      ],
    );
  }

  Widget _buildTournamentNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tên giải đấu',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _tournamentNameController,
          decoration: const InputDecoration(
            hintText: 'Giải Pickleball của Lê Tâm',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'LƯU Ý',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Thêm ghi chú',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildSportOption(String name, IconData icon,
      {bool isSelected = false}) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: isSelected ? Colors.white : Colors.black,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationItem(
    String letter,
    String title,
    String subtitle,
    String action,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey[300],
          child: Text(letter),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            action,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool showArrow = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing,
          if (showArrow) ...[
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    bool isEnabled = _locationSelected &&
        _startDateSelected &&
        _registrationDeadlineSelected;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TournamentFormatScreen(),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? Colors.grey[700] : Colors.grey[400],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Tiếp tục',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tournamentNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
