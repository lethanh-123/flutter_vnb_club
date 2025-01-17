import 'package:flutter/material.dart';
import 'category_cards.dart';
import 'dupr_ranking_screen.dart';


class StreetCredScreen extends StatefulWidget {
  final bool showBottomNav;
  final bool showAppBar;

  const StreetCredScreen({
    Key? key,
    this.showBottomNav = true,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  State<StreetCredScreen> createState() => _StreetCredScreenState();
}

class _StreetCredScreenState extends State<StreetCredScreen> {
  String selectedPeriod = '1/2025';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Street Cred: Bảng xếp hạng',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Location and Category Pills
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Ho Chi Minh City Metropolitan'),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Thể thao • Pickleball',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // Time Period Selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildPeriodButton('1/2025', isSelected: true),
                  _buildPeriodButton('12/2024'),
                  _buildPeriodButton('11/2024'),
                  _buildPeriodButton('YTD'),
                ],
              ),
            ),

            // Grid of Categories
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildCategoryCard(
                    title: 'ATP',
                    name: 'Huy Mac',
                    cred: 14,
                    images: ['assets/player1.jpg', 'assets/player2.jpg', 'assets/player3.jpg'],
                  ),
                  _buildCategoryCard(
                    title: 'Phòng thủ',
                    name: 'Giang',
                    cred: 17,
                    images: ['assets/player4.jpg', 'assets/player5.jpg', 'assets/player6.jpg'],
                  ),
                  _buildCategoryCard(
                    title: 'Drop Resets',
                    name: 'Casey',
                    cred: 25,
                    images: ['assets/player7.jpg', 'assets/player8.jpg', 'assets/player9.jpg'],
                  ),
                  _buildCategoryCard(
                    title: 'Poaching',
                    name: 'Hồng Hiếu',
                    cred: 7,
                    images: ['assets/player10.jpg', 'assets/player11.jpg', 'assets/player12.jpg'],
                  ),
                  _buildCategoryCard(
                    title: 'Driving',
                    name: 'Lê Thanh...',
                    cred: 41,
                    images: ['assets/player13.jpg', 'assets/player14.jpg', 'assets/player15.jpg'],
                  ),
                  _buildCategoryCard(
                    title: 'Dinking',
                    name: 'Ca Tư',
                    cred: 20,
                    images: ['assets/player16.jpg', 'assets/player17.jpg', 'assets/player18.jpg'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String period, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedPeriod = period;
          });
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String name,
    required int cred,
    required List<String> images,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 0; i < images.length && i < 3; i++)
                Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(images[i]),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cred}crd',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
