import 'package:flutter/material.dart';

class TournamentConfirmationScreen extends StatefulWidget {
  const TournamentConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<TournamentConfirmationScreen> createState() =>
      _TournamentConfirmationScreenState();
}

class _TournamentConfirmationScreenState
    extends State<TournamentConfirmationScreen> {
  bool isAcceptRules = false;
  bool isReadDetails = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('XÁC NHẬN'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Bạn đang chuẩn bị công bố giải đấu này. Khi giải đấu công bố, thông tin sẽ được thông báo đến cộng đồng thể thao Reclub.Vui lòng kiểm tra các thông tin dưới đây.',
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Rules section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'QUY ĐỊNH TỔ CHỨC GIẢI ĐẤU',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Radio<bool>(
                        value: true,
                        groupValue: isAcceptRules,
                        onChanged: (value) {
                          setState(() {
                            isAcceptRules = value!;
                          });
                        },
                      ),
                      const Text('Đồng ý'),
                    ],
                  ),
                  const Text(
                    'Vui lòng kiểm tra các quy định của chúng tôi khi tổ chức giải đấu trước khi công bố giải.',
                  ),
                  const SizedBox(height: 16),
                  _buildRuleItem(
                      'Bạn đồng ý tôn vinh tinh thần của giải đấu và thể hiện sự cảng bằng, tinh thần thể thao cao thượng đối với tất cả người chơi, ban tổ chức và nhân viên trong giải đấu.'),
                  _buildRuleItem(
                      'Bạn phải tuân thủ nghiêm ngặt các tiêu chuẩn sức khoẻ và an toàn cho đối tượng tham gia giải đấu.'),
                  _buildRuleItem(
                      'Bạn hoàn toàn chịu trách nhiệm về giải đấu bao gồm trả lương cho nhân viên, đóng thuế và đảm bảo giải đấu tuân thủ tất cả các quy luật định.'),
                  _buildRuleItem(
                      'Nếu không có sự đồng ý trước bằng văn bản, bạn không được khẳng định rằng giải đấu của bạn được tài trợ bởi, hay là một giải đấu chính thức của VNB_CLUB'),
                  _buildRuleItem(
                      'VNB_CLUB có quyền sử dụng và quảng bá giải đấu của bạn cho các mục đích kinh doanh.'),
                  _buildRuleItem(
                      'VNB_CLUB có thể nhưng không có nghĩa vụ quảng bá giải đấu của bạn trên mạng xã hội và tại các trang web chính thức'),
                  _buildRuleItem(
                      'Bạn đồng ý rằng VNB_CLUB và các tổ chức liên quan không có trách nhiệm liên đới đến giải đấu của bạn.'),
                  _buildRuleItem(
                      'Bạn đồng ý bồi thường, bảo vệ và đảm bảo sao cho VNB_CLUB, nhân viên, viên chức, người điều hành, tổ chức đại diện, người ký kết hợp đồng và các đại diện khác của chúng tôi không liên quan đến mọi khiếu nại, yêu cầu, hành động, tổn thất, trách nhiệm, pháp lý và chi phí (bao gồm cả phí luật sư) phát sinh từ giải đấu của bạn.'),
                  _buildRuleItem(
                      'VNB_CLUB có quyền đình chỉ giải đấu của bạn vì bất kỳ lý do nào có sự vi phạm những nguyên tắc kể trên cũng như vì sức khoẻ và sự an toàn của cộng đồng và những người tham gia.'),
                ],
              ),
            ),

            // Tournament details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'CHI TIẾT GIẢI ĐẤU',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Radio<bool>(
                    value: true,
                    groupValue: isReadDetails,
                    onChanged: (value) {
                      setState(() {
                        isReadDetails = value!;
                      });
                    },
                  ),
                  const Text('Đã đọc'),
                ],
              ),
            ),

            // Tournament info cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildInfoCard(
                    icon: Icons.attach_money,
                    title: 'Không có phí',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.group,
                    title: '8 đội',
                    subtitle: '2-5 người chơi mỗi đội',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.sports,
                    title: 'Vòng tròn',
                    actionText: 'Xem chi tiết',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.timeline,
                    title: 'Tất cả trình độ',
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: 'Không giới hạn người chơi',
                  ),
                ],
              ),
            ),

            // Location
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          '136 Bùi Văn Ba, Tân Thuận Đông, Quận 7, Hồ Chí Minh, Việt Nam',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('xem bản đồ'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Important dates
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.green),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Thời gian dự kiến bắt đầu giải'),
                            Text('Chủ Nhật 26/01 9:25 - 1 tuần'),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Sửa'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'THỜI GIAN QUAN TRỌNG',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTimelineItem('R', 'Mở đăng ký', 'Thứ Ba 07/01 7:00'),
                  const SizedBox(height: 8),
                  _buildTimelineItem(
                      'C', 'Hạn chót đăng ký', 'Chủ Nhật 26/01 9:25'),
                ],
              ),
            ),
            const SizedBox(height: 32), // Bottom padding
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: isAcceptRules && isReadDetails
              ? () {
                  // Quay về trang trước và gửi kèm trạng thái đã công bố
                  Navigator.pop(context, true);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            disabledBackgroundColor: Colors.grey[300],
          ),
          child: const Text(
            'CÔNG BỐ GIẢI',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    String? subtitle,
    String? actionText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey),
                  ),
              ],
            ),
          ),
          if (actionText != null)
            TextButton(
              onPressed: () {},
              child: Text(actionText),
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
}
