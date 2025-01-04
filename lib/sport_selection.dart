import 'package:flutter/material.dart';
import 'club_join_screen.dart';

class SportSelectionScreen extends StatefulWidget {
  const SportSelectionScreen({Key? key}) : super(key: key);

  @override
  State<SportSelectionScreen> createState() => _SportSelectionScreenState();
}

class _SportSelectionScreenState extends State<SportSelectionScreen> {
  final List<Map<String, dynamic>> sports = [
    {
      'name': 'Cầu Lông',
      'icon': Image.asset(
        'assets/badminton.png',
        width: 40,
        height: 40,
      ),
    },
    {
      'name': 'Pickle Ball',
      'icon': Image.asset(
        'assets/pickle.png',
        width: 40,
        height: 40,
      ),
    },
    {'name': 'Tennis', 'icon': '🎾'},
    {'name': 'Aussie Footy', 'icon': '🏉'},
    {'name': 'Ball Hockey', 'icon': '🏒'},
    {'name': 'Bắn Cung', 'icon': '🏹'},
    {'name': 'Bắn súng sơn', 'icon': '🔫'},
    {'name': 'Bi Da', 'icon': '🎱'},
    {'name': 'Bóng bàn', 'icon': '🏓'},
    {'name': 'Bóng đá', 'icon': '⚽'},
    {'name': 'Bóng chuyền', 'icon': '🏐'},
  ];

  final Map<String, String> selectedSports = {};
  String searchQuery = "";

  void showSkillDialog(String sportName) {
    final List<String> skillLevels = [
      'Mới bắt đầu',
      'Nhập môn',
      'Trung bình',
      'Khá',
      'Chuyên nghiệp',
      'Chuyên gia'
    ];

    String? temporarySkill = selectedSports[sportName];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kỹ năng $sportName của bạn đang ở mức nào?',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skillLevels.map((skill) {
                      return ChoiceChip(
                        label: Text(skill),
                        selected: temporarySkill == skill,
                        onSelected: (isSelected) {
                          modalSetState(() {
                            temporarySkill = isSelected ? skill : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        if (temporarySkill != null) {
                          selectedSports[sportName] = temporarySkill!;
                          sports.sort((a, b) {
                            if (a['name'] == sportName) return -1;
                            if (b['name'] == sportName) return 1;
                            return 0;
                          });
                        }
                      });
                    },
                    child: const Text('Lưu'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _goToSportSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClubJoinScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredSports = sports
        .where((sport) =>
            sport['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Chọn môn thể thao'),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm môn thể thao...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredSports.length,
                itemBuilder: (context, index) {
                  final sport = filteredSports[index];
                  final dynamic icon = sport['icon'];
                  final String sportName = sport['name'];
                  final bool isSelected = selectedSports.containsKey(sportName);

                  return GestureDetector(
                    onTap: () => showSkillDialog(sportName),
                    child: Card(
                      color: isSelected ? Colors.blue[200] : Colors.white,
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (icon is Widget)
                                  icon
                                else if (icon is String)
                                  Text(
                                    icon,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  sportName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                if (isSelected)
                                  Text(
                                    selectedSports[sportName]!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: -5,
                              right: -5,
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    size: 20, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    selectedSports.remove(sportName);
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: selectedSports.length == 1
          ? FloatingActionButton(
              onPressed: _goToSportSelection,
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }
}
