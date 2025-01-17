import 'package:flutter/material.dart';
import 'match_detail_screen.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Thống kê',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Cập nhật hàng ngày',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Categories row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Thêm dòng này
              children: [
                _buildCategoryCard(
                  icon: Icons.sports_tennis,
                  label: 'Trận đấu',
                  isSelected: true,
                ),
                _buildCategoryCard(
                  icon: null,
                  label: 'Xếp hạng',
                  isDuprOnly: true,
                ),
                _buildCategoryCard(
                  icon: Icons.military_tech,
                  label: 'Độ uy tín',
                ),
              ],
            ),
          ),

          // Match history
          Expanded(
            child: ListView(
              children: [
                _buildMatchHistoryItem(
                  context,
                  date: '23/11',
                  clubLogo: 'assets/pic.png',
                  title:
                      'Round Robin [DUPR Lv 2.75-3.5] Pick Hub Mix POOC (sân 9-10)',
                  participants: '9 người chơi • 8 trận đấu đã chơi',
                  progress: 0.75,
                  duration: '6 Tháng',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData? icon,
    required String label,
    bool isSelected = false,
    bool duprBadge = false,
    bool isDuprOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Colors.blue : Colors.white,
        elevation: isSelected ? 0 : 1,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDuprOnly)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'DUPR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (icon != null)
                        Icon(
                          icon,
                          color: isSelected ? Colors.white : Colors.black,
                          size: 24,
                        ),
                      if (duprBadge)
                        Positioned(
                          right: -8,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'DUPR',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchHistoryItem(
    BuildContext context, {
    required String date,
    required String clubLogo,
    required String title,
    required String participants,
    required double progress,
    required String duration,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MatchDetailScreen(
              time: "18:00",
              date: "Thứ bảy 23/11/2024",
              title:
                  "🏆 ROUND ROBIN [DUPR LV 2.75-3.5] PICK HUB MIX POOC (SÂN 9-10)",
              teamName: "Pooc @Pick Hub Social Club",
              teamLogo: "assets/pic.png",
              subtitle: "Liên hệ BTC",
              location: "PooC Cầu Lông & PickleBall",
              fullAddress:
                  "202B Đ. Hoàng Văn Thụ, Phường 9, Phú Nhuận, Hồ Chí Minh 700000, Việt Nam",
              level: "Đánh vòng tròn",
              price: "200.000 đ",
              notes: [
                "9 người - 2 sân - 2 tiếng - 8 trận/người",
                "🏆 Mọi người cần có tài khoản kết nối với DUPR để được duyệt.",
                "📍Vui lòng THANH TOÁN trước để xác nhận tham gia.",
                """📍Thông tin chuyển khoản (xin hãy gửi màn hình chuyển khoản vào phần Chat hoặc Meet hoặc tải lên phần Thanh Toán
- STK: 39796666668 - ACB Bank
- Tên: NGUYEN TAN TAI
- Nội dung: "tên Reclub + Round Robin PooC\"""",
                """Những bạn Hủy hoặc không tới không đúng theo quy qui định dưới đây sẽ không được tham gia trong nhiều round robin tiếp theo
Thời gian dời tối đa là 1h
Có bao gồm vợt và banh""",
                "🔥🔥🔥 voucher 500k ăn Hải sản lộc gà từ nhà hàng Cơ Linh Phú Mỹ Hưng.",
              ],
              maxParticipants: 9,
              currentParticipants: 9,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'DUPR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    participants,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  duration,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
