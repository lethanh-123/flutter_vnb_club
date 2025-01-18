import 'package:flutter/material.dart';
import 'court.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Court court;
  final DateTime selectedDate;
  final Set<String> selectedCourts;
  final Set<String> selectedTimeSlots;

  const BookingConfirmationScreen({
    Key? key,
    required this.court,
    required this.selectedDate,
    required this.selectedCourts,
    required this.selectedTimeSlots,
  }) : super(key: key);

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final TextEditingController nameController =
      TextEditingController(text: 'Lê');
  final TextEditingController phoneController =
      TextEditingController(text: '0123456789');
  final TextEditingController emailController =
      TextEditingController(text: 'ltthanh.hvmm@gmail.com');

  // Tính tổng tiền
  double get totalAmount {
    double total = 0;
    for (var timeSlot in widget.selectedTimeSlots) {
      // Giả sử giá mỗi slot là 100,000đ
      total += 100000 * widget.selectedCourts.length;
    }
    return total;
  }

// Thêm biến để lưu ngân hàng được chọn
  BankInfo? selectedBank;

  // Danh sách ngân hàng
  final List<BankInfo> banks = [
    BankInfo(
      name: 'MB Bank',
      accountNumber: '0123456789',
      accountName: 'NGUYEN VAN A',
      logo: 'assets/mb.webp',
    ),
    BankInfo(
      name: 'Vietcombank',
      accountNumber: '9876543210',
      accountName: 'NGUYEN VAN A',
      logo: 'assets/mb.webp',
    ),
    BankInfo(
      name: 'Techcombank',
      accountNumber: '0987654321',
      accountName: 'NGUYEN VAN A',
      logo: 'assets/mb.webp',
    ),
  ];
  @override
  void initState() {
    super.initState();
    // Mặc định chọn ngân hàng đầu tiên
    selectedBank = banks.first;
  }

// Thêm widget helper để tạo item ngân hàng
  Widget _buildBankItem({
    required String bankName,
    required String accountNumber,
    required String accountName,
    required String bankLogo,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.asset(
            bankLogo,
            height: 32,
            width: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      accountNumber,
                      style: const TextStyle(
                        fontFamily: 'Courier',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: Copy số tài khoản
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Sao chép số tài khoản',
                    ),
                  ],
                ),
                Text(
                  accountName,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Thay thế phần danh sách ngân hàng cũ bằng ExpansionTile
  Widget _buildBankSelection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            if (selectedBank != null) ...[
              Image.asset(
                selectedBank!.logo,
                height: 32,
                width: 32,
              ),
              const SizedBox(width: 12),
              Text(
                selectedBank!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: banks.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final bank = banks[index];
              final isSelected = selectedBank?.name == bank.name;

              return ListTile(
                leading: Image.asset(
                  bank.logo,
                  height: 32,
                  width: 32,
                ),
                title: Text(
                  bank.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          bank.accountNumber,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // TODO: Copy số tài khoản
                          },
                          icon: const Icon(Icons.copy, size: 16),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Sao chép số tài khoản',
                        ),
                      ],
                    ),
                    Text(
                      bank.accountName,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                selectedTileColor: Colors.amber.withOpacity(0.1),
                onTap: () {
                  setState(() {
                    selectedBank = bank;
                  });
                },
              );
            },
          ),
        ],
      ),
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
        title: const Text('Thông tin đơn hàng'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thông tin khách hàng
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thông tin khách hàng',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.person_outline),
                          const SizedBox(width: 8),
                          Text(nameController.text),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined),
                          const SizedBox(width: 8),
                          Text(phoneController.text),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined),
                          const SizedBox(width: 8),
                          Text(emailController.text),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Thông tin dịch vụ
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Thông tin dịch vụ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Xử lý xem thêm
                            },
                            child: const Text('Xem thêm'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(8),
                          //   child: Image.asset(
                          //     widget.court.logo,
                          //     width: 80,
                          //     height: 80,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.court.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    Text(' ${widget.court.rating}'),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     const Icon(Icons.location_on_outlined,
                                //         size: 16),
                                //     const SizedBox(width: 4),
                                //     Text('Cách ${widget.court.distance}'),
                                //   ],
                                // ),
                                Text(widget.court.address),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      // Bảng thông tin đặt sân
                      Column(
                        children: [
                          // Header của bảng
                          Row(
                            children: const [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Ngày',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Thời gian',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Sân',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Giá thuê',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Danh sách các lịch đặt sân
                          ...widget.selectedTimeSlots.map((timeSlot) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(timeSlot),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child:
                                        Text(widget.selectedCourts.join(', ')),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      '100.000đ',
                                      style: const TextStyle(color: Colors.red),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Divider(),
                          ),
                          // Tổng giá thuê sân
                          Row(
                            children: [
                              const Expanded(
                                flex: 5,
                                child: Text(
                                  'Tổng giá thuê sân:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${totalAmount.toStringAsFixed(0)}đ',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Phương thức thanh toán
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thanh toán',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Gpay
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thông tin chuyển khoản',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            _buildBankSelection(),
                            const SizedBox(height: 16),
                            const Text(
                              'Nội dung chuyển khoản:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'SANBONG ${widget.selectedCourts.join('')} ${widget.selectedDate.day}${widget.selectedDate.month}',
                                      style: const TextStyle(
                                        fontFamily: 'Courier',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // TODO: Copy nội dung chuyển khoản
                                    },
                                    icon: const Icon(Icons.copy),
                                    tooltip: 'Sao chép',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Chuyển khoản
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chuyển khoản',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Image.asset(
                                'assets/qr.png',
                                height: 200,
                              ),
                            ),
                            const Center(
                              child: Text(
                                'Vui lòng quét mã QR để thanh toán.',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Xử lý upload ảnh
                              },
                              icon: const Icon(Icons.image),
                              label: const Text('Gửi ảnh hóa đơn giao dịch'),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 48),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Trong bottomNavigationBar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              // Hiển thị dialog thông báo thành công
              showDialog(
                context: context,
                barrierDismissible:
                    false, // Không cho phép đóng dialog bằng cách chạm bên ngoài
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Thanh toán thành công',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Cảm ơn bạn đã đặt sân tại ${widget.court.name}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Pop dialog và màn hình xác nhận để về trang trước
                                Navigator.of(context).pop(); // Đóng dialog
                                Navigator.of(context)
                                    .pop(); // Quay về trang trước
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Xác nhận',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text(
              'Thanh toán',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Thêm class để lưu thông tin ngân hàng
class BankInfo {
  final String name;
  final String accountNumber;
  final String accountName;
  final String logo;

  BankInfo({
    required this.name,
    required this.accountNumber,
    required this.accountName,
    required this.logo,
  });
}
