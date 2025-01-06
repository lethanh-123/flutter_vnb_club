import 'package:flutter/material.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              _buildFilterChip('Ho Chi Minh City Metropolitan', true),
              _buildFilterChip('Thể thao', false),
            ],
          ),
        ),

        // Tab buttons
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildTabButton('Tất cả', true),
              const SizedBox(width: 16),
              _buildTabButton('Thời gian đăng ký', false),
              const SizedBox(width: 16),
              _buildTabButton('Đang diễn ra', false),
            ],
          ),
        ),

        // Tournament list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              _buildTournamentCard(
                image: 'assets/nba_players.webp',
                sportIcon: Icons.sports_basketball,
                title: 'Basketball Tourney',
                status: '1 trận đấu sắp diễn ra.',
                date: '25/08',
                location: 'Minneapolis',
                participants: 8,
                type: 'Đấu hỗn hợp',
                isLive: true,
              ),
              _buildTournamentCard(
                image: 'assets/pic.jpg',
                sportIcon: 'assets/pickle.png',
                title: 'Giải nội bộ Fun & Health Pickleball',
                status: '1 trận đấu sắp diễn ra.',
                date: '25/08',
                location: 'Minneapolis',
                participants: 8,
                type: 'Đấu hỗn hợp',
                isLive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          // TODO: Implement filter logic
        },
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Text(
      text,
      style: TextStyle(
        color: isSelected ? Colors.blue : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildTournamentCard({
    required String title,
    required String status,
    required String date,
    required String location,
    required int participants,
    required String type,
    required bool isLive,
    dynamic sportIcon,
    String? image,
    Color backgroundColor = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
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
          // Tournament image if available
          if (image != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.asset(
                image,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sport icon and title
                Row(
                  children: [
                    sportIcon is IconData
                        ? Icon(sportIcon as IconData, size: 24)
                        : Image.asset(
                            sportIcon as String,
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                if (status.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    status,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],

                if (isLive) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'ĐANG DIỄN RA',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],

                if (date.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.emoji_events,
                                color: Colors.orange),
                            Text(
                              date,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (location.isNotEmpty)
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16),
                                  const SizedBox(width: 4),
                                  Text(location),
                                ],
                              ),
                            if (participants > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.people, size: 16),
                                  const SizedBox(width: 4),
                                  Text('$participants xác nhận tham gia'),
                                ],
                              ),
                            ],
                            if (type.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.sports, size: 16),
                                  const SizedBox(width: 4),
                                  Text(type),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
