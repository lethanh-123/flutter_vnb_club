import 'package:flutter/material.dart';
import 'tournament_detail_screen.dart';

class TournamentFormatScreen extends StatefulWidget {
  const TournamentFormatScreen({Key? key}) : super(key: key);

  @override
  State<TournamentFormatScreen> createState() => _TournamentFormatScreenState();
}

class _TournamentFormatScreenState extends State<TournamentFormatScreen> {
  // String selectedFormat = 'Loại trực tiếp';
  String selectedRoundType = '1 lượt';
  bool hasThirdPlace = false;
  int defaultPoints = 2;
  int totalMatches = 7;
  int totalTeams = 8;
  int winPoints = 3;
  int losePoints = 0;
  int drawPoints = 1;
  int drawFirstPriorityPoints = 3;
  int drawSecondPriorityPoints = 1;
  String selectedScoringType = 'Thắng - Thua';
  // int defaultPoints = 2;

  // Thêm biến state cho tab Hỗn hợp
  String selectedFormat = 'Hỗn hợp';
  int roundRobinRounds = 1;
  int groupMatches = 2;
  int teamsAdvancing = 1;
  // bool hasThirdPlace = false;
  bool hasLuckyLoser = false;
  // String selectedScoringType = 'Thắng - Thua';
  Map<String, String> selectedPriorities = {
    'Hiệp gỡ hòa 1': 'H2H Thắng',
    'Hiệp gỡ hòa 2': 'Hiệu số',
    'Hiệp gỡ hòa 3': 'H2H Hiệu số',
    'Hiệp gỡ hòa 4': 'Không có',
  };
  // Danh sách các option có thể chọn
  final List<String> priorityOptions = [
    'Không có',
    'H2H Thắng',
    'Hiệu số',
    'H2H Hiệu số',
    'Tổng bàn thắng',
    'Hiệp đấu thắng',
    'Thắng %',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Thêm thể thức thi đấu'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bỏ qua'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildFormatSelection(),
            const SizedBox(height: 16),
            // Hiển thị nội dung tương ứng với format được chọn
            if (selectedFormat == 'Hỗn hợp')
              _buildMixedContent()
            else if (selectedFormat == 'Loại trực tiếp')
              _buildKnockoutContent()
            else if (selectedFormat == 'Vòng tròn')
              _buildRoundRobinContent(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Widget cho phần chọn thể thức
  Widget _buildFormatSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFormatOption('Hỗn hợp', Icons.shuffle,
            isSelected: selectedFormat == 'Hỗn hợp'),
        _buildFormatOption('Loại trực tiếp', Icons.trending_up,
            isSelected: selectedFormat == 'Loại trực tiếp'),
        _buildFormatOption('Vòng tròn', Icons.loop,
            isSelected: selectedFormat == 'Vòng tròn'),
      ],
    );
  }

  // Widget cho nội dung Hỗn hợp
  Widget _buildMixedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phần chọn số lượt
        _buildRoundSelection(),

        // VÒNG BẢNG
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            'VÒNG BẢNG',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Vòng bảng',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Số bảng và số đội
        _buildNumberRow('Số bảng đấu', groupMatches),
        _buildNumberRow('Số đội vào vòng trong', teamsAdvancing),

        // Cách tính xếp hạng
        _buildScoringSection(),

        // VÒNG LOẠI
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            'VÒNG LOẠI',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Vòng loại',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Tranh hạng 3 và Nhành thua
        _buildSwitchRow(
            'Tranh hạng 3',
            'Thêm trận tranh hạng 3 cho đội chơi thua vòng bán kết.',
            hasThirdPlace),
        _buildSwitchRow(
            'Nhành thua',
            'Thêm nhành thua cho những đội không được vào vòng đấu loại.',
            hasLuckyLoser),

        // CÀI ĐẶT KHÁC
        _buildOtherSettings(),
      ],
    );
  }

  Widget _buildScoringSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            'CÁCH TÍNH XẾP HẠNG',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Các nút chọn cách tính điểm
        Row(
          children: [
            _buildScoringOption('Thắng - Thua'),
            const SizedBox(width: 12),
            _buildScoringOption('Win %'),
            const SizedBox(width: 12),
            _buildScoringOption('Sets Win %'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Điểm được tính theo số bàn thắng, thua, hoặc hòa.',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),

        // GIÁ TRỊ ĐIỂM
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            'GIÁ TRỊ ĐIỂM',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Các dòng điểm
        _buildPointRow('Thắng', winPoints),
        _buildPointRow('Thua', losePoints),
        _buildPointRow('Thắng gỡ hòa', drawFirstPriorityPoints),
        _buildPointRow('Thua gỡ hòa', drawSecondPriorityPoints),
        _buildPointRow('Hòa', drawPoints),

        // ƯU TIÊN GỠ HÒA
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            'ƯU TIÊN GỠ HÒA',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Các hiệp gỡ hòa
        _buildDrawPriorityRow('Hiệp gỡ hòa 1', 'H2H Thắng'),
        _buildDrawPriorityRow('Hiệp gỡ hòa 2', 'Hiệu số'),
        _buildDrawPriorityRow('Hiệp gỡ hòa 3', 'H2H Hiệu số'),
        _buildDrawPriorityRow('Hiệp gỡ hòa 4', 'Không có'),
      ],
    );
  }

  Widget _buildScoringOption(String text) {
    bool isSelected = selectedScoringType == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedScoringType = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(color: isSelected ? Colors.green : Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // Helper widgets được dùng chung
  Widget _buildRoundSelection() {
     String getRoundText() {
    switch (roundRobinRounds) {
      case 1:
        return '1 lần';
      case 2:
        return '2 lần';
      case 3:
        return '3 lần';
      default:
        return '1 lần';
    }
  }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
          _buildRoundTypeOption('1 lượt',
              isSelected: roundRobinRounds == 1),
          const SizedBox(width: 12),
          _buildRoundTypeOption('2 lượt',
              isSelected: roundRobinRounds == 2),
          const SizedBox(width: 12),
          _buildRoundTypeOption('3 lượt',
              isSelected: roundRobinRounds == 3),
        ],
        ),
        const SizedBox(height: 8),
      Text(
        'Mỗi đội sẽ đấu với các đội còn lại ${getRoundText()} trong vòng bảng, trước khi đi tiếp vào vòng loại.',
        style: TextStyle(color: Colors.grey[600]),
      ),
      TextButton(
        onPressed: () {},
        child: const Text(
          'Tìm hiểu thêm về các thể thức thi đấu',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    ],
    );
  }

  Widget _buildNumberRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  if (value > 1) {
                    setState(() {
                      if (label == 'Số bảng đấu') {
                        groupMatches--;
                      } else {
                        teamsAdvancing--;
                      }
                    });
                  }
                },
              ),
              Text('$value'),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    if (label == 'Số bảng đấu') {
                      groupMatches++;
                    } else {
                      teamsAdvancing++;
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String title, String subtitle, bool value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Switch(
              value: value,
              onChanged: (newValue) {
                setState(() {
                  if (title == 'Tranh hạng 3') {
                    hasThirdPlace = newValue;
                  } else {
                    hasLuckyLoser = newValue;
                  }
                });
              },
            ),
          ],
        ),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildOtherSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            'CÀI ĐẶT KHÁC',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        _buildPointRow('Điểm khi đối thủ bỏ cuộc', defaultPoints),
      ],
    );
  }

  // Widget cho nội dung Loại trực tiếp
  Widget _buildKnockoutContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phần chọn số lượt
        Row(
          children: [
            _buildRoundTypeOption('1 lượt',
                isSelected: selectedRoundType == '1 lượt'),
            const SizedBox(width: 12),
            _buildRoundTypeOption('2 lượt',
                isSelected: selectedRoundType == '2 lượt'),
            const SizedBox(width: 12),
            _buildRoundTypeOption('Consolation',
                isSelected: selectedRoundType == 'Consolation'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Mỗi đội sẽ đấu với các đội còn lại 1 lần.',
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Tìm hiểu thêm về các thể thức thi đấu',
            style: TextStyle(color: Colors.blue),
          ),
        ),

        // Phần CHI TIẾT
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            'CHI TIẾT',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Điểm khi đối thủ bỏ cuộc
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Điểm khi đối thủ bỏ cuộc'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (defaultPoints > 0) {
                      setState(() => defaultPoints--);
                    }
                  },
                ),
                Text('$defaultPoints'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() => defaultPoints++);
                  },
                ),
              ],
            ),
          ],
        ),
        Text(
          'Điểm cộng cho đội chơi nếu đối thủ bỏ cuộc',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),

        // Tranh hạng 3
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tranh hạng 3'),
            Switch(
              value: hasThirdPlace,
              onChanged: (value) {
                setState(() => hasThirdPlace = value);
              },
            ),
          ],
        ),
        Text(
          'Thêm trận tranh hạng 3 cho đội chơi thua vòng bán kết.',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }

  // Widget cho nội dung Vòng tròn
  Widget _buildRoundRobinContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phần chọn số lượt
        Row(
          children: [
            _buildRoundTypeOption('1 lượt', isSelected: roundRobinRounds == 1),
            const SizedBox(width: 12),
            _buildRoundTypeOption('2 lượt', isSelected: roundRobinRounds == 2),
            const SizedBox(width: 12),
            _buildRoundTypeOption('3 lượt', isSelected: roundRobinRounds == 3),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Mỗi đội sẽ đấu với các đội còn lại $roundRobinRounds lần.',
          style: TextStyle(color: Colors.grey[600]),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Tìm hiểu thêm về các thể thức thi đấu',
            style: TextStyle(color: Colors.blue),
          ),
        ),

        // CHI TIẾT
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            'CHI TIẾT',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Điểm khi đối thủ bỏ cuộc
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Điểm khi đối thủ bỏ cuộc'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (defaultPoints > 0) {
                      setState(() => defaultPoints--);
                    }
                  },
                ),
                Text('$defaultPoints'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() => defaultPoints++);
                  },
                ),
              ],
            ),
          ],
        ),
        Text(
          'Điểm cộng cho đội chơi nếu đối thủ bỏ cuộc',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),

        // CÁCH TÍNH XẾP HẠNG
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            'CÁCH TÍNH XẾP HẠNG',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Các nút chọn cách tính điểm
        Row(
          children: [
            _buildScoringOption('Thắng - Thua'),
            const SizedBox(width: 12),
            _buildScoringOption('Win %'),
            const SizedBox(width: 12),
            _buildScoringOption('Games Win %'),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Điểm được tính theo số bàn thắng, thua, hoặc hòa.',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),

        // GIÁ TRỊ ĐIỂM
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            'GIÁ TRỊ ĐIỂM',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Các dòng điểm
        _buildPointRow('Thắng', winPoints),
        _buildPointRow('Thua', losePoints),
        _buildPointRow('Thắng gỡ hòa', drawFirstPriorityPoints),
        _buildPointRow('Thua gỡ hòa', drawSecondPriorityPoints),
        _buildPointRow('Hòa', drawPoints),

        // ƯU TIÊN GỠ HÒA
        const Padding(
          padding: EdgeInsets.only(top: 24, bottom: 12),
          child: Text(
            'ƯU TIÊN GỠ HÒA',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Các hiệp gỡ hòa
        _buildDrawPriorityRow('Hiệp gỡ hòa 1', 'H2H Thắng'),
        _buildDrawPriorityRow('Hiệp gỡ hòa 2', 'Hiệu số'),
        _buildDrawPriorityRow('Hiệp gỡ hòa 3', 'H2H Hiệu số'),
        _buildDrawPriorityRow('Hiệp gỡ hòa 4', 'Không có'),
      ],
    );
  }

  Widget _buildPointRow(String label, int points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  setState(() {
                    switch (label) {
                      case 'Thắng':
                        if (winPoints > 0) winPoints--;
                        break;
                      case 'Thua':
                        if (losePoints > 0) losePoints--;
                        break;
                      case 'Hòa':
                        if (drawPoints > 0) drawPoints--;
                        break;
                      case 'Thắng gỡ hòa':
                        if (drawFirstPriorityPoints > 0)
                          drawFirstPriorityPoints--;
                        break;
                      case 'Thua gỡ hòa':
                        if (drawSecondPriorityPoints > 0)
                          drawSecondPriorityPoints--;
                        break;
                    }
                  });
                },
              ),
              Text('$points'),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    switch (label) {
                      case 'Thắng':
                        winPoints++;
                        break;
                      case 'Thua':
                        losePoints++;
                        break;
                      case 'Hòa':
                        drawPoints++;
                        break;
                      case 'Thắng gỡ hòa':
                        drawFirstPriorityPoints++;
                        break;
                      case 'Thua gỡ hòa':
                        drawSecondPriorityPoints++;
                        break;
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawPriorityRow(String label, String value) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => _buildPriorityOptionsSheet(label),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Row(
              children: [
                Text(selectedPriorities[label] ?? value),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityOptionsSheet(String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: priorityOptions.length,
            itemBuilder: (context, index) {
              final option = priorityOptions[index];
              final isSelected = selectedPriorities[label] == option;
              
              return ListTile(
                title: Text(option),
                trailing: isSelected 
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
                onTap: () {
                  setState(() {
                    selectedPriorities[label] = option;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // // Helper widgets cho tab Vòng tròn
  // Widget _buildScoringOption(String text) {
  //   bool isSelected = selectedScoringType == text;
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedScoringType = text;
  //       });
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //       decoration: BoxDecoration(
  //         color: isSelected ? Colors.green : Colors.white,
  //         border: Border.all(color: isSelected ? Colors.green : Colors.grey),
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Text(
  //         text,
  //         style: TextStyle(
  //           color: isSelected ? Colors.white : Colors.black,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget cho bottom bar
  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TỔNG',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 40),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Xử lý khi nhấn Xem trước
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
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

  // Helper widgets
  // Cập nhật _buildFormatOption để xử lý onTap
  Widget _buildFormatOption(String name, IconData icon,
      {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFormat = name;
          // Reset các giá trị khi chuyển tab nếu cần
          roundRobinRounds = 1;
          hasThirdPlace = false;
          hasLuckyLoser = false;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 24,
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
      ),
    );
  }

  Widget _buildRoundTypeOption(String text,
      {bool isSelected = false, String? subtitle}) {
    return GestureDetector(
      onTap: () {
      setState(() {
        switch (text) {
          case '1 lượt':
            roundRobinRounds = 1;
            break;
          case '2 lượt':
            roundRobinRounds = 2;
            break;
          case '3 lượt':
            roundRobinRounds = 3;
            break;
        }
      });
    },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  color: isSelected ? Colors.white70 : Colors.grey,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
