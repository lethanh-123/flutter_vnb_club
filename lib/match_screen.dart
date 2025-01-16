import 'package:flutter/material.dart';
import 'match_detail_screen.dart';
import 'api_service.dart';
import 'match.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late Future<Map<String, dynamic>> _matchesAndTournaments;

  @override
  void initState() {
    super.initState();
    _matchesAndTournaments = ApiService.getMatchesAndTournaments();
  }

  Future<void> _refreshData() async {
    setState(() {
      _matchesAndTournaments = ApiService.getMatchesAndTournaments();
    });
  }

  String _formatTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: FutureBuilder<Map<String, dynamic>>(
              future: _matchesAndTournaments,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Lỗi: ${snapshot.error}'),
                        ElevatedButton(
                          onPressed: _refreshData,
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final matches = snapshot.data!['matches'] as List<Match>;

                return ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return _buildMatchItem(
                      time: match.getFormattedTime,
                      sportIcon: Icons.sports_baseball,
                      sportName: match.getSportName,
                      title: match.getTitle,
                      location: match.getLocation,
                      maxParticipants: match.getMaxPlayers,
                      currentParticipants: match.getCurrentParticipants,
                      details: {
                        'time': match.getFormattedTime,
                        'date': match.getFormattedDate,
                        'title': match.getTitle,
                        'teamName': match.getTeamName,
                        'teamLogo': match.getTeamLogo,
                        'subtitle':
                            'Registration deadline: ${DateFormat('dd/MM/yyyy HH:mm').format(match.getRegistrationDeadline)}',
                        'location': match.getLocation,
                        'fullAddress': match.getLocation,
                        'level': match.getSkillLevelRange,
                        'price': '${match.getFormattedFee} đ',
                        'notes': [match.getNotes],
                        'maxParticipants': match.getMaxPlayers,
                        'currentParticipants': match.getCurrentParticipants,
                      },
                    );
                  },
                );
              },
            ),
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
    required Map<String, dynamic> details,
  }) {
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (maxParticipants != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('$currentParticipants/$maxParticipants'),
                        const SizedBox(width: 8),
                        Row(
                          children: List.generate(
                            6,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                                color: index < (currentParticipants ?? 0)
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                              child: index < (currentParticipants ?? 0)
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
      ),
    );
  }
}
