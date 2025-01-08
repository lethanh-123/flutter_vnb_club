import 'package:flutter/material.dart';

class CourtManagementScreen extends StatelessWidget {
  const CourtManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sân'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Court list
          Expanded(
            child: ListView(
              children: [
                _buildCourtItem(
                  logo: 'assets/court_logos/vinaprint.png',
                  name: 'Pickle Ball Vinaprint',
                  address: '252 Nguyễn Văn Lượng, phường 17, quận Gò Vấp',
                  distance: '1.1km',
                  rating: 5,
                ),
                _buildCourtItem(
                  logo: 'assets/court_logos/riverside.png',
                  name: 'RiverSide PickleBall',
                  address: '213/6B Đường số 28, P.6, Q. Gò Vấp',
                  distance: '1.2km',
                  rating: 5,
                ),
                _buildCourtItem(
                  logo: 'assets/court_logos/be_badminton.png',
                  name: 'Be Badminton',
                  address: '262/1 Quang Trung, P.10, Gò Vấp, TP Hồ Chí Minh',
                  distance: '1.4km',
                  rating: 5,
                ),
                _buildCourtItem(
                  logo: 'assets/court_logos/liber.png',
                  name: 'Liber Pickleball',
                  address: '235/50/31, Đ. Đặng Thùy Trâm, Phường 13, Bình Thạnh',
                  distance: '1.7km',
                  rating: 5,
                ),
                _buildCourtItem(
                  logo: 'assets/court_logos/alp.png',
                  name: 'ALP Pickleball & Coffee',
                  address: '235/1G Đ An Phú Đông 09, An Phú Đông, Quận 12, HCM',
                  distance: '1.8km',
                  rating: 5,
                ),
                _buildCourtItem(
                  logo: 'assets/court_logos/396.png',
                  name: '396 Pickleball',
                  address: '396 Nguyễn Thái Sơn, P.5, Gò Vấp, TP HCM',
                  distance: '2.0km',
                  rating: 5,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Nổi bật',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }

  Widget _buildCourtItem({
    required String logo,
    required String name,
    required String address,
    required String distance,
    required int rating,
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
          // Logo
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(logo),
          ),
          const SizedBox(width: 12),
          
          // Court info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '($distance) $address',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(
                      rating,
                      (index) => const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: Colors.amber,
                onPressed: () {},
              ),
              ElevatedButton(
                onPressed: () {},
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
  }
}