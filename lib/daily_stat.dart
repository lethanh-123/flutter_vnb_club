// Thêm các model class
class DailyStats {
  final DateTime date;
  final int totalBookings;
  final double totalRevenue;
  final double occupancyRate;

  DailyStats({
    required this.date,
    required this.totalBookings,
    required this.totalRevenue,
    required this.occupancyRate,
  });
}
