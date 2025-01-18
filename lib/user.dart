import 'package:flutter/material.dart';
import 'court.dart';
import 'booking.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String createdAt;
  final String? lastLogin;
  final List<Booking>? bookings;
  final List<Court>? courts;
  final String? phone;
  bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    this.lastLogin,
    this.bookings,
    this.courts,
    this.phone,
    this.isActive = true,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Parse bookings với null safety
    List<Booking>? parseBookings(dynamic bookings) {
      if (bookings == null) return null;
      if (bookings is List) {
        try {
          return bookings.map((b) => Booking.fromJson(b)).toList();
        } catch (e) {
          print('Error parsing bookings: $e');
          return null;
        }
      }
      return null;
    }

    // Parse courts với null safety
    List<Court>? parseCourts(dynamic courts) {
      if (courts == null) return null;
      if (courts is List) {
        try {
          return courts.map((c) => Court.fromJson(c)).toList();
        } catch (e) {
          print('Error parsing courts: $e');
          return null;
        }
      }
      return null;
    }

    return User(
      id: json['id']?.toString() ?? '0',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'customer',
      createdAt: json['created_at']?.toString() ?? '',
      lastLogin: json['last_login']?.toString(),
      phone: json['phone']?.toString(),
      bookings: parseBookings(json['bookings']),
      courts: parseCourts(json['courts']),
      isActive: json['is_active'] ?? true,
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

  // Helper method để format ngày giờ
  String formatDateTime(String? dateTime) {
    if (dateTime == null) return 'N/A';
    try {
      final dt = DateTime.parse(dateTime);
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}';
    } catch (e) {
      return dateTime;
    }
  }

  // Getter cho formatted dates
  String get formattedCreatedAt => formatDateTime(createdAt);
  String get formattedLastLogin => formatDateTime(lastLogin);

  // Kiểm tra xem user có active trong 24h gần đây không
  bool get isRecentlyActive {
    if (lastLogin == null) return false;
    try {
      final lastLoginDate = DateTime.parse(lastLogin!);
      final now = DateTime.now();
      return now.difference(lastLoginDate).inHours < 24;
    } catch (e) {
      return false;
    }
  }
}