import 'package:flutter/material.dart';

class CoachScreen extends StatelessWidget {
  const CoachScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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

        // Coach list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildCoachCard(
                imageUrl: 'assets/coach.webp',
                name: 'Coach Nelson',
                sport: 'Quần vợt',
                flags: ['vn', 'us', 'fr'],
              ),
              _buildCoachCard(
                imageUrl: 'assets/coach.webp',
                name: 'Coach Nelson',
                sport: 'Pickleball',
                flags: ['vn', 'us', 'fr'],
                description: 'Pickleball Player/Coach',
              ),
              _buildCoachCard(
                imageUrl: 'assets/coach.webp',
                name: 'Fa Ra',
                sport: 'Pickleball',
                description: 'Tennis Player/Coach',
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

  Widget _buildCoachCard({
    required String imageUrl,
    required String name,
    required String sport,
    List<String> flags = const [],
    String? description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coach Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(imageUrl),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            
            // Coach Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        sport == 'Quần vợt' 
                            ? Icons.sports_tennis
                            : Icons.sports_baseball,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sport,
                        style: const TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  if (flags.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ...flags.map((flag) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            _getFlagEmoji(flag),
                            style: const TextStyle(fontSize: 20),
                          ),
                        )).toList(),
                      ],
                    ),
                  ],
                  if (description != null) ...[
                    const SizedBox(height: 8),
                    Text(description),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFlagEmoji(String countryCode) {
    switch (countryCode) {
      case 'vn':
        return '🇻🇳';
      case 'us':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      default:
        return '';
    }
  }
}