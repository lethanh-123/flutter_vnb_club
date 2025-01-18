import 'package:flutter/material.dart';
import 'package:dvhcvn/dvhcvn.dart';

class FilterCourtScreen extends StatefulWidget {
  final Set<String> selectedTypes;
  final Level1? selectedProvince;
  final Level2? selectedDistrict;
  final Level3? selectedWard;

  const FilterCourtScreen({
    Key? key,
    required this.selectedTypes,
    this.selectedProvince,
    this.selectedDistrict,
    this.selectedWard,
  }) : super(key: key);

  @override
  State<FilterCourtScreen> createState() => _FilterCourtScreenState();
}

class _FilterCourtScreenState extends State<FilterCourtScreen> {
  Level1? selectedProvince;
  Level2? selectedDistrict;
  Level3? selectedWard;
  String selectedSport = 'Pickle ball';
  String selectedCourtType = 'Sân 7';
  double priceValue = 600000;
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  Future<TimeOfDay?> _showCustomTimePicker(BuildContext context) {
    int selectedHour = TimeOfDay.now().hour;
    int selectedMinute = TimeOfDay.now().minute;

    return showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          decoration: const BoxDecoration(
            color: Color(0xFF2B2B2B),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Select time',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Giờ
                    SizedBox(
                      width: 70,
                      child: ListWheelScrollView(
                        itemExtent: 50,
                        diameterRatio: 1.5,
                        physics: const FixedExtentScrollPhysics(),
                        children: List.generate(24, (index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                              ),
                            ),
                          );
                        }),
                        onSelectedItemChanged: (index) {
                          selectedHour = index; // Cập nhật giờ được chọn
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Phút
                    SizedBox(
                      width: 70,
                      child: ListWheelScrollView(
                        itemExtent: 50,
                        diameterRatio: 1.5,
                        physics: const FixedExtentScrollPhysics(),
                        children: List.generate(60, (index) {
                          return Center(
                            child: Text(
                              index.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                              ),
                            ),
                          );
                        }),
                        onSelectedItemChanged: (index) {
                          selectedMinute = index; // Cập nhật phút được chọn
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Nút xác nhận và hủy
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Hủy bỏ',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Trả về thời gian đã chọn
                          Navigator.of(context).pop(
                            TimeOfDay(
                                hour: selectedHour, minute: selectedMinute),
                          );
                        },
                        child: const Text(
                          'Xác nhận',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Lọc sân'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vị trí
            const Text(
              'Nhập vị trí',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Dropdown Tỉnh/Thành phố
            DropdownButtonFormField<Level1>(
              value: selectedProvince,
              decoration: const InputDecoration(
                hintText: 'Chọn Tỉnh/Thành phố',
                border: OutlineInputBorder(),
              ),
              items: level1s.map((province) {
                return DropdownMenuItem<Level1>(
                  value: province,
                  child: Text(province.name),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedProvince = newValue;
                  selectedDistrict = null;
                  selectedWard = null;
                });
              },
            ),
            const SizedBox(height: 16),

            if (selectedProvince != null) ...[
              DropdownButtonFormField<Level2>(
                value: selectedDistrict,
                decoration: const InputDecoration(
                  hintText: 'Chọn Quận/Huyện',
                  border: OutlineInputBorder(),
                ),
                items: selectedProvince!.children.map((district) {
                  return DropdownMenuItem<Level2>(
                    value: district,
                    child: Text(district.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedDistrict = newValue;
                    selectedWard = null;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],

            if (selectedDistrict != null) ...[
              DropdownButtonFormField<Level3>(
                value: selectedWard,
                decoration: const InputDecoration(
                  hintText: 'Chọn Phường/Xã',
                  border: OutlineInputBorder(),
                ),
                items: selectedDistrict!.children.map((ward) {
                  return DropdownMenuItem<Level3>(
                    value: ward,
                    child: Text(ward.name),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedWard = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],

            // Môn thể thao
            const Text(
              'Môn thể thao',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedSport,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: ['Pickle ball', 'Cầu lông', 'Tennis'].map((sport) {
                return DropdownMenuItem<String>(
                  value: sport,
                  child: Text(sport),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSport = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Loại sân
            const Text(
              'Loại sân',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedCourtType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: ['Sân 5', 'Sân 7', 'Sân 11'].map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourtType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Giá tiền
            const Text(
              'Giá tiền',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Slider(
              value: priceValue,
              min: 0,
              max: 1000000,
              divisions: 20,
              label: '${priceValue.toInt()}đ',
              onChanged: (value) {
                setState(() {
                  priceValue = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Ngày
            const Text(
              'Ngày',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Giờ
            const Text(
              'Giờ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final TimeOfDay? picked = await _showCustomTimePicker(context);
                if (picked != null) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                child: Text(
                  selectedTime?.format(context) ?? 'Chọn giờ',
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement filter logic
            Navigator.pop(context, {
              'province': selectedProvince,
              'district': selectedDistrict,
              'ward': selectedWard,
              'sport': selectedSport,
              'courtType': selectedCourtType,
              'price': priceValue,
              'date': selectedDate,
              'time': selectedTime,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'Tìm sân',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
