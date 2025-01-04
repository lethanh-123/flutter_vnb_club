import 'package:flutter/material.dart';
import 'sport_selection.dart';

class CommunitySearchScreen extends StatefulWidget {
  const CommunitySearchScreen({Key? key}) : super(key: key);

  @override
  _CommunitySearchScreenState createState() => _CommunitySearchScreenState();
}

class _CommunitySearchScreenState extends State<CommunitySearchScreen> {
  final List<Map<String, String>> _communities = [
    {
      'title': 'Ho Chi Minh City Metropolitan',
      'location': 'Vietnam',
      'details':
          'Ho Chi Minh City, Đồng Nai, Bình Dương, Bình Phước, Bà Rịa–Vũng Tàu, Tây Ninh, Tiền Giang, Long An',
      'distance': '10.5 km',
    },
    {
      'title': 'Mekong Delta Region',
      'location': 'Vietnam',
      'distance': '135.9 km',
    },
    {
      'title': 'Bao Loc',
      'location': 'Vietnam',
      'distance': '141 km',
    },
    {
      'title': 'Phan Thiet',
      'location': 'Vietnam',
      'distance': '172.3 km',
    },
    {
      'title': 'Phnom Penh',
      'location': 'Cambodia',
      'distance': '208.6 km',
    },
    {
      'title': 'Da Lat',
      'location': 'Vietnam',
      'distance': '226.4 km',
    },
    {
      'title': 'Buon Ma Thuot',
      'location': 'Vietnam - Dak Lak',
      'distance': '244.4 km',
    },
  ];

  List<Map<String, String>> _filteredCommunities = [];
  String _searchQuery = '';
  int? _selectedCommunityIndex;
  void _onCommunitySelected(int index) {
    setState(() {
      _selectedCommunityIndex = index;
    });
  }

  void _goToSportSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SportSelectionScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _filteredCommunities = _communities; // Hiển thị tất cả ban đầu
  }

  void _filterCommunities(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredCommunities = _communities.where((community) {
        final title = community['title']?.toLowerCase() ?? '';
        final location = community['location']?.toLowerCase() ?? '';
        return title.contains(_searchQuery) || location.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tham gia một cộng đồng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Những cộng đồng này là địa điểm trung tâm, nơi tập hợp những người chơi thể thao',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterCommunities,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                  itemCount: _filteredCommunities.length,
                  itemBuilder: (context, index) {
                    final community = _filteredCommunities[index];
                    final isSelected = _selectedCommunityIndex == index;
                    return GestureDetector(
                      onTap: () => _onCommunitySelected(index),
                      child: Card(
                        color: isSelected ? Colors.blue.shade50 : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                community['title'] ?? 'Không có tiêu đề',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.blue : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                community['location'] ?? 'Không có vị trí',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected ? Colors.blue : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                community['details'] ?? 'Không có chi tiết',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected ? Colors.blue : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                community['distance'] ?? 'Không có khoảng cách',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isSelected ? Colors.blue : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            if (_selectedCommunityIndex != null)
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: _goToSportSelection,
                  child: const Icon(Icons.arrow_forward),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityCard({
    required String title,
    required String location,
    String? details,
    required String distance,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 4),
            Text(
              location,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            if (details != null) ...[
              const SizedBox(height: 4),
              Text(
                details,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              distance,
              style: const TextStyle(fontSize: 14, color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
