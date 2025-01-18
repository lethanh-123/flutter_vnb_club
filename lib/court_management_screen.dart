import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dvhcvn/dvhcvn.dart';
import 'dart:math' show min, max;
import 'filter_court_screen.dart';
import 'court_detail_screen.dart';
import 'court.dart';
import 'api_service.dart';

class CourtManagementScreen extends StatefulWidget {
  const CourtManagementScreen({Key? key}) : super(key: key);

  @override
  State<CourtManagementScreen> createState() => _CourtManagementScreenState();
}

class _CourtManagementScreenState extends State<CourtManagementScreen> {
  int _selectedIndex = 0;
  final MapController mapController = MapController();
  Level1? selectedProvince;
  Level2? selectedDistrict;
  Level3? selectedWard;
  List<Court> courts = [];
  List<Court> filteredCourts = [];
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  static const LatLng _center = LatLng(10.7769, 106.7009);
  Set<String> selectedCourtTypes = {};
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchCourts();
  }

  Future<void> _fetchCourts() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedCourts = await ApiService.fetchCourts();
      setState(() {
        courts = fetchedCourts;
        filteredCourts = courts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _filterCourts() {
    setState(() {
      filteredCourts = courts.where((court) {
        bool matchName = searchQuery.isEmpty ||
            court.name.toLowerCase().contains(searchQuery.toLowerCase());
        bool matchType = selectedCourtTypes.isEmpty ||
            selectedCourtTypes.contains(court.type);

        if (_selectedIndex == 0) {
          return matchName && matchType;
        } else {
          String address = court.address.toLowerCase();
          bool matchProvince = selectedProvince == null ||
              address.contains(selectedProvince!.name.toLowerCase());
          bool matchDistrict = selectedDistrict == null ||
              address.contains(selectedDistrict!.name.toLowerCase());
          bool matchWard = selectedWard == null ||
              address.contains(selectedWard!.name.toLowerCase());

          if (selectedWard != null) {
            return matchName &&
                matchType &&
                matchProvince &&
                matchDistrict &&
                matchWard;
          } else if (selectedDistrict != null) {
            return matchName && matchType && matchProvince && matchDistrict;
          } else if (selectedProvince != null) {
            return matchName && matchType && matchProvince;
          } else {
            return matchName && matchType;
          }
        }
      }).toList();

      _updateMapView();
    });
  }

  void _updateMapView() {
    if (_selectedIndex == 0 && filteredCourts.isNotEmpty) {
      if (filteredCourts.length == 1) {
        mapController.move(filteredCourts.first.latLng, 15);
      } else {
        double minLat =
            filteredCourts.map((c) => c.latLng.latitude).reduce(min);
        double maxLat =
            filteredCourts.map((c) => c.latLng.latitude).reduce(max);
        double minLng =
            filteredCourts.map((c) => c.latLng.longitude).reduce(min);
        double maxLng =
            filteredCourts.map((c) => c.latLng.longitude).reduce(max);

        double centerLat = (minLat + maxLat) / 2;
        double centerLng = (minLng + maxLng) / 2;

        double latDiff = maxLat - minLat;
        double lngDiff = maxLng - minLng;
        double maxDiff = max(latDiff, lngDiff);

        double zoomLevel = _calculateZoomLevel(maxDiff);
        mapController.move(LatLng(centerLat, centerLng), zoomLevel);
      }
    }
  }

  double _calculateZoomLevel(double maxDiff) {
    if (maxDiff > 0.2) return 10;
    if (maxDiff > 0.1) return 11;
    if (maxDiff > 0.05) return 12;
    if (maxDiff > 0.02) return 13;
    if (maxDiff > 0.01) return 14;
    return 15;
  }

  // Cập nhật phần xử lý kết quả từ FilterCourtScreen
  void _handleFilterResult(Map<String, dynamic>? result) {
    if (result != null) {
      setState(() {
        selectedCourtTypes = (result['types'] as Set<String>?) ?? {};
        selectedProvince = result['province'] as Level1?;
        selectedDistrict = result['district'] as Level2?;
        selectedWard = result['ward'] as Level3?;

        // Áp dụng cả hai bộ lọc
        _filterCourtsByLocation();
        _filterCourts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm sân'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => FilterCourtScreen(
                    selectedTypes: selectedCourtTypes,
                    selectedProvince: selectedProvince,
                    selectedDistrict: selectedDistrict,
                    selectedWard: selectedWard,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  selectedCourtTypes = (result['types'] as Set<String>?) ?? {};
                  selectedProvince = result['province'] as Level1?;
                  selectedDistrict = result['district'] as Level2?;
                  selectedWard = result['ward'] as Level3?;
                  _filterCourts();
                });
              }
              _handleFilterResult(result);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sân...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            searchQuery = '';
                            _filterCourts();
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterCourts();
                });
              },
            ),
          ),

          // Court type filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip(
                  icon: Icons.sports_tennis,
                  label: 'Pickleball',
                  color: Colors.blue,
                  type: 'pickleball',
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  icon: Icons.sports_handball,
                  label: 'Cầu lông',
                  color: Colors.green,
                  type: 'badminton',
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  icon: Icons.sports_baseball,
                  label: 'Tennis',
                  color: Colors.red,
                  type: 'tennis',
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(child: Text('Error: $error'))
                    : _selectedIndex == 0
                        ? _buildMap()
                        : _buildListView(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Bản đồ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Danh sách',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required Color color,
    required String type,
  }) {
    final isSelected = selectedCourtTypes.contains(type);
    return FilterChip(
      avatar: Icon(icon, color: isSelected ? Colors.white : color),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: Colors.white,
      onSelected: (bool selected) {
        setState(() {
          if (selected) {
            selectedCourtTypes.add(type);
          } else {
            selectedCourtTypes.remove(type);
          }
          _filterCourts();
        });
      },
    );
  }

  void _filterCourtsByLocation() {
    setState(() {
      filteredCourts = courts.where((court) {
        String address = court.address.toLowerCase();

        bool matchProvince = selectedProvince == null ||
            address.contains(selectedProvince!.name.toLowerCase());
        bool matchDistrict = selectedDistrict == null ||
            address.contains(selectedDistrict!.name.toLowerCase());
        bool matchWard = selectedWard == null ||
            address.contains(selectedWard!.name.toLowerCase());

        if (selectedWard != null) {
          return matchProvince && matchDistrict && matchWard;
        } else if (selectedDistrict != null) {
          return matchProvince && matchDistrict;
        } else {
          return matchProvince;
        }
      }).toList();

      _moveMapToFilteredCourts();
    });
  }

  void _moveMapToFilteredCourts() {
    if (_selectedIndex == 0 && filteredCourts.isNotEmpty) {
      if (selectedWard != null) {
        mapController.move(filteredCourts.first.latLng, 15);
      } else if (selectedDistrict != null) {
        mapController.move(filteredCourts.first.latLng, 13);
      } else if (selectedProvince != null) {
        mapController.move(filteredCourts.first.latLng, 11);
      }
    }
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(
        initialCenter: _center, // Thay vì center
        initialZoom: 13, // Thay vì zoom
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: filteredCourts.map((court) {
            return Marker(
              point: court.latLng,
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showCourtInfo(context, court),
                child: Icon(
                  court.getCourtTypeIcon(),
                  color: court.getCourtTypeColor(),
                  size: 30,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (filteredCourts.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy sân phù hợp'),
      );
    }

    return ListView.builder(
      itemCount: filteredCourts.length,
      itemBuilder: (context, index) {
        final court = filteredCourts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(court.logoUrl),
              backgroundColor: Colors.grey[200],
            ),
            title: Text(
              court.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(court.address),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      court.getCourtTypeIcon(),
                      size: 16,
                      color: court.getCourtTypeColor(),
                    ),
                    const SizedBox(width: 4),
                    Text(court.getCourtTypeName()),
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${court.pricePerHour.toStringAsFixed(0)}đ/giờ',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (court.isOpenNow())
                  const Text(
                    'Đang mở cửa',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  )
                else
                  const Text(
                    'Đã đóng cửa',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourtDetailScreen(court: court),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCourtInfo(BuildContext context, Court court) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(court.logoUrl),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        court.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(court.address),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          court.getCourtTypeIcon(),
                          color: court.getCourtTypeColor(),
                        ),
                        const SizedBox(width: 8),
                        Text(court.getCourtTypeName()),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${court.pricePerHour.toStringAsFixed(0)}đ/giờ',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourtDetailScreen(court: court),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Xem chi tiết'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
