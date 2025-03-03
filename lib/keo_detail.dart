import 'package:flutter/material.dart';

class MatchDetailsPage extends StatelessWidget {
  final Map<String, dynamic> matchInfo;

  const MatchDetailsPage({Key? key, required this.matchInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin kèo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              matchInfo['title'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
                'Ngày và giờ', '${matchInfo['date']} ${matchInfo['time']}'),
            _buildDetailRow('Địa điểm', matchInfo['location']),
            _buildDetailRow('Số người chơi', '${matchInfo['maxParticipants']}'),
            _buildDetailRow('Ghi chú', matchInfo['notes'].join('\n')),
            const SizedBox(height: 24),
            const Text(
              'Thông tin chi tiết',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Trình độ', matchInfo['level']),
            _buildDetailRow('Phí tham gia', matchInfo['price']),
            _buildDetailRow('Địa chỉ đầy đủ', matchInfo['fullAddress']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
