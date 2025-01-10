import 'package:latlong2/latlong.dart';

class Court {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String logo;
  final String distance;
  final int rating;
  final LatLng latLng;
  final String openTime;
  final String closeTime;
  final bool isConnected;
  final List<String> images;
  final CourtType type;

  Court({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.logo,
    required this.distance,
    required this.rating,
    required this.latLng,
    this.openTime = '05:00',
    this.closeTime = '22:00',
    this.isConnected = true,
    required this.images,
    required this.type,
  });
}

enum CourtType {
  pickleball,
  badminton,
  tennis,
}