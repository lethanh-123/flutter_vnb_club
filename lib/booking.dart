import 'package:flutter/material.dart';

class Booking {
  final int id;
  final int courtId;
  final int userId;
  final String date;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final String status;
  final String paymentStatus;
  final String? notes;
  final String createdAt;
  final String updatedAt;

  Booking({
    required this.id,
    required this.courtId,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      courtId: json['court_id'],
      userId: json['user_id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      totalPrice: json['total_price'].toDouble(),
      status: json['status'],
      paymentStatus: json['payment_status'],
      notes: json['notes'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  String getStatusName() {
    switch (status) {
      case 'confirmed':
        return 'Đã xác nhận';
      case 'pending':
        return 'Chờ xác nhận';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return 'Unknown';
    }
  }

  Color getStatusColor() {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getPaymentStatusName() {
    switch (paymentStatus) {
      case 'paid':
        return 'Đã thanh toán';
      case 'unpaid':
        return 'Chưa thanh toán';
      default:
        return 'Unknown';
    }
  }

  Color getPaymentStatusColor() {
    switch (paymentStatus) {
      case 'paid':
        return Colors.green;
      case 'unpaid':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
