import 'package:flutter/material.dart';

class SportSelectionScreen extends StatelessWidget {
  const SportSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sports = [
      {'name': 'Aussie Footy', 'icon': '🏉'},
      {'name': 'Ball Hockey', 'icon': '🏒'},
      {'name': 'Bắn Cung', 'icon': '🏹'},
      {'name': 'Bắn súng sơn', 'icon': '🔫'},
      {'name': 'Bi Da', 'icon': '🎱'},
      {'name': 'Bóng bàn', 'icon': '🏓'},
      {'name': 'Bóng đá', 'icon': '⚽'},
      {'name': 'Bóng chuyền', 'icon': '🏐'},
      // Thêm các môn thể thao khác nếu cần
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Chọn môn thể thao'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: sports.length,
          itemBuilder: (context, index) {
            final sport = sports[index];
            return Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sport['icon']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sport['name']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
