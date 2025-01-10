import 'package:flutter/material.dart';
import 'court.dart';
import 'booking_confirmation_screen.dart';

class CourtBookingScreen extends StatefulWidget {
  final Court court;
  final DateTime selectedDate;
  final Set<String> selectedCourts;
  final Function(DateTime date, Set<String> courts) onUpdateSelection;

  const CourtBookingScreen({
    Key? key,
    required this.court,
    required this.selectedDate,
    required this.selectedCourts,
    required this.onUpdateSelection,
  }) : super(key: key);

  @override
  State<CourtBookingScreen> createState() => _CourtBookingScreenState();
}

class _CourtBookingScreenState extends State<CourtBookingScreen> {
  late DateTime selectedDate;
  late Set<String> selectedCourts;
  Set<String> selectedTimeSlots = {};

  final List<TimeSlot> timeSlots = [
    TimeSlot('05:00 - 06:00', 100000),
    TimeSlot('06:00 - 07:00', 100000),
    TimeSlot('07:00 - 08:00', 100000),
    TimeSlot('08:00 - 09:00', 100000),
    TimeSlot('09:00 - 10:00', 100000),
    TimeSlot('10:00 - 11:00', 100000),
    TimeSlot('11:00 - 12:00', 100000),
    TimeSlot('12:00 - 13:00', 100000),
    TimeSlot('13:00 - 14:00', 100000),
    TimeSlot('14:00 - 15:00', 100000),
    TimeSlot('15:00 - 16:00', 100000),
    TimeSlot('16:00 - 17:00', 150000),
    TimeSlot('17:00 - 18:00', 150000),
    TimeSlot('18:00 - 19:00', 150000),
    TimeSlot('19:00 - 20:00', 150000),
    TimeSlot('20:00 - 21:00', 100000),
    TimeSlot('21:00 - 22:00', 100000),
  ];

  // Tính tổng số lịch đã chọn
  int get totalBookings => selectedTimeSlots.length * selectedCourts.length;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    selectedCourts = Set.from(widget.selectedCourts);
  }

  // Thêm hàm để cập nhật selection
  void _updateSelection({DateTime? date, Set<String>? courts}) {
    setState(() {
      if (date != null) selectedDate = date;
      if (courts != null) selectedCourts = courts;
    });
    // Gọi callback để cập nhật giá trị về trang trước
    widget.onUpdateSelection(selectedDate, selectedCourts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Chi tiết sân bóng'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chọn ngày
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chọn ngày',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index));
                        final isSelected = selectedDate.year == date.year &&
                            selectedDate.month == date.month &&
                            selectedDate.day == date.day;

                        return GestureDetector(
                          onTap: () {
                            _updateSelection(date: date);
                          },
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.amber : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.amber
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _getDayOfWeek(date.weekday),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Chọn sân
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn sân',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(10, (index) {
                      final courtName = 'Sân ${index + 1}';
                      final isSelected = selectedCourts.contains(courtName);
                      return GestureDetector(
                        onTap: () {
                          final newCourts = Set<String>.from(selectedCourts);
                          if (isSelected) {
                            newCourts.remove(courtName);
                          } else {
                            newCourts.add(courtName);
                          }
                          _updateSelection(courts: newCourts);
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 48) / 3,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.amber : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isSelected ? Colors.amber : Colors.grey[300]!,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              courtName,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Chọn giờ
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Chọn giờ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Đã đặt'),
                          const SizedBox(width: 16),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('Đã chặn'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      final slot = timeSlots[index];
                      final isSelected = selectedTimeSlots.contains(slot.time);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedTimeSlots.remove(slot.time);
                              } else {
                                selectedTimeSlots.add(slot.time);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.amber : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.amber
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  slot.time,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${slot.price.toStringAsFixed(0)}đ',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.court.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('$totalBookings lịch đã chọn'),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed:
                    selectedTimeSlots.isNotEmpty && selectedCourts.isNotEmpty
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingConfirmationScreen(
                                  court: widget.court,
                                  selectedDate: selectedDate,
                                  selectedCourts: selectedCourts,
                                  selectedTimeSlots: selectedTimeSlots,
                                ),
                              ),
                            );
                          }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Thanh toán'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Thứ Hai';
      case DateTime.tuesday:
        return 'Thứ Ba';
      case DateTime.wednesday:
        return 'Thứ Tư';
      case DateTime.thursday:
        return 'Thứ Năm';
      case DateTime.friday:
        return 'Thứ Sáu';
      case DateTime.saturday:
        return 'Thứ Bảy';
      case DateTime.sunday:
        return 'Chủ Nhật';
      default:
        return '';
    }
  }
}

class TimeSlot {
  final String time;
  final double price;

  TimeSlot(this.time, this.price);
}
