import 'package:intl/intl.dart';
import 'daily_stat.dart';
import 'court_popularity.dart';

class CourtService {
  // static final List<Map<String, dynamic>> _mockCourts = [
  //   {
  //     'id': 1,
  //     'name': 'Sân Pickleball Quận 1',
  //     'image': 'assets/images/court1.jpg',
  //     'type': 'pickleball',
  //     'price': 180000,
  //     'bookings': 156,
  //     'revenue': 28080000,
  //     'rating': 4.8,
  //   },
  //   {
  //     'id': 2,
  //     'name': 'Sân Tennis Phú Nhuận',
  //     'image': 'assets/images/court2.jpg',
  //     'type': 'tennis',
  //     'price': 250000,
  //     'bookings': 142,
  //     'revenue': 35500000,
  //     'rating': 4.7,
  //   },
  //   {
  //     'id': 3,
  //     'name': 'Sân Cầu Lông Tân Bình',
  //     'image': 'assets/images/court3.jpg',
  //     'type': 'badminton',
  //     'price': 120000,
  //     'bookings': 189,
  //     'revenue': 22680000,
  //     'rating': 4.6,
  //   },
  //   {
  //     'id': 4,
  //     'name': 'Sân Pickleball Quận 7',
  //     'image': 'assets/images/court4.jpg',
  //     'type': 'pickleball',
  //     'price': 200000,
  //     'bookings': 134,
  //     'revenue': 26800000,
  //     'rating': 4.5,
  //   },
  //   {
  //     'id': 5,
  //     'name': 'Sân Tennis Bình Thạnh',
  //     'image': 'assets/images/court5.jpg',
  //     'type': 'tennis',
  //     'price': 280000,
  //     'bookings': 121,
  //     'revenue': 33880000,
  //     'rating': 4.9,
  //   },
  //   {
  //     'id': 6,
  //     'name': 'Sân Cầu Lông Gò Vấp',
  //     'image': 'assets/images/court6.jpg',
  //     'type': 'badminton',
  //     'price': 150000,
  //     'bookings': 167,
  //     'revenue': 25050000,
  //     'rating': 4.4,
  //   },
  //   {
  //     'id': 7,
  //     'name': 'Sân Pickleball Quận 3',
  //     'image': 'assets/images/court7.jpg',
  //     'type': 'pickleball',
  //     'price': 190000,
  //     'bookings': 145,
  //     'revenue': 27550000,
  //     'rating': 4.7,
  //   },
  //   {
  //     'id': 8,
  //     'name': 'Sân Tennis Quận 2',
  //     'image': 'assets/images/court8.jpg',
  //     'type': 'tennis',
  //     'price': 260000,
  //     'bookings': 132,
  //     'revenue': 34320000,
  //     'rating': 4.8,
  //   },
  //   {
  //     'id': 9,
  //     'name': 'Sân Cầu Lông Quận 10',
  //     'image': 'assets/images/court9.jpg',
  //     'type': 'badminton',
  //     'price': 130000,
  //     'bookings': 178,
  //     'revenue': 23140000,
  //     'rating': 4.5,
  //   },
  //   {
  //     'id': 10,
  //     'name': 'Sân Pickleball Thủ Đức',
  //     'image': 'assets/images/court10.jpg',
  //     'type': 'pickleball',
  //     'price': 170000,
  //     'bookings': 154,
  //     'revenue': 26180000,
  //     'rating': 4.6,
  //   },
  // ];

  // static final List<Map<String, dynamic>> _mockDailyStats = [
  //   {'date': '17/1', 'bookings': 12, 'revenue': 2160000, 'occupancy': 25},
  //   {'date': '18/1', 'bookings': 15, 'revenue': 2700000, 'occupancy': 31},
  //   {'date': '19/1', 'bookings': 18, 'revenue': 3240000, 'occupancy': 38},
  //   {'date': '20/1', 'bookings': 22, 'revenue': 3960000, 'occupancy': 46},
  //   {'date': '21/1', 'bookings': 25, 'revenue': 4500000, 'occupancy': 52},
  //   {'date': '22/1', 'bookings': 20, 'revenue': 3600000, 'occupancy': 42},
  //   {'date': '23/1', 'bookings': 19, 'revenue': 3420000, 'occupancy': 40},
  // ];

  // static Future<List<DailyStats>> getDailyStats() async {
  //   // Giả lập delay gọi API
  //   await Future.delayed(const Duration(milliseconds: 500));

  //   return _mockDailyStats
  //       .map((data) => DailyStats(
  //             date: DateFormat('dd/M').parse(data['date']),
  //             totalBookings: data['bookings'],
  //             totalRevenue: data['revenue'].toDouble(),
  //             occupancyRate: data['occupancy'].toDouble(),
  //           ))
  //       .toList();
  // }

  // static Future<List<CourtPopularity>> getTopCourts(
  //     {required String sortBy}) async {
  //   // Giả lập delay gọi API
  //   await Future.delayed(const Duration(milliseconds: 500));

  //   final sortedCourts = List<Map<String, dynamic>>.from(_mockCourts);
  //   if (sortBy == 'revenue') {
  //     sortedCourts.sort((a, b) => b['revenue'].compareTo(a['revenue']));
  //   } else {
  //     sortedCourts.sort((a, b) => b['bookings'].compareTo(a['bookings']));
  //   }

  //   return sortedCourts
  //       .map((court) => CourtPopularity(
  //             courtId: court['id'],
  //             name: court['name'],
  //             imageUrl: court['image'],
  //             revenue: court['revenue'].toDouble(),
  //             bookings: court['bookings'],
  //             rating: court['rating'].toDouble(),
  //           ))
  //       .toList();
  // }
}
