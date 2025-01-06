import 'package:flutter/material.dart';

class PublicMatchForm extends StatefulWidget {
  const PublicMatchForm({Key? key}) : super(key: key);

  @override
  State<PublicMatchForm> createState() => _PublicMatchFormState();
}

class _PublicMatchFormState extends State<PublicMatchForm> {
  final TextEditingController _matchNameController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String selectedSport = 'Pickleball';
  String selectedMatchType = 'Giao hữu';
  int playerCount = 12;
  bool isDupr = false;
  bool allowInvites = true;
  bool sendNotifications = true;
  bool duyetTuDong = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('TẠO KÈO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSportsSection(),
          const SizedBox(height: 24),
          _buildMatchDetailsSection(),
          const SizedBox(height: 24),
          _buildPlayerSettingsSection(),
          const SizedBox(height: 24),
          _buildDuprSection(),
          const SizedBox(height: 24),
          _buildLevelSection(),
          const SizedBox(height: 24),
          _buildMatchNameSection(),
          const SizedBox(height: 24),
          _buildAdvancedSettings(),
          const SizedBox(height: 24),
          _buildInviteSection(),
          const SizedBox(height: 32),
          _buildCreateButton(),
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
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSportOption('Aussie Footy', Icons.sports_football),
            _buildSportOption('Bóng chuyền', Icons.sports_volleyball),
            _buildSportOption('Pickleball', Icons.sports_tennis,
                isSelected: true),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMatchTypeChip('Giao hữu', isSelected: true),
              _buildMatchTypeChip('Đánh vòng tròn'),
              _buildMatchTypeChip('Đánh đơn'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.people, color: Colors.grey),
          title: const Text('Số người chơi'),
          trailing: Container(
            width: 100, // Giới hạn chiều rộng cố định
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Căn phải
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (playerCount > 1) {
                      setState(() {
                        playerCount--;
                      });
                    }
                  },
                  child: const Icon(Icons.remove_circle_outline, size: 22),
                ),
                Container(
                  width: 30, // Chiều rộng cố định cho số
                  alignment: Alignment.center,
                  child: Text(
                    '$playerCount',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      playerCount++;
                    });
                  },
                  child: const Icon(Icons.add_circle_outline, size: 22),
                ),
              ],
            ),
          ),
        ),
        _buildSettingItem(
          icon: Icons.lock_outline,
          title: 'Bảo mật',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Công khai'),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
        _buildSettingItem(
          icon: Icons.attach_money,
          title: 'Phí tham gia kèo',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Không có'),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatchDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'KÈO',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.calendar_today),
          title: const Text('Chọn ngày và giờ'),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.timer),
          title: const Text('1 tiếng'),
          onTap: () {},
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.location_on),
          title: const Text('Chọn địa điểm'),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Tạo kèo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSportOption(String name, IconData icon,
      {bool isSelected = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchTypeChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            // Handle selection
          });
        },
      ),
    );
  }

  Widget _buildSection(String title, {required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ...children,
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: SizedBox(
        width: 100, // Giới hạn chiều rộng của trailing widget
        child: trailing,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDuprSection() {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Vận đấu sẽ được gửi đến DUPR'),
      value: isDupr,
      onChanged: (bool value) {
        setState(() {
          isDupr = value;
        });
      },
    );
  }

  Widget _buildLevelSection() {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.speed,
          title: 'Trình độ tối thiểu',
          trailing: const Text('Không có >'),
          onTap: () {},
        ),
        _buildSettingItem(
          icon: Icons.speed,
          title: 'Trình độ tối đa',
          trailing: const Text('Không có >'),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMatchNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TÊN KÈO',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _matchNameController,
          decoration: const InputDecoration(
            hintText: 'Pickleball Giao hữu với Lê',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Thêm ghi chú',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cài đặt nâng cao',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildSettingItem(
          icon: Icons.person,
          title: 'Giới tính',
          trailing: const Text('Không giới hạn >'),
          onTap: () {},
        ),
        _buildSettingItem(
          icon: Icons.calendar_today,
          title: 'Độ tuổi',
          trailing: const Text('Không giới hạn >'),
          onTap: () {},
        ),
        _buildSettingItem(
          icon: Icons.refresh,
          title: 'Lặp lại',
          trailing: const Text('Không có >'),
          onTap: () {},
        ),
        _buildSettingItem(
          icon: Icons.person_outline,
          title: 'Vai trò',
          trailing: const Text('Tổ chức và tham gia >'),
          onTap: () {},
        ),
        _buildSettingItem(
          icon: Icons.block,
          title: 'Chặn rời kèo',
          trailing: const Text('Không có >'),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildInviteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mời bạn bè',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w500,
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Duyệt tự động'),
          value: duyetTuDong,
          onChanged: (bool value) {
            setState(() {
              duyetTuDong = value;
            });
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Cho phép người tham gia thêm bạn'),
          value: allowInvites,
          onChanged: (bool value) {
            setState(() {
              allowInvites = value;
            });
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Gửi thông báo'),
          value: sendNotifications,
          onChanged: (bool value) {
            setState(() {
              sendNotifications = value;
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _matchNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
