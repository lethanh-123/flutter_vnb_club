import 'package:flutter/material.dart';

class ClubJoinScreen extends StatelessWidget {
  const ClubJoinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tham gia Câu lạc bộ'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm kiếm bằng từ khoá hoặc mã',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Ho Chi Minh City Metropolitan', true),
                _buildFilterChip('Thể thao', false),
                _buildFilterChip('Khác', false),
              ],
            ),
          ),
          // Club List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildClubCard(
                  logoUrl: 'https://via.placeholder.com/50',
                  name: 'SkyPickleball',
                  members: 124,
                  skillLevel: 'Tất cả trình độ',
                  activityTime: 'Th01 4',
                  schedule: '6:00',
                  description: 'SÁNG THỨ 7 VUI VẺ. SKY PICKLE...',
                ),
                _buildClubCard(
                  logoUrl: 'https://via.placeholder.com/50',
                  name: 'D&S Pickleball Club',
                  members: 182,
                  skillLevel: '3.0',
                  activityTime: 'Th01 6',
                  schedule: '19:00',
                  description: 'HAPPY MONDAY SOCIAL 😊...',
                ),
                _buildClubCard(
                  logoUrl: 'https://via.placeholder.com/50',
                  name: 'TS Sports Club',
                  members: 757,
                  skillLevel: 'Tất cả trình độ',
                  activityTime: 'Hoạt động 2 phút trước',
                  schedule: '',
                  description: 'Social Everyday Pickleball',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // TODO: Handle filter change
        },
      ),
    );
  }

  Widget _buildClubCard({
    required String logoUrl,
    required String name,
    required int members,
    required String skillLevel,
    required String activityTime,
    required String schedule,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Club Logo
            CircleAvatar(
              backgroundImage: NetworkImage(logoUrl),
              radius: 24,
            ),
            const SizedBox(width: 12),
            // Club Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Club Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Member Count and Skill Level
                  Row(
                    children: [
                      const Icon(Icons.people, size: 16),
                      const SizedBox(width: 4),
                      Text('$members Thành viên'),
                      const SizedBox(width: 8),
                      const Icon(Icons.sports_tennis, size: 16),
                      const SizedBox(width: 4),
                      Text(skillLevel),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Activity Time
                  Text(
                    activityTime,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  // Description
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Schedule
            if (schedule.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    schedule,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
