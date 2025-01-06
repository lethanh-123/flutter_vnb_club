import 'package:flutter/material.dart';

class TournamentFormatScreen extends StatefulWidget {
  const TournamentFormatScreen({Key? key}) : super(key: key);

  @override
  State<TournamentFormatScreen> createState() => _TournamentFormatScreenState();
}

class _TournamentFormatScreenState extends State<TournamentFormatScreen> {
  String selectedFormat = 'Vòng tròn';
  int selectedRounds = 1;
  String selectedRanking = 'Thắng - Thua';
  int winPoints = 2;
  Map<String, int> scores = {
    'Thắng': 3,
    'Thua': 0,
    'Thắng gỡ hòa': 3,
    'Thua gỡ hòa': 1,
    'Hòa': 1,
  };
  final TextEditingController _rulesController = TextEditingController();
  final List<TextEditingController> _teamControllers = [];
  int totalMatches = 28;
  int totalTeams = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('THÊM THỂ THỨC THI ĐẤU'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Bỏ qua'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFormatSection(),
          const SizedBox(height: 24),
          _buildDetailsSection(),
          const SizedBox(height: 24),
          _buildRankingSection(),
          const SizedBox(height: 24),
          _buildTiebreakSection(),
          const SizedBox(height: 24),
          _buildRulesSection(),
          const SizedBox(height: 24),
          _buildTeamsSection(),
          const SizedBox(height: 24),
          _buildSummarySection(),
          const SizedBox(height: 24),
          _buildPreviewButton(),
        ],
      ),
    );
  }

  Widget _buildTiebreakSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ƯU TIÊN GỠ HÒA',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        _buildTiebreakItem('Hiệp gỡ hòa 1', 'H2H Thắng'),
        _buildTiebreakItem('Hiệp gỡ hòa 2', 'Hiệu số'),
        _buildTiebreakItem('Hiệp gỡ hòa 3', 'H2H Hiệu số'),
        _buildTiebreakItem('Hiệp gỡ hòa 4', 'Không có'),
      ],
    );
  }

  Widget _buildRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'LUẬT CHƠI',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _rulesController,
          decoration: const InputDecoration(
            hintText:
                'Ví dụ: Đội/người chơi sẽ bị xử bỏ cuộc nếu không có mặt 10 phút trước khi trận đấu bắt đầu.',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTeamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HIỆP ĐẤU',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(2, (index) => _buildTeamInput(index)),
        TextButton(
          onPressed: () {
            setState(() {
              _teamControllers.add(TextEditingController());
            });
          },
          child: const Text('Thêm hiệp đấu'),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TỔNG',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SỐ TRẬN',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '$totalMatches',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ĐỘI',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '$totalTeams',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Xem trước',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOption(String name, IconData icon,
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
            size: 24,
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

  Widget _buildRoundOption(String text, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildPointsRow(String title, int value) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            setState(() {
              if (value > 0) value--;
            });
          },
        ),
        Text('$value'),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            setState(() {
              value++;
            });
          },
        ),
      ],
    );
  }

  Widget _buildScoreRow(String title, int value) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            setState(() {
              if (scores[title]! > 0) {
                scores[title] = scores[title]! - 1;
              }
            });
          },
        ),
        Text('${scores[title]}'),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            setState(() {
              scores[title] = scores[title]! + 1;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTiebreakItem(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value),
          const SizedBox(width: 4),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildTeamInput(int index) {
    if (_teamControllers.length <= index) {
      _teamControllers.add(TextEditingController());
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _teamControllers[index],
              decoration: const InputDecoration(
                hintText: 'Tên hiệp đấu',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                _teamControllers[index].dispose();
                _teamControllers.removeAt(index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFormatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildFormatOption('Hỗn hợp', Icons.shuffle, isSelected: false),
            const SizedBox(width: 12),
            _buildFormatOption('Loại trực tiếp', Icons.trending_up,
                isSelected: false),
            const SizedBox(width: 12),
            _buildFormatOption('Vòng tròn', Icons.loop, isSelected: true),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildRoundOption('1 lượt', isSelected: true),
            const SizedBox(width: 12),
            _buildRoundOption('2 lượt'),
            const SizedBox(width: 12),
            _buildRoundOption('3 lượt'),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Mỗi đội sẽ đấu với các đội còn lại 1 lần.',
          style: TextStyle(color: Colors.grey),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Tìm hiểu thêm về các thể thức thi đấu'),
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
        const SizedBox(height: 16),
        _buildPointsRow('Điểm khi đối thủ bỏ cuộc', winPoints),
        const SizedBox(height: 8),
        const Text(
          'Điểm cộng cho đội chơi nếu đối thủ bỏ cuộc',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildPreviewButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Navigate to preview screen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Xem trước',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRankingOption(String text, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRanking = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildRankingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CÁCH TÍNH XẾP HẠNG',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildRankingOption('Thắng - Thua', isSelected: true),
            const SizedBox(width: 12),
            _buildRankingOption('Win %'),
            const SizedBox(width: 12),
            _buildRankingOption('Games Win %'),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Điểm được tính theo số bàn thắng, thua, hoặc hòa.',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ...scores.entries
            .map((entry) => _buildScoreRow(entry.key, entry.value)),
      ],
    );
  }

  // ... Các widget build khác

  @override
  void dispose() {
    _rulesController.dispose();
    for (var controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
