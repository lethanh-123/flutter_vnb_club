import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'booking.dart';

class Court {
  final int id;
  final String name;
  final String address;
  final LatLng latLng;
  final double pricePerHour;
  final String type;
  final String phone;
  final String? email;
  final String? website;
  final String? description;
  final String logoUrl;
  final List<String> images;
  final double rating;
  final int totalReviews;
  final List<String> amenities;
  final Map<String, dynamic> openingHours;
  final bool isVerified;
  final String status;
  final String? cancellationPolicy;
  final String? rules;
  final int minBookingTime;
  final int maxBookingTime;
  final List<SpecialHour> specialHours;
  final List<Booking> todayBookings;
  final String location;
  final int sportId;
  Schedule? currentSchedule;
  Court({
    required this.id,
    required this.name,
    required this.address,
    required this.latLng,
    required this.pricePerHour,
    required this.type,
    required this.phone,
    this.email,
    this.website,
    this.description,
    required this.logoUrl,
    required this.images,
    required this.rating,
    required this.totalReviews,
    required this.amenities,
    required this.openingHours,
    required this.isVerified,
    required this.status,
    this.cancellationPolicy,
    this.rules,
    required this.minBookingTime,
    required this.maxBookingTime,
    required this.specialHours,
    required this.todayBookings,
    required this.location,
    required this.sportId,
    this.currentSchedule,
  });

  factory Court.fromJson(Map<String, dynamic> json) {
    // Parse location string "(lat,lng)" to LatLng
    LatLng parseLocation(String? locationStr) {
      if (locationStr == null) return const LatLng(0, 0);
      try {
        final coords = locationStr
            .replaceAll('(', '')
            .replaceAll(')', '')
            .split(',')
            .map((e) => double.tryParse(e.trim()) ?? 0)
            .toList();
        return LatLng(coords[0], coords[1]);
      } catch (e) {
        return const LatLng(0, 0);
      }
    }

    // Parse images with null safety
    List<String> parseImages(dynamic images) {
      if (images == null) return [];
      if (images is List) {
        return images.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Parse amenities with null safety
    List<String> parseAmenities(dynamic amenities) {
      if (amenities == null) return [];
      if (amenities is List) {
        return amenities.map((e) => e.toString()).toList();
      }
      return [];
    }

    // Parse special hours with null safety
    List<SpecialHour> parseSpecialHours(dynamic specialHours) {
      if (specialHours == null) return [];
      if (specialHours is List) {
        return specialHours.map((h) => SpecialHour.fromJson(h)).toList();
      }
      return [];
    }

    // Parse today bookings with null safety
    List<Booking> parseBookings(dynamic bookings) {
      if (bookings == null) return [];
      if (bookings is List) {
        return bookings.map((b) => Booking.fromJson(b)).toList();
      }
      return [];
    }

    // Parse currentSchedule từ today_bookings
    Schedule? parseCurrentSchedule(List<Booking> bookings) {
      if (bookings.isEmpty) return null;

      final now = DateTime.now();
      final currentBooking = bookings.firstWhere(
        (booking) {
          final start = DateTime.parse(booking.startTime);
          final end = DateTime.parse(booking.endTime);
          return now.isAfter(start) && now.isBefore(end);
        },
        orElse: () => null as Booking,
      );

      if (currentBooking != null) {
        return Schedule(
          customerName: currentBooking
              .customerName, // Bây giờ có thể truy cập customerName
          startTime: currentBooking.startTime,
          endTime: currentBooking.endTime,
        );
      }
      return null;
    }

    final todayBookings = parseBookings(json['today_bookings']);
    return Court(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      location: json['location'] ?? '',
      sportId: json['sport_id'] ?? 0,
      latLng: parseLocation(json['location']?.toString()),
      pricePerHour: (json['price_per_hour'] ?? 0).toDouble(),
      type: json['type'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      website: json['website'],
      description: json['description'],
      logoUrl: json['logo_url'] ?? '',
      images: parseImages(json['images']),
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      amenities: parseAmenities(json['amenities']),
      openingHours: json['opening_hours'] is Map ? json['opening_hours'] : {},
      isVerified: json['is_verified'] ?? false,
      status: json['status'] ?? 'unavailable',
      cancellationPolicy: json['cancellation_policy'],
      rules: json['rules'],
      minBookingTime: json['min_booking_time'] ?? 60,
      maxBookingTime: json['max_booking_time'] ?? 180,
      specialHours: parseSpecialHours(json['special_hours']),
      todayBookings: parseBookings(json['today_bookings']),
      currentSchedule: parseCurrentSchedule(todayBookings),
    );
  }

  String getCourtTypeName() {
    switch (type) {
      case 'pickleball':
        return 'Sân pickleball';
      case 'badminton':
        return 'Sân cầu lông';
      case 'tennis':
        return 'Sân tennis';
      default:
        return 'Sân không xác định';
    }
  }

  IconData getCourtTypeIcon() {
    switch (type) {
      case 'pickleball':
        return Icons.sports_tennis;
      case 'badminton':
        return Icons.sports_handball;
      case 'tennis':
        return Icons.sports_baseball;
      default:
        return Icons.sports;
    }
  }

  Color getCourtTypeColor() {
    switch (type) {
      case 'pickleball':
        return Colors.blue;
      case 'badminton':
        return Colors.green;
      case 'tennis':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String formatPrice() {
    return '${pricePerHour.toStringAsFixed(0)}đ/giờ';
  }

  bool isOpenNow() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    String day;
    switch (dayOfWeek) {
      case 1:
        day = 'mon';
        break;
      case 2:
        day = 'tue';
        break;
      case 3:
        day = 'wed';
        break;
      case 4:
        day = 'thu';
        break;
      case 5:
        day = 'fri';
        break;
      case 6:
        day = 'sat';
        break;
      case 7:
        day = 'sun';
        break;
      default:
        return false;
    }

    if (!openingHours.containsKey(day)) return false;

    final hours = openingHours[day];
    return currentTime.compareTo(hours['open']) >= 0 &&
        currentTime.compareTo(hours['close']) <= 0;
  }

  SpecialHour? getCurrentSpecialHour() {
    final now = DateTime.now();
    final currentTime =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:00';
    final dayOfWeek = now.weekday;

    return specialHours.firstWhere(
      (hour) =>
          hour.daysOfWeek.contains(dayOfWeek) &&
          currentTime.compareTo(hour.startTime) >= 0 &&
          currentTime.compareTo(hour.endTime) <= 0,
      orElse: () => null as SpecialHour,
    );
  }

  double getCurrentPrice() {
    final specialHour = getCurrentSpecialHour();
    if (specialHour != null) {
      return pricePerHour * specialHour.priceMultiplier;
    }
    return pricePerHour;
  }
}

class SpecialHour {
  final int id;
  final String name;
  final String startTime;
  final String endTime;
  final double priceMultiplier;
  final List<int> daysOfWeek;

  SpecialHour({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.priceMultiplier,
    required this.daysOfWeek,
  });

  factory SpecialHour.fromJson(Map<String, dynamic> json) {
    return SpecialHour(
      id: json['id'],
      name: json['name'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      priceMultiplier: json['price_multiplier'].toDouble(),
      daysOfWeek: List<int>.from(json['days_of_week']),
    );
  }

  String getFormattedTime() {
    return '$startTime - $endTime';
  }

  String getFormattedPrice(double basePrice) {
    final price = basePrice * priceMultiplier;
    return '${price.toStringAsFixed(0)}đ/giờ';
  }
}

class Schedule {
  final String? customerName;
  final String startTime;
  final String endTime;

  Schedule({
    this.customerName,
    required this.startTime,
    required this.endTime,
  });
}

// class Booking {
//   final String startTime;
//   final String endTime;
//   final String status;

//   Booking({
//     required this.startTime,
//     required this.endTime,
//     required this.status,
//   });

//   factory Booking.fromJson(Map<String, dynamic> json) {
//     return Booking(
//       startTime: json['start_time'],
//       endTime: json['end_time'],
//       status: json['status'],
//     );
//   }

//   String getFormattedTime() {
//     return '$startTime - $endTime';
//   }

//   bool isOverlapping(String checkStartTime, String checkEndTime) {
//     return startTime.compareTo(checkEndTime) < 0 &&
//         endTime.compareTo(checkStartTime) > 0;
//   }
// }