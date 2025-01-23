// Thêm các model class
class DailyStats {
    final DateTime date;
    int totalBookings;
    double totalRevenue;
    double occupancyRateSum;
    double occupancyRate;
    int courtCount;

    DailyStats({
      required this.date,
      required this.totalBookings,
      required this.totalRevenue,
      required this.occupancyRateSum,
      this.occupancyRate = 0,
      this.courtCount = 1,
    });
  }