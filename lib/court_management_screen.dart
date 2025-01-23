import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dvhcvn/dvhcvn.dart';
import 'dart:math' show min, max;
import 'filter_court_screen.dart';
import 'court_detail_screen.dart';
import 'court.dart';
import 'api_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'daily_stat.dart';
import 'court_popularity.dart';
import 'court_service.dart';

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
  int occupiedCourts = 3;
  int totalCourts = 12;
  double occupancyRate = 25; // 25%
  double revenue = 793.54; // triệu
  int totalBookings = 95;
  int inventory = 1000164;
  double inventoryValue = 18903091000;

  Map<String, dynamic>? statsData;
  List<Map<String, dynamic>> topCourts = [
    {
      'name': 'Sân 01 cho 2 người',
      'price': 180000,
      'image': 'assets/court1.jpg',
    },
    {
      'name': 'Sân 02 cho 2 người',
      'price': 190000,
      'image': 'assets/court1.jpg',
    }
    // Thêm các sân khác...
  ];
  // Thêm các biến state để lưu dữ liệu thống kê
  List<DailyStats> dailyStats = [];
  List<CourtPopularity> topCourtsByRevenue = [];
  List<CourtPopularity> topCourtsByBookings = [];

  @override
  void initState() {
    super.initState();
    _fetchCourts();
    _loadStats();
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

  Future<void> _loadStats() async {
    try {
      setState(() => isLoading = true);

      final data = await ApiService.getCourtStats();

      setState(() {
        statsData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  final List<double> revenueData = [
    20, // 17
    30, // 18
    150, // 19
    170, // 20
    220, // 21
    180, // 22
  ];

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 250,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                // Sử dụng trực tiếp meta được truyền vào
                const style = TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = '17/1';
                    break;
                  case 1:
                    text = '18/1';
                    break;
                  case 2:
                    text = '19/1';
                    break;
                  case 3:
                    text = '20/1';
                    break;
                  case 4:
                    text = '21/1';
                    break;
                  case 5:
                    text = '22/1';
                    break;
                  case 6:
                    text = '23/1';
                    break;
                  default:
                    text = '';
                    break;
                }
                return SideTitleWidget(
                  // axisSide: meta.axisSide, // Sử dụng meta.axisSide
                  space: 8,
                  child: Text(text, style: style),
                  meta: meta, // Thêm meta vào đây
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text('${value.toInt()}Tr',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ));
              },
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
            left: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        barGroups: revenueData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                color: Colors.green,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
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
          if (_selectedIndex != 0)
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
                    selectedCourtTypes =
                        (result['types'] as Set<String>?) ?? {};
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
          if (_selectedIndex != 0) ...[
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
          ],
          // Main content
          Expanded(
            child: _selectedIndex == 1
                ? _buildMap()
                : _selectedIndex == 2
                    ? _buildListView()
                    : _buildOverview(),
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
            icon: Icon(Icons.dashboard),
            label: 'Tổng quan',
          ),
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

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 20,
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                String text;
                switch (value.toInt()) {
                  case 0:
                    text = '17/1';
                    break;
                  case 1:
                    text = '18/1';
                    break;
                  case 2:
                    text = '19/1';
                    break;
                  case 3:
                    text = '20/1';
                    break;
                  case 4:
                    text = '21/1';
                    break;
                  case 5:
                    text = '22/1';
                    break;
                  case 6:
                    text = '23/1';
                    break;
                  default:
                    text = '';
                    break;
                }
                return SideTitleWidget(
                  // axisSide: meta.axisSide,
                  space: 8,
                  child: Text(text, style: style),
                  meta: meta,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 10,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value == 0) return const Text('');
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
            left: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 100,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 2),
              FlSpot(1, 1),
              FlSpot(2, 1.5),
              FlSpot(3, 2),
              FlSpot(4, 3),
              FlSpot(5, 30),
              FlSpot(6, 28),
            ],
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(
              show: true,
              // getDotPainter: ,
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentStats = statsData?['current_stats'];
    final topCourts = statsData?['top_courts'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thống kê tổng quan
            Row(
              children: [
                _buildStatCard(
                  'Tổng số sân',
                  '${currentStats?['total_courts'] ?? 0}',
                  Icons.sports_tennis,
                  Colors.blue,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Đang sử dụng',
                  '${currentStats?['occupied_courts'] ?? 0}',
                  Icons.event_available,
                  Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(
                  'Tỷ lệ sử dụng',
                  '${currentStats?['occupancy_rate'] ?? 0}%',
                  Icons.pie_chart,
                  Colors.orange,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Doanh thu hôm nay',
                  NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: 'đ',
                    decimalDigits: 0,
                  ).format(currentStats?['total_revenue'] ?? 0),
                  Icons.monetization_on,
                  Colors.purple,
                ),
              ],
            ),

            // Top sân bán chạy
            Card(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Top sân bán chạy',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        const TabBar(
                          labelColor: Colors.green,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(text: 'Theo doanh thu'),
                            Tab(text: 'Theo số lượng'),
                          ],
                        ),
                        SizedBox(
                          height: 400,
                          child: TabBarView(
                            children: [
                              _buildTopCourtsListView(
                                  topCourts?['by_revenue'] ?? []),
                              _buildTopCourtsListView(
                                  topCourts?['by_bookings'] ?? []),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCourtsListView(List<dynamic> courts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: courts.length,
      itemBuilder: (context, index) {
        final court = courts[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              court['image_url'] ?? 'assets/images/default_court.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                  child: const Icon(Icons.sports_tennis),
                );
              },
            ),
          ),
          title: Text(
            court['name'] ?? 'Không có tên',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              Text(' ${(court['rating'] ?? 0.0).toStringAsFixed(1)}'),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberFormat.currency(
                  locale: 'vi_VN',
                  symbol: 'đ',
                  decimalDigits: 0,
                ).format(court['total_revenue'] ?? 0),
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${court['total_bookings'] ?? 0} lượt đặt',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          onTap: () async {
            try {
              final courtDetail =
                  await ApiService.getCourtDetail(court['court_id'] ?? 0);
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourtDetailScreen(court: courtDetail),
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Lỗi: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTopCourtsList(List<dynamic> courts) {
  //   return ListView.builder(
  //     padding: const EdgeInsets.all(0),
  //     itemCount: courts.length,
  //     itemBuilder: (context, index) {
  //       final court = courts[index];
  //       return ListTile(
  //         leading: ClipRRect(
  //           borderRadius: BorderRadius.circular(8),
  //           child: Image.network(
  //             court['image_url'],
  //             width: 50,
  //             height: 50,
  //             fit: BoxFit.cover,
  //             errorBuilder: (context, error, stackTrace) {
  //               return Container(
  //                 width: 50,
  //                 height: 50,
  //                 color: Colors.grey[200],
  //                 child: const Icon(Icons.error),
  //               );
  //             },
  //           ),
  //         ),
  //         title: Text(
  //           court['name'],
  //           style: const TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //         subtitle: Row(
  //           children: [
  //             Icon(Icons.star, size: 16, color: Colors.amber),
  //             Text(' ${court['rating']}'),
  //           ],
  //         ),
  //         trailing: Text(
  //           NumberFormat.currency(
  //             locale: 'vi_VN',
  //             symbol: 'đ',
  //           ).format(court['total_revenue']),
  //           style: const TextStyle(
  //             color: Colors.green,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) =>
  //                   CourtDetailScreen(courtId: court['court_id']),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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
