import 'package:flutter/material.dart';
import 'package:flutter_vnb_ios/dupr_login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Text(
                      'LT',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'User Admin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    '@le-tam-533',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Thêm giới tính và độ tuổi'),
                  ),
                  const Text(
                    'Nói đôi điều về bạn',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Sports section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'THỂ THAO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Thêm'),
                  ),
                ],
              ),
            ),
            _buildSportItem(
              'Cầu lông',
              '🏸',
              'Trung bình',
              null,
            ),
            _buildSportItem(
              'Pickleball',
              '🏓',
              '2.75',
              null,
              duprRating: '3.165 NR',
              lobbing: '1 crd',
            ),
            _buildSportItem(
              'Quần vợt',
              '🎾',
              'Trung bình',
              null,
            ),

            // Communities section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CỘNG ĐỒNG',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Thêm'),
                  ),
                ],
              ),
            ),

            // Community item
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blue),
              title: const Text('Ho Chi Minh City\nMetropolitan Vietnam'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('hoạt động'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSportItem(
    String name,
    String icon,
    String level,
    String? position, {
    String? duprRating,
    String? lobbing,
  }) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (position != null) ...[
            const Text(
              'TRÌNH (TỰ ĐÁNH GIÁ)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(level),
            const Text(
              'VỊ TRÍ',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(position),
          ] else
            Text(level),
          if (duprRating != null)
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DuprLoginScreen(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    var newRating = result['doubles']?.toString() ?? 'NR';
                    final confidence = result['confidence'];
                    if (confidence != null) {
                      newRating =
                          '$newRating (${confidence.round()}% độ tin cậy)';
                    }
                    duprRating = newRating;
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'DUPR $duprRating',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          if (lobbing != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Lobbing $lobbing',
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
