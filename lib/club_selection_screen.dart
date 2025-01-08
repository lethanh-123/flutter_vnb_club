import 'package:flutter/material.dart';
import 'post_editor_screen.dart';

class ClubSelectionScreen extends StatelessWidget {
  const ClubSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Viết bài',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'CLB',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildClubItem(
                  context,
                  'Athletic Approach',
                  'assets/pic.png',
                ),
                _buildClubItem(
                  context,
                  'ATP LAB TOUR',
                  'assets/pic.png',
                ),
                _buildClubItem(
                  context,
                  'Big Balls Pickle Club',
                  'assets/pic.png',
                ),
                _buildClubItem(
                  context,
                  'DK Pickleball Club 187 NVH',
                  'assets/pic.png',
                ),
                _buildClubItem(
                  context,
                  'ESE PICKLEBALL',
                  'assets/pic.png',
                ),
                _buildClubItem(
                  context,
                  'GM CLUB\n(GAMOORGAMEMASTERS)',
                  'assets/pic.png',
                ),
                _buildClubItem(
                  context,
                  'GOAT Pickleball',
                  'assets/pic.png',
                ),
                _buildClubItem(
                  context,
                  'Khét Lẹt Pickleball - Gò Vấp',
                  'assets/pic.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClubItem(BuildContext context, String name, String logoPath) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          logoPath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(name),
      trailing: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostEditorScreen(clubName: name),
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          side: const BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text('Đăng'),
      ),
    );
  }
}