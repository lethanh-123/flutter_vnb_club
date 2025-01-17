import 'package:flutter/material.dart';
import 'category_cards.dart';
import 'dupr_ranking_screen.dart';

class StreetCredScreen extends StatefulWidget {
  const StreetCredScreen({Key? key}) : super(key: key);

  @override
  State<StreetCredScreen> createState() => _StreetCredScreenState();
}

class _StreetCredScreenState extends State<StreetCredScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Thống kê',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Cập nhật hàng ngày',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CategoryCards(
            selectedCategory: 'Độ uy tín',
            onCategorySelected: (category) {
              if (category == 'Trận đấu') {
                Navigator.popUntil(context, (route) => route.isFirst);
              } else if (category == 'Xếp hạng') {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DuprRankingScreen(),
                  ),
                );
              }
            },
          ),
          // Thêm nội dung của trang Độ uy tín ở đây
        ],
      ),
    );
  }
}
