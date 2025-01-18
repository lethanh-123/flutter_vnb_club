import 'court.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String createdAt;
  final String? lastLogin;
  final List<Booking>? bookings;
  final List<Court>? courts;
  bool isActive;
  final String phone;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.phone,
    this.lastLogin,
    this.bookings,
    this.courts,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      role: json['role'],
      createdAt: json['created_at'],
      lastLogin: json['last_login'],
      phone: json['phone'],
      bookings: json['bookings'] != null
          ? (json['bookings'] as List).map((b) => Booking.fromJson(b)).toList()
          : null,
      courts: json['courts'] != null && json['courts'] is List
          ? (json['courts'] as List).map((c) => Court.fromJson(c)).toList()
          : null,
    );
  }

  String getRoleName() {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'court_owner':
        return 'Chủ sân';
      case 'staff':
        return 'Nhân viên';
      case 'customer':
        return 'Khách hàng';
      default:
        return 'Unknown';
    }
  }

  Color getRoleColor() {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'court_owner':
        return Colors.green;
      case 'staff':
        return Colors.blue;
      case 'customer':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
