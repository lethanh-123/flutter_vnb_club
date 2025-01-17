import 'package:flutter/material.dart';

class DuprRankingScreen extends StatefulWidget {
  final bool showBottomNav;
  final bool showAppBar;
  
  const DuprRankingScreen({
    Key? key,
    this.showBottomNav = true,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  State<DuprRankingScreen> createState() => _DuprRankingScreenState();
}

class _DuprRankingScreenState extends State<DuprRankingScreen> {
  String _selectedFilter = 'Vietnam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Xếp hạng DUPR',
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
            )
          : null,
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('Vietnam', isSelected: true),
                const SizedBox(width: 8),
                _buildFilterChip('Giới tính'),
              ],
            ),
          ),

          // Column headers
          Padding(
            padding: const EdgeInsets.fromLTRB(82, 16, 16, 16),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                SizedBox(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Đánh đôi',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Đánh đơn',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Rankings list
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return _buildRankingItem(
                  rank: index + 1,
                  avatar: 'assets/ava.png',
                  name: 'Player ${index + 1}',
                  location: 'Ho Chi Minh City Metropolitan, Vietnam',
                  doublesRating: (6.0 - index * 0.1).toStringAsFixed(3),
                  singlesRating: 'NR',
                  gender: index % 2 == 0 ? 'Nam' : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return FilterChip(
      selected: isSelected,
      label: Text(label),
      onSelected: (bool selected) {
        setState(() {
          _selectedFilter = selected ? label : '';
        });
      },
      selectedColor: Colors.green[100],
      checkmarkColor: Colors.green,
    );
  }

  Widget _buildRankingItem({
    required int rank,
    required String avatar,
    required String name,
    required String location,
    required String doublesRating,
    required String singlesRating,
    String? gender,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 30,
            child: Text(
              rank.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),

          // Avatar
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(avatar),
          ),
          const SizedBox(width: 12),

          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (gender != null) ...[
                      Text(
                        gender,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        ' • ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Ratings
          SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  doublesRating,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  singlesRating,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: singlesRating == 'NR' ? Colors.grey : Colors.black,
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