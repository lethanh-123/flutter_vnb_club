import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:dvhcvn/dvhcvn.dart';
import 'dart:math' show min, max;
import 'filter_court_screen.dart';
import 'court_detail_screen.dart';
import 'court.dart';

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
  List<Court> filteredCourts = [];
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  // Vị trí mặc định (trung tâm TPHCM)
  static const LatLng _center = LatLng(10.7769, 106.7009);
  Set<CourtType> selectedCourtTypes = {};
  // Danh sách các sân
  final List<Court> courts = [
    Court(
      id: '1',
      name: 'Pickle Ball Vinaprint',
      address:
          '252 Nguyễn Văn Lượng, Phường 17, Quận Gò Vấp, Thành phố Hồ Chí Minh',
      phone: '0123456789',
      latLng: const LatLng(10.8437, 106.6735),
      type: CourtType.pickleball,
      logo: 'assets/vina.png',
      distance: '1.1km',
      rating: 5,
      images: ['assets/vina.png', 'assets/court1.jpg', 'assets/court2.jpg'],
    ),
    Court(
      id: '2',
      name: 'RiverSide PickleBall',
      address:
          '213/6B Đường số 28, Phường 6, Quận Gò Vấp, Thành phố Hồ Chí Minh',
      phone: '0123456788',
      latLng: const LatLng(10.8392, 106.6658),
      type: CourtType.pickleball,
      logo: 'assets/rv.jpg',
      distance: '1.2km',
      rating: 5,
      images: ['assets/rv.jpg', 'assets/court3.jpg', 'assets/court4.jpg'],
    ),
    Court(
      id: '3',
      name: 'Be Badminton',
      address:
          '262/1 Quang Trung, Phường 10, Quận Gò Vấp, Thành phố Hồ Chí Minh',
      phone: '0123456787',
      latLng: const LatLng(10.8312, 106.6589),
      type: CourtType.badminton,
      logo: 'assets/rv.jpg',
      distance: '1.4km',
      rating: 5,
      images: ['assets/rv.jpg', 'assets/court5.jpg', 'assets/court6.jpg'],
    ),
    Court(
      id: '4',
      name: 'Liber Pickleball',
      address:
          '235/50/31 Đặng Thùy Trâm, Phường 13, Quận Bình Thạnh, Thành phố Hồ Chí Minh',
      phone: '0123456786',
      latLng: const LatLng(10.8156, 106.7145),
      type: CourtType.pickleball,
      logo: 'assets/vina.png',
      distance: '1.7km',
      rating: 5,
      images: ['assets/vina.png', 'assets/court7.jpg', 'assets/court8.jpg'],
    ),
    Court(
      id: '5',
      name: 'ALP Pickleball & Coffee',
      address:
          '235/1G An Phú Đông 09, Phường An Phú Đông, Quận 12, Thành phố Hồ Chí Minh',
      phone: '0123456785',
      latLng: const LatLng(10.8723, 106.6998),
      type: CourtType.pickleball,
      logo: 'assets/rv.jpg',
      distance: '1.8km',
      rating: 5,
      images: ['assets/rv.jpg', 'assets/court9.jpg', 'assets/court10.jpg'],
    ),
    Court(
      id: '6',
      name: 'Tennis & Coffee',
      address:
          'An Phú Đông 09, Phường An Phú Đông, Quận 12, Thành phố Hồ Chí Minh',
      phone: '0123456784',
      latLng: const LatLng(10.8723, 106.7210),
      type: CourtType.tennis,
      logo: 'assets/rv.jpg',
      distance: '1.8km',
      rating: 5,
      images: ['assets/rv.jpg', 'assets/court11.jpg', 'assets/court12.jpg'],
    ),
  ];
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            icon: Icons.sports_tennis,
            label: 'Sân pickleball',
            color: Colors.blue,
            type: CourtType.pickleball,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            icon: Icons.sports_handball,
            label: 'Sân cầu lông',
            color: Colors.green,
            type: CourtType.badminton,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            icon: Icons.sports_baseball,
            label: 'Sân tennis',
            color: Colors.red,
            type: CourtType.tennis,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    filteredCourts = courts;
  }

  Widget _buildFullSearchContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tìm kiếm sân',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Tìm kiếm theo tên sân
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Nhập tên sân...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                _filterCourts();
              });
            },
          ),
          const SizedBox(height: 16),

          // Dropdown Tỉnh/Thành phố
          DropdownButtonFormField<Level1>(
            value: selectedProvince,
            decoration: const InputDecoration(
              labelText: 'Tỉnh/Thành phố',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            items: level1s.map((province) {
              return DropdownMenuItem<Level1>(
                value: province,
                child: Text(province.name),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedProvince = newValue;
                selectedDistrict = null;
                selectedWard = null;
              });
            },
          ),
          const SizedBox(height: 16),

          // Dropdown Quận/Huyện
          if (selectedProvince != null)
            DropdownButtonFormField<Level2>(
              value: selectedDistrict,
              decoration: const InputDecoration(
                labelText: 'Quận/Huyện',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: selectedProvince!.children.map((district) {
                return DropdownMenuItem<Level2>(
                  value: district,
                  child: Text(district.name),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedDistrict = newValue;
                  selectedWard = null;
                });
              },
            ),
          if (selectedProvince != null) const SizedBox(height: 16),

          // Dropdown Phường/Xã
          if (selectedDistrict != null)
            DropdownButtonFormField<Level3>(
              value: selectedWard,
              decoration: const InputDecoration(
                labelText: 'Phường/Xã',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: selectedDistrict!.children.map((ward) {
                return DropdownMenuItem<Level3>(
                  value: ward,
                  child: Text(ward.name),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedWard = newValue;
                });
              },
            ),
          if (selectedDistrict != null) const SizedBox(height: 16),

          // Nút Tìm kiếm và Xóa bộ lọc
          if (selectedProvince != null || searchQuery.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _filterCourts();
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Tìm kiếm'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    setState(() {
                      selectedProvince = null;
                      selectedDistrict = null;
                      selectedWard = null;
                      _searchController.clear();
                      searchQuery = '';
                      filteredCourts = courts;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: 'Xóa bộ lọc',
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMapSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nhập tên sân...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterCourts();
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilterCourtScreen(),
                ),
              );
              if (result != null) {
                setState(() {
                  selectedProvince = result['province'];
                  selectedDistrict = result['district'];
                  selectedWard = result['ward'];
                  // Apply other filters...
                  _filterCourts();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nhập tên sân...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  _filterCourts();
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilterCourtScreen(),
                ),
              );
              if (result != null) {
                setState(() {
                  selectedProvince = result['province'];
                  selectedDistrict = result['district'];
                  selectedWard = result['ward'];
                  // Apply other filters...
                  _filterCourts();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  // Hàm lọc sân theo địa chỉ đã chọn
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

        // Chỉ áp dụng điều kiện theo cấp độ đã chọn
        if (selectedWard != null) {
          return matchProvince && matchDistrict && matchWard;
        } else if (selectedDistrict != null) {
          return matchProvince && matchDistrict;
        } else {
          return matchProvince;
        }
      }).toList();

      // Di chuyển bản đồ đến khu vực được chọn
      if (_selectedIndex == 0 && filteredCourts.isNotEmpty) {
        if (selectedWard != null) {
          mapController.move(filteredCourts.first.latLng, 15);
        } else if (selectedDistrict != null) {
          mapController.move(filteredCourts.first.latLng, 13);
        } else if (selectedProvince != null) {
          mapController.move(filteredCourts.first.latLng, 11);
        }
      }
    });
  }

  // Cập nhật hàm lọc sân để kết hợp cả tìm theo tên và địa chỉ
  void _filterCourts() {
    setState(() {
      filteredCourts = courts.where((court) {
        // Lọc theo tên sân
        bool matchName = searchQuery.isEmpty ||
            court.name.toLowerCase().contains(searchQuery.toLowerCase());

        // Lọc theo loại sân
        bool matchType = selectedCourtTypes.isEmpty ||
            selectedCourtTypes.contains(court.type);

        if (_selectedIndex == 0) {
          // Tab Bản đồ: lọc theo tên và loại sân
          return matchName && matchType;
        } else {
          // Tab Danh sách: lọc theo tên và địa chỉ
          String address = court.address.toLowerCase();
          bool matchProvince = selectedProvince == null ||
              address.contains(selectedProvince!.name.toLowerCase());
          bool matchDistrict = selectedDistrict == null ||
              address.contains(selectedDistrict!.name.toLowerCase());
          bool matchWard = selectedWard == null ||
              address.contains(selectedWard!.name.toLowerCase());

          if (selectedWard != null) {
            return matchName && matchProvince && matchDistrict && matchWard;
          } else if (selectedDistrict != null) {
            return matchName && matchProvince && matchDistrict;
          } else if (selectedProvince != null) {
            return matchName && matchProvince;
          } else {
            return matchName;
          }
        }
      }).toList();

      // Di chuyển bản đồ khi ở tab Bản đồ và có kết quả lọc
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

          double zoomLevel = 12;
          if (maxDiff > 0.1) zoomLevel = 11;
          if (maxDiff > 0.2) zoomLevel = 10;
          if (maxDiff < 0.05) zoomLevel = 13;
          if (maxDiff < 0.02) zoomLevel = 14;
          if (maxDiff < 0.01) zoomLevel = 15;

          mapController.move(LatLng(centerLat, centerLng), zoomLevel);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sân'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Search bar with filter chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Hiển thị thanh tìm kiếm tương ứng với tab
                _selectedIndex == 0
                    ? _buildMapSearchBar()
                    : _buildListSearchBar(),
                const SizedBox(height: 16),

                // Chỉ hiển thị filter chips ở tab Bản đồ
                if (_selectedIndex == 0) _buildFilterChips(),

                if (searchQuery.isNotEmpty || selectedCourtTypes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tìm thấy ${filteredCourts.length} sân',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Map hoặc List view
          Expanded(
            child: _selectedIndex == 0
                ? FlutterMap(
                    mapController: mapController,
                    options: const MapOptions(
                      initialCenter: _center,
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      MarkerLayer(
                        markers: filteredCourts.map((court) {
                          return Marker(
                            point: court.latLng,
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => _buildCourtInfo(court),
                                );
                              },
                              child: Icon(
                                _getMarkerIcon(court.type),
                                color: _getMarkerColor(court.type),
                                size: 40,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                : _buildCourtList(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFilterChip({
    required IconData icon,
    required String label,
    required Color color,
    required CourtType type,
  }) {
    bool isSelected = selectedCourtTypes.contains(type);

    return FilterChip(
      avatar: Icon(icon, color: isSelected ? Colors.white : color, size: 18),
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
      selected: isSelected,
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
      backgroundColor: Colors.white,
      selectedColor: color,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color),
      ),
    );
  }

  Widget _buildCourtList() {
    return ListView.builder(
      itemCount: filteredCourts.length,
      itemBuilder: (context, index) {
        final court = filteredCourts[index];
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
              // Logo
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(court.logo),
              ),
              const SizedBox(width: 12),

              // Court info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      court.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(${court.distance}) ${court.address}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        court.rating,
                        (index) => const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.map_outlined), // Thay đổi icon
                    color: Colors.green, // Đổi màu thành xanh lá
                    onPressed: () {
                      // Chuyển sang tab bản đồ và di chuyển đến vị trí sân
                      setState(() {
                        _selectedIndex = 0; // Chuyển sang tab bản đồ
                      });
                      // Di chuyển bản đồ đến vị trí của sân
                      mapController.move(court.latLng, 15);

                      // Tùy chọn: Mở bottom sheet thông tin sân
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _buildCourtInfo(court),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourtDetailScreen(court: court),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('ĐẶT LỊCH'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCourtInfo(Court court) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(court.logo),
              ),
              const SizedBox(width: 12),
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
                    Text(
                      court.address,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                _getMarkerIcon(court.type),
                color: _getMarkerColor(court.type),
              ),
              const SizedBox(width: 8),
              Text(_getCourtTypeName(court.type)),
              const Spacer(),
              ...List.generate(
                court.rating,
                (index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('ĐẶT LỊCH'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.white,
      backgroundColor: Colors.green,
      type: BottomNavigationBarType.fixed,
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
    );
  }

  IconData _getMarkerIcon(CourtType type) {
    switch (type) {
      case CourtType.pickleball:
        return Icons.sports_tennis;
      case CourtType.badminton:
        return Icons.sports_handball;
      case CourtType.tennis:
        return Icons.sports_baseball;
    }
  }

  Color _getMarkerColor(CourtType type) {
    switch (type) {
      case CourtType.pickleball:
        return Colors.blue;
      case CourtType.badminton:
        return Colors.green;
      case CourtType.tennis:
        return Colors.red;
    }
  }

  String _getCourtTypeName(CourtType type) {
    switch (type) {
      case CourtType.pickleball:
        return 'Sân pickleball';
      case CourtType.badminton:
        return 'Sân cầu lông';
      case CourtType.tennis:
        return 'Sân tennis';
    }
  }
}


