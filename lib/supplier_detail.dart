import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vnb_ios/api_service.dart';
import 'preferences.dart';
import 'dart:convert';
import 'supplier.dart';

class SupplierDetailScreen extends StatelessWidget {
  final Supplier supplier;

  SupplierDetailScreen({required this.supplier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(supplier.name),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã số: ${supplier.code}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Số điện thoại: ${supplier.phone}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
