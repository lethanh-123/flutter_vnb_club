import 'package:flutter/material.dart';
import 'club_preview_screen.dart';

class ClubNameScreen extends StatefulWidget {
  const ClubNameScreen({Key? key}) : super(key: key);

  @override
  State<ClubNameScreen> createState() => _ClubNameScreenState();
}

class _ClubNameScreenState extends State<ClubNameScreen> {
  bool isPublic = true;
  bool autoApprove = false;
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Đặt tên CLB'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tên CLB input
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Đặt tên',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // Trigger rebuild to show/hide FAB
                setState(() {});
              },
            ),
            const SizedBox(height: 32),

            // Lựa chọn loại CLB
            Column(
              children: [
                // CLB công khai
                RadioListTile<bool>(
                  value: true,
                  groupValue: isPublic,
                  onChanged: (value) {
                    setState(() {
                      isPublic = value!;
                    });
                  },
                  title: const Text(
                    'Công khai',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    '1 CLB công khai có thể nhìn thấy và yêu cầu tham gia bất kỳ người nào',
                  ),
                  activeColor: Colors.blue,
                ),

                // CLB riêng tư
                RadioListTile<bool>(
                  value: false,
                  groupValue: isPublic,
                  onChanged: (value) {
                    setState(() {
                      isPublic = value!;
                    });
                  },
                  title: const Text(
                    'CLB riêng tư',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Không ai có thể thấy, yêu cầu tham gia, hay theo dõi một CLB riêng tư, trừ khi được mời bởi admin',
                  ),
                  activeColor: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Duyệt yêu cầu tự động
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Duyệt tham gia tự động thành viên',
                  style: TextStyle(fontSize: 16),
                ),
                Switch(
                  value: autoApprove,
                  onChanged: (value) {
                    setState(() {
                      autoApprove = value;
                    });
                  },
                  activeColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: _nameController.text.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClubPreviewScreen(
                      clubName: _nameController.text,
                      isPublic: isPublic,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.arrow_forward),
            )
          : null,
    );
  }
}
