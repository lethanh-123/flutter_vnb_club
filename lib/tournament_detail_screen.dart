import 'package:flutter/material.dart';
import 'edit_trophy_screen.dart';
import 'tournament_confirmation_screen.dart';
import 'tournament_menu_sheet.dart';

class TournamentDetailScreen extends StatefulWidget {
  const TournamentDetailScreen({Key? key}) : super(key: key);

  @override
  State<TournamentDetailScreen> createState() => _TournamentDetailScreenState();
}

class _TournamentDetailScreenState extends State<TournamentDetailScreen> {
  int _currentTabIndex = 0;
  bool _isPublished = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bán nhập'),
            Text(
              'GIẢI PICKLEBALL CỦA LÊ TÂM',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const TournamentMenuSheet(),
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: 'Chi tiết'),
                Tab(text: 'Danh sách'),
                Tab(text: 'Trận đấu'),
                Tab(text: 'Kết quả'),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              onTap: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
              },
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDetailsTab(),
                  _buildListTab(),
                  _buildMatchesTab(),
                  _buildResultsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _currentTabIndex == 0 // Chỉ hiển thị ở tab Chi tiết
          ? !_isPublished
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Đã lưu bản nháp của giải đấu. Bạn có muốn công bố giải ngay bây giờ không?',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TournamentConfirmationScreen(),
                              ),
                            );
                            if (result == true) {
                              setState(() {
                                _isPublished = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'CÔNG BỐ GIẢI',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Mở đăng ký trong 1 ngày',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.blue),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'MỜI BẠN BÈ',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
          : null,
    );
  }

  // Thêm widget cho tab Danh sách
  Widget _buildListTab() {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildFilterChip('Ban Tổ Chức • 1', false),
              const SizedBox(width: 8),
              _buildFilterChip('Đội • 2', true),
              const SizedBox(width: 8),
              _buildFilterChip('Vđv Tự Do', false),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildStatusFilter('Xác nhận tham gia • 1', true),
              const SizedBox(width: 16),
              _buildStatusFilter('Chờ xác nhận • 1', false),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildTeamItem('xy'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Mời hoặc giữ chỗ cho đội.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Giữ chỗ'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Mời',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatusFilter(String label, bool isSelected) {
    return Text(
      label,
      style: TextStyle(
        color: isSelected ? Colors.blue : Colors.grey,
        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
      ),
    );
  }

  Widget _buildTeamItem(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.sports_handball, color: Colors.grey),
        ),
        title: Text(name),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildMatchesTab() {
    return SingleChildScrollView(
      // Wrap bằng SingleChildScrollView
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle buttons Thể thức/Danh sách
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildToggleButton('Thể thức', true),
                const SizedBox(width: 12),
                _buildToggleButton('Danh sách', false),
              ],
            ),
          ),

          // Switch Công khai bảng đấu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Công khai bảng đấu',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {},
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ),

          // Tournament format card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Image.asset('assets/round_robin.png', width: 40),
                    title: const Text('Vòng tròn'),
                    subtitle: const Text(
                      'Vòng tròn: Mỗi đội sẽ đấu với các đội còn lại. Xếp hạng dựa trên kết quả thi đấu của tất cả các trận. Không có vòng loại trực tiếp.',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Thay đổi thể thức',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Stats grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GIÁ TRỊ ĐIỂM',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FixedColumnWidth(60),
                    2: IntrinsicColumnWidth(),
                    3: FixedColumnWidth(60),
                  },
                  children: const [
                    TableRow(
                      children: [
                        Text('Thắng', style: TextStyle(fontSize: 16)),
                        Text(
                          '3',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text('Thua', style: TextStyle(fontSize: 16)),
                        Text(
                          '0',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        SizedBox(height: 12), // Spacing
                        SizedBox(height: 12),
                        SizedBox(height: 12),
                        SizedBox(height: 12),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Hoà', style: TextStyle(fontSize: 16)),
                        Text(
                          '1',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text('Thắng gỡ hoà', style: TextStyle(fontSize: 16)),
                        Text(
                          '3',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        SizedBox(height: 12), // Spacing
                        SizedBox(height: 12),
                        SizedBox(height: 12),
                        SizedBox(height: 12),
                      ],
                    ),
                    TableRow(
                      children: [
                        Text('Thua gỡ hoà', style: TextStyle(fontSize: 16)),
                        Text(
                          '3',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(''), // Empty cell
                        Text(''), // Empty cell
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Thêm padding bottom để tránh content bị che khuất
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    return Column(
      children: [
        // Toggle buttons Giải thưởng/Media
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildToggleButton_2(
                'Giải thưởng',
                true,
                icon: Icons.emoji_events,
                color: Colors.green,
              ),
            ],
          ),
        ),

        // Trophy section
        Container(
          color: Colors.grey[800],
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Top 1 trophy
              // Top 1 trophy
              _buildSmallTrophy('1', 'Thay đổi', isLarge: true),
              const SizedBox(height: 40),
              const SizedBox(height: 40),

              // Top 2 & 3 trophies
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSmallTrophy('2', 'Thay đổi'),
                  _buildSmallTrophy('3', 'Thay đổi'),
                ],
              ),
            ],
          ),
        ),

        // MVP section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.blue,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'mvp',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Thay đổi',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallTrophy(String number, String label,
      {bool isLarge = false}) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTrophyScreen(
              number: number,
              currentTitle: _trophyTitles[number] ?? '',
              currentDescription: _trophyDescriptions[number] ?? '',
            ),
          ),
        );

        if (result != null) {
          setState(() {
            _trophyTitles[number] = result['title'];
            _trophyDescriptions[number] = result['description'];
          });
        }
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: isLarge ? 120 : 80,
                color: Colors.amber[100],
              ),
              Positioned(
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: isLarge ? 40 : 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Text(
            _trophyTitles[number] ?? label,
            style: TextStyle(
              color: isLarge ? Colors.white : Colors.amber,
              fontSize: isLarge ? 16 : 14,
            ),
          ),
          if (_trophyDescriptions[number]?.isNotEmpty ?? false)
            Text(
              _trophyDescriptions[number]!,
              style: TextStyle(
                color: isLarge ? Colors.white70 : Colors.grey[400],
                fontSize: isLarge ? 14 : 12,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

// Thêm các biến để lưu trữ thông tin phần thưởng
  final Map<String, String> _trophyTitles = {};
  final Map<String, String> _trophyDescriptions = {};

  void _showEditTrophyDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa $title'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Nhập tên giải thưởng',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Cập nhật tên giải thưởng
              Navigator.pop(context);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton_2(
    String text,
    bool isSelected, {
    IconData? icon,
    Color? color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: isSelected ? Colors.white : Colors.black),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label,
      {bool isFullWidth = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: isFullWidth
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: isFullWidth ? TextAlign.left : TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildImageUpload(),
          _buildAnnouncementSection(),
          _buildInfoGrid(),
          _buildLocationSection(),
          _buildTimeSection(),
          _buildNotesSection(),
        ],
      ),
    );
  }

  Widget _buildImageUpload() {
    return Container(
      height: 200,
      color: Colors.blue[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 40, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            'Thêm ảnh bìa chính',
            style: TextStyle(color: Colors.blue[700]),
          ),
          const SizedBox(height: 4),
          Text(
            'Kích thước tiêu chuẩn: 350 x 200px',
            style: TextStyle(color: Colors.blue[700], fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 0 ? Colors.blue : Colors.blue[200],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cần thông tin đến người chơi?',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Đăng thông báo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              _buildInfoItem(
                icon: Icons.attach_money,
                title: 'Không có phí',
              ),
              _buildInfoItem(
                icon: Icons.group,
                title: '2-5 người chơi mỗi đội',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildInfoItem(
                icon: Icons.sports_tennis,
                title: 'Vòng tròn',
                subtitle: 'Xem chi tiết',
                showSubtitle: true,
              ),
              _buildInfoItem(
                icon: Icons.person,
                title: 'Không giới hạn người chơi',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    String? subtitle,
    bool showSubtitle = false,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13)),
                  if (showSubtitle && subtitle != null)
                    Text(
                      subtitle,
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

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('136 Bùi Văn Ba'),
                    Text(
                      '136 Bùi Văn Ba, Tân Thuận Đông, Quận 7, Hồ Chí Minh, Việt Nam',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: const Text('xem bản đồ'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thời gian dự kiến bắt đầu giải'),
                    Text(
                      'Chủ Nhật 26/01 9:25 - 1 tuần',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Sửa'),
              ),
            ],
          ),
          const Divider(),
          const Text(
            'THỜI GIAN QUAN TRỌNG',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineItem(
            'R',
            'Mở đăng ký',
            'Thứ Ba 07/01 7:00',
          ),
          _buildTimelineItem(
            'C',
            'Hạn chót đăng ký',
            'Chủ Nhật 26/01 9:25',
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String letter, String title, String time) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey[300],
          child: Text(letter),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(
              time,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
            child: const Text('Thêm ghi chú'),
          ),
        ],
      ),
    );
  }
}
