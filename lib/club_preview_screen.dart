import 'package:flutter/material.dart';

class ClubPreviewScreen extends StatelessWidget {
  final String clubName;
  final bool isPublic;

  const ClubPreviewScreen({
    Key? key,
    required this.clubName,
    required this.isPublic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Phần header màu vàng với nút thêm ảnh bìa
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt_outlined, color: Colors.blue, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    'Thêm ảnh bìa',
                    style: TextStyle(color: Colors.blue[700], fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Phần thông tin CLB màu trắng
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Avatar và tên CLB
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.sports_tennis, size: 50, color: Colors.green[100]),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.camera_alt, size: 20, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    clubName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${isPublic ? "Công khai" : "Riêng tư"} • Pickleball • Tất cả trình độ',
                    style: TextStyle(color: Colors.grey[600]),
                  ),

                  // Tab bar
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTabItem(Icons.group_outlined, 'Thành viên'),
                      _buildTabItem(Icons.calendar_today_outlined, 'Hoạt động'),
                      _buildTabItem(Icons.photo_library_outlined, 'Thư viện'),
                      _buildTabItem(Icons.chat_bubble_outline, 'Thảo luận'),
                    ],
                  ),

                  // Card section
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Càng đông càng vui',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Chơi thể thao mà thiếu bạn bè thì thật chán',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Chia sẻ CLB',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}