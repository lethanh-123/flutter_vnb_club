import 'package:flutter/material.dart';
import 'match_detail_screen.dart';

class MatchScreen extends StatefulWidget {
  // Chuyển thành StatefulWidget
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
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
              _buildFilterChip('Thời gian', false),
              _buildFilterChip('Thiết bị', false),
            ],
          ),
        ),

        // "Hôm Nay" header
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Hôm Nay',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),

        // Match list
        Expanded(
          child: ListView(
            children: [
              _buildMatchItem(
                time: '10:30',
                sportIcon: Icons.sports_tennis,
                sportName: 'JAT BADMINTON',
                title: 'Tấn Phúc T7 10h30-14h00',
                location: 'Sân cầu lông/Badminton',
                participants: const [
                  'https://example.com/avatar1.jpg',
                  'https://example.com/avatar2.jpg',
                  'https://example.com/avatar3.jpg',
                ],
                totalSlots: 14,
                filledSlots: 12,
              ),
              _buildMatchItem(
                time: '11:00',
                sportIcon: Icons.sports_baseball,
                sportName: 'CLB PICKLEBALL ÂU CƠ',
                title: 'Giao hữu',
                location: '161 Đ. Âu Cơ',
              ),
              _buildMatchItem(
                time: '11:00',
                sportIcon: Icons.sports_baseball,
                sportName: 'SUNRISE PICKLEBALL CLUB',
                title: 'Pickleball Social with linh',
                location: 'Sunrise Pickleball ',
                maxParticipants: 24,
                currentParticipants: 1,
              ),
              _buildMatchItem(
                time: '11:00',
                sportIcon: Icons.sports_tennis,
                sportName: 'SAIGON BADMINTON STREET',
                title: 'SAIGON BADMINTON STREET SATURDAY GAME 🏸 🏸',
                location: 'Sân cầu lông quận 3',
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

  Widget _buildMatchItem({
    required String time,
    required IconData sportIcon,
    required String sportName,
    required String title,
    required String location,
    List<String>? participants,
    int? totalSlots,
    int? filledSlots,
    int? maxParticipants,
    int? currentParticipants,
  }) {
    Map<String, dynamic> matchDetails = {
      'JAT BADMINTON': {
        'time': '10:30',
        'date': 'Thứ bảy, 4/1',
        'title': 'Tấn Phúc T7 10h30-14h00',
        'teamName': 'JAT BADMINTON',
        'teamLogo': 'assets/jat_logo.png',
        'subtitle': 'Thứ bảy hàng tuần',
        'location': 'Sân cầu lông/Badminton',
        'fullAddress': 'Sân cầu lông quận Tân Phú, TP.HCM',
        'level': '3.0 - 4.0 [Trình (tự đánh giá)]',
        'price': '80.000 đ',
        'notes': [
          'Thời gian: 10:30 - 14:00',
          'Địa điểm: Sân cầu lông Tấn Phúc',
        ],
        'maxParticipants': 14,
        'currentParticipants': 12,
      },
      'CLB PICKLEBALL ÂU CƠ': {
        'time': '11:00',
        'date': 'Thứ bảy, 4/1',
        'title': 'Giao hữu',
        'teamName': 'CLB PICKLEBALL ÂU CƠ',
        'teamLogo': 'assets/auco_logo.png',
        'subtitle': 'Giao hữu cuối tuần',
        'location': '161 Đ. Âu Cơ',
        'fullAddress': '161 Đường Âu Cơ, Phường 14, Tân Bình, TP.HCM',
        'level': 'Tất cả trình độ',
        'price': '70.000 đ',
        'notes': [
          'Thời gian: 11:00 - 13:00',
          'Địa điểm: Sân Pickleball Âu Cơ',
        ],
        'maxParticipants': 16,
        'currentParticipants': 8,
      },
      'SUNRISE PICKLEBALL CLUB': {
        'time': '11:00',
        'date': 'Thứ bảy, 4/1',
        'title': 'Pickleball Social with linh',
        'teamName': 'SUNRISE PICKLEBALL CLUB',
        'teamLogo': 'assets/sunrise_logo.jpg',
        'subtitle': 'Social Pickleball',
        'location': 'Sunrise Pickleball',
        'fullAddress': 'Sunrise Pickleball Club, Quận 7, TP.HCM',
        'level': '2.5 - 3.5 [Trình (tự đánh giá)]',
        'price': '75.000 đ',
        'notes': [
          'Thời gian: 11:00 - 13:30',
          'Địa điểm: Sân trong khu Sunrise City',
        ],
        'maxParticipants': 24,
        'currentParticipants': 1,
      },
      '"MẮC ĐÁNH" TEAM': {
        'time': '15:30',
        'date': 'Thứ bảy, 4/1',
        'title': '75K 2.5G GIỜ CHƠI',
        'teamName': '"MẮC ĐÁNH" TEAM',
        'teamLogo': 'assets/dink.png',
        'subtitle': 'Thứ bảy hàng tuần',
        'location': '206 Bình Quới',
        'fullAddress': '206 Bình Quới, Phường 28, Bình Thạnh',
        'level': '2.5 - 3.5 [Trình (tự đánh giá)]',
        'price': '75.000 đ',
        'notes': [
          'Thời gian: 15:30 - 18G',
          'Địa điểm: Sân trong khu view sông 206/3 Bình Quới',
        ],
        'maxParticipants': 6,
        'currentParticipants': 1,
      },
    };

    var details = matchDetails[sportName] ?? matchDetails['"MẮC ĐÁNH" TEAM'];

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchDetailScreen(
                time: details['time'],
                date: details['date'],
                title: details['title'],
                teamName: details['teamName'],
                teamLogo: details['teamLogo'],
                subtitle: details['subtitle'],
                location: details['location'],
                fullAddress: details['fullAddress'],
                level: details['level'],
                price: details['price'],
                notes: List<String>.from(details['notes']),
                maxParticipants: details['maxParticipants'],
                currentParticipants: details['currentParticipants'],
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time column
              SizedBox(
                width: 60,
                child: Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Main content column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sport name with icon
                    Row(
                      children: [
                        Icon(sportIcon, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          sportName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),

                    // Participants
                    if (participants != null && totalSlots != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('$filledSlots/$totalSlots'),
                          const SizedBox(width: 8),
                          // Avatar stack would go here
                          const Text('+6'),
                        ],
                      ),
                    ],

                    if (maxParticipants != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('$currentParticipants/$maxParticipants'),
                          const SizedBox(width: 8),
                          // Participant slots visualization
                          Row(
                            children: List.generate(
                              6,
                              (index) => Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey),
                                  color: index == 0
                                      ? Colors.blue
                                      : Colors.transparent,
                                ),
                                child: index == 0
                                    ? const Icon(Icons.person,
                                        size: 16, color: Colors.white)
                                    : null,
                              ),
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
        ));
  }
}
