import 'package:flutter/material.dart';
import 'api_service.dart';
import 'court.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({Key? key}) : super(key: key);

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  List<Court> locations = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      final fetchedLocations = await ApiService.fetchLocations();
      setState(() {
        locations = fetchedLocations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải danh sách địa điểm: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: const InputDecoration(
              hintText: 'Tìm kiếm',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ...locations
                    .where((location) => location.name
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase()))
                    .map((location) => _buildLocationTile(location)),
                _buildMapOption(),
              ],
            ),
    );
  }

  Widget _buildLocationTile(Court location) {
    return ListTile(
      leading: const Icon(
        Icons.location_on,
        color: Colors.blue,
        size: 30,
      ),
      title: Text(
        location.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        location.address,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.pop(context, location);
      },
    );
  }

  Widget _buildMapOption() {
    return ListTile(
      leading: const Icon(
        Icons.map_outlined,
        color: Colors.blue,
        size: 30,
      ),
      title: const Text(
        'Chọn địa điểm trên bản đồ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: () {
        // Xử lý khi chọn bản đồ
      },
    );
  }
}
