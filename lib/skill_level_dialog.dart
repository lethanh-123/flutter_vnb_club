import 'package:flutter/material.dart';

class SkillLevelDialog extends StatefulWidget {
  final String currentLevel;

  const SkillLevelDialog({
    Key? key,
    required this.currentLevel,
  }) : super(key: key);

  @override
  State<SkillLevelDialog> createState() => _SkillLevelDialogState();
}

class _SkillLevelDialogState extends State<SkillLevelDialog> {
  late String selectedLevel;
  final List<String> levels = [
    'Newbie / 2.0',
    '2.25',
    '2.5',
    '2.75',
    '3.0',
    '3.25',
    '3.5',
    '3.75',
    '4.0',
    '4.25',
    '4.5',
    '4.75',
    '5.0+',
  ];

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.currentLevel;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header với icon và nút đóng
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CD080),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.sports_tennis,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          // Tiêu đề
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Kỹ năng Pickleball của bạn đang ở mức nào?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              '*',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            ),
          ),

          // Grid các level
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: levels.map((level) {
                final isSelected = level == selectedLevel;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedLevel = level;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4CD080)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      level,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red[700]),
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, selectedLevel);
                    },
                    child: const Text(
                      'Lưu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
