import 'package:flutter/material.dart';
import 'match_detail_screen.dart';
import "api_service.dart";
import 'match.dart';
import 'tournament.dart';
import 'api_service.dart';
import 'dupr_ranking_screen.dart';
import 'category_cards.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Future<Map<String, List>> _matchesAndTournaments;
  String _selectedTab = 'Tất cả';
  String _selectedCategory = 'Trận đấu';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryCards(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                if (category == 'Xếp hạng') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DuprRankingScreen(),
                    ),
                  ).then((_) {
                    setState(() {
                      _selectedCategory = 'Trận đấu';
                    });
                  });
                } else {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            ),
            if (_selectedCategory == 'Trận đấu') ...[
              // Tab buttons
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    _buildTabButton('Tất cả', _selectedTab == 'Tất cả'),
                    const SizedBox(width: 16),
                    _buildTabButton(
                        'Sắp diễn ra', _selectedTab == 'Sắp diễn ra'),
                    const SizedBox(width: 16),
                    _buildTabButton(
                        'Đã kết thúc', _selectedTab == 'Đã kết thúc'),
                  ],
                ),
              ),

              // Match and Tournament list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshData,
                  child: FutureBuilder<Map<String, List>>(
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
                      final tournaments =
                          snapshot.data!['tournaments'] as List<Tournament>;
                      final allItems = [...matches, ...tournaments];

                      // Lọc theo tab đã chọn
                      final filteredItems = allItems.where((item) {
                        // Không cần parse DateTime vì datetime đã là DateTime
                        final DateTime itemDate = item is Match
                            ? item.getDatetime // Sử dụng getter getDatetime
                            : (item as Tournament)
                                .getDatetime; // Sử dụng getter getDatetime

                        switch (_selectedTab) {
                          case 'Sắp diễn ra':
                            return itemDate.isAfter(DateTime.now());
                          case 'Đã kết thúc':
                            return itemDate.isBefore(DateTime.now());
                          default:
                            return true;
                        }
                      }).toList();

                      if (filteredItems.isEmpty) {
                        return const Center(
                          child: Text('Không có hoạt động nào'),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final bool isTournament = item is Tournament;

                          if (isTournament) {
                            final tournament = item as Tournament;
                            return _buildMatchHistoryItem(
                              context,
                              date: tournament
                                  .getFormattedDate, // Sử dụng getter getFormattedDate
                              clubLogo: 'assets/pic.png',
                              title: tournament.getTitle,
                              participants: tournament.getParticipantsDisplay,
                              progress: 0.0,
                              duration: 'Chưa bắt đầu',
                            );
                          } else {
                            final match = item as Match;
                            return _buildMatchHistoryItem(
                              context,
                              date: match
                                  .getFormattedDate, // Sử dụng getter getFormattedDate
                              clubLogo: 'assets/pic.png',
                              title: match.getTitle,
                              participants: match.getParticipantsStatus,
                              progress: 0.0,
                              duration: 'Chưa bắt đầu',
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ));
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = text;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData? icon,
    required String label,
    bool isSelected = false,
    bool isDuprOnly = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue : Colors.white,
          elevation: isSelected ? 0 : 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isDuprOnly)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'DUPR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: icon != null
                        ? Icon(
                            icon,
                            color: isSelected ? Colors.white : Colors.black,
                            size: 24,
                          )
                        : null,
                  ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchHistoryItem(
    BuildContext context, {
    required String date,
    required String clubLogo,
    required String title,
    required String participants,
    required double progress,
    required String duration,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DUPR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events, color: Colors.amber),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  participants,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                duration,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
