import 'package:flutter/material.dart';

class LocationListScreen extends StatelessWidget {
  const LocationListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHỌN ĐỊA ĐIỂM'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Sân Tennis Phú Thọ'),
            subtitle: const Text('219 Lý Thường Kiệt, P.15, Q.11'),
            onTap: () {
              Navigator.pop(context, 'Sân Tennis Phú Thọ');
            },
          ),
          ListTile(
            title: const Text('Sân Tennis Hoa Lư'),
            subtitle: const Text('2 Đinh Tiên Hoàng, Đa Kao, Q.1'),
            onTap: () {
              Navigator.pop(context, 'Sân Tennis Hoa Lư');
            },
          ),
          // Thêm các địa điểm khác
        ],
      ),
    );
  }
}