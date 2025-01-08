import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'community_search_screen.dart';

class TermsAndPolicyScreen extends StatelessWidget {
  const TermsAndPolicyScreen({Key? key}) : super(key: key);

  // Updated launch URL method
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    // Check if the URL can be launched
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // If URL can't be launched, handle the error
      print('Could not launch URL: $url');
      // Optionally, show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.handshake, color: Colors.redAccent, size: 50),
                const SizedBox(width: 10),
                Icon(Icons.handshake, color: Colors.blueAccent, size: 50),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Chúng tôi tôn trọng sự bảo mật của bạn',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              'Để tiếp tục, hãy kiểm tra và bấm đồng ý với ',
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () =>
                  _launchURL('https://shopvnb.com/chinh-sach-bao-mat.html'),
              child: const Text(
                'chính sách bảo mật ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            GestureDetector(
              onTap: () =>
                  _launchURL('https://shopvnb.com/dieu-khoan-su-dung.html'),
              child: const Text(
                'và điều khoản dịch vụ.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 100,
                    vertical: 15,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunitySearchScreen(
                        isFromCreateOptions:
                            false, // Đặt rõ là false khi đi từ Terms screen
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Tôi đồng ý',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
