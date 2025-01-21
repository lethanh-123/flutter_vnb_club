import 'package:flutter/material.dart';
import 'tournament_format_screen.dart';
import 'location_list_screen.dart';
import 'court.dart';

class CreateTournamentScreen extends StatefulWidget {
  const CreateTournamentScreen({Key? key}) : super(key: key);

  @override
  State<CreateTournamentScreen> createState() => _CreateTournamentScreenState();
}

class _CreateTournamentScreenState extends State<CreateTournamentScreen> {
  String selectedSport = 'Pickleball';
  final TextEditingController _tournamentNameController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _locationSelected = false;
  bool _startDateSelected = false;
  bool _registrationDeadlineSelected = false;
  String? _selectedLocation;
  String? _locationId;
  DateTime? _startDate;
  DateTime? _registrationDeadline;
  Court? _selectedCourt;
  // Thêm các biến để lưu trình độ
  String? minSkillLevel;
  String? maxSkillLevel;
  // Thêm các biến để lưu thông tin phí
  String? feeType; // 'per_team' hoặc 'free'
  double? standardFee;
  // Thêm các biến để lưu giới hạn người chơi
  String? selectedAgeGroup;
  String? selectedGender;
  // Thêm các biến để lưu thông tin người tham gia
  String participantType = 'team'; // 'team' hoặc 'player'
  int maxTeams = 2;
  int minPlayersPerTeam = 2;
  int maxPlayersPerTeam = 4;
  int maxPlayers = 4;

  // Thêm biến để lưu loại bảo mật
  String privacyType = 'public'; // 'public' hoặc 'private'
  // Định nghĩa các trình độ theo môn
  final Map<String, List<String>> skillLevels = {
    'Tennis': [
      'Mới bắt đầu',
      'Nhập môn',
      'Trung bình',
      'Khá',
      'Chuyên nghiệp',
      'Chuyên gia'
    ],
    'Cầu lông': [
      'Mới bắt đầu',
      'Nhập môn',
      'Trung bình',
      'Khá',
      'Chuyên nghiệp',
      'Chuyên gia'
    ],
    'Pickleball': [
      '2.0',
      '2.5',
      '2.75',
      '3.0',
      '3.25',
      '3.5',
      '3.75',
      '4.0',
      '4.25',
      '4.5',
      '4.75',
      '5.0+'
    ],
  };

  @override
void initState() {
  super.initState();
  _tournamentNameController.addListener(_onTournamentNameChanged);
}
void _onTournamentNameChanged() {
  setState(() {
    // Gọi setState để cập nhật UI khi text thay đổi
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('TẠO GIẢI ĐẤU'),
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        children: [
          // Phần chọn môn thể thao
          _buildSportsSection(),
          const SizedBox(height: 24),

          // Phần chi tiết giải đấu
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CHI TIẾT',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingItem(
                key: _locationKey,
                icon: Icons.location_on,
                title: 'Chọn địa điểm',
                subtitle: _locationSelected ? 'Địa điểm đã chọn' : null,
                showArrow: true,
                onTap: _selectLocation,
              ),
              _buildSettingItem(
                key: _startDateKey,
                icon: Icons.calendar_today,
                title: 'Thời gian bắt đầu giải',
                subtitle:
                    'Bạn có thể bắt đầu giải ngay khi có đủ người chơi hoặc đợi chờ.',
                showArrow: true,
                onTap: _selectStartDate,
              ),
              _buildSettingItem(
                key: _registrationDeadlineKey,
                icon: Icons.timer,
                title: 'Hạn chót đăng ký',
                subtitle:
                    _registrationDeadlineSelected ? 'Đã chọn hạn chót' : null,
                showArrow: true,
                onTap: _selectRegistrationDeadline,
              ),
              _buildSkillLevelItem(),
              _buildPlayerRestrictionItem(),
              _buildParticipantsItem(),
              _buildTournamentFeeItem(),
              _buildPrivacyItem(),
            ],
          ),
          const SizedBox(height: 24),

          // Phần tên giải đấu
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            key: _tournamentNameKey,
            children: [
              const Text(
                'TÊN GIẢI ĐẤU',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _tournamentNameController,
                decoration: const InputDecoration(
                  hintText: 'Nhập tên giải đấu',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Nút tiếp tục
          _buildContinueButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

// Thêm các biến kiểm tra
  bool get isFormValid {
    return _locationSelected &&
        _startDateSelected &&
        _registrationDeadlineSelected &&
        _tournamentNameController.text.trim().isNotEmpty;
  }

  // Phương thức chọn địa điểm
  Future<void> _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationListScreen(),
      ),
    );

    if (result != null && result is Court) {
      setState(() {
        _selectedCourt = result;
        _selectedLocation = result.name; // Để tương thích với code cũ
        _locationSelected = true;
      });
    }
  }

  // Phương thức hiển thị dialog phí giải đấu
  Future<void> _showTournamentFeeDialog() async {
    String? tempFeeType = feeType;
    double? tempStandardFee = standardFee;
    final TextEditingController feeController = TextEditingController(
      text: tempStandardFee?.toString() ?? '',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép dialog có thể scroll
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Phí tham gia giải',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            child: ChoiceChip(
                              label: const Text(
                                'Mỗi Đội',
                                style: TextStyle(fontSize: 16),
                              ),
                              selected: tempFeeType == 'per_team',
                              onSelected: (bool selected) {
                                setState(() {
                                  tempFeeType = selected ? 'per_team' : null;
                                  if (!selected) {
                                    tempStandardFee = null;
                                    feeController.clear();
                                  }
                                });
                              },
                              selectedColor: Colors.green,
                              labelStyle: TextStyle(
                                color: tempFeeType == 'per_team'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 45,
                            child: ChoiceChip(
                              label: const Text(
                                'Miễn Phí',
                                style: TextStyle(fontSize: 16),
                              ),
                              selected: tempFeeType == 'free',
                              onSelected: (bool selected) {
                                setState(() {
                                  tempFeeType = selected ? 'free' : null;
                                  if (selected) {
                                    tempStandardFee = 0;
                                    feeController.text = '0';
                                  }
                                });
                              },
                              selectedColor: Colors.grey[300],
                              labelStyle: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (tempFeeType == 'per_team') ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Phí tiêu chuẩn',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: feeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Nhập phí tiêu chuẩn',
                          suffixText: 'đ',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            tempStandardFee = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ],
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        this.setState(() {
                          feeType = tempFeeType;
                          standardFee = tempStandardFee;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Thêm padding dưới cùng
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// Phương thức hiển thị dialog người tham gia
  Future<void> _showParticipantsDialog() async {
    String tempParticipantType = participantType;
    int tempMaxTeams = maxTeams;
    int tempMinPlayers = minPlayersPerTeam;
    int tempMaxPlayers =
        participantType == 'team' ? maxPlayersPerTeam : maxPlayers;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                top: 20,
                left: 20,
                right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Người tham gia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text(
                            'Đội',
                            style: TextStyle(fontSize: 16),
                          ),
                          selected: tempParticipantType == 'team',
                          onSelected: (bool selected) {
                            setState(() {
                              tempParticipantType = 'team';
                            });
                          },
                          selectedColor: Colors.green,
                          labelStyle: TextStyle(
                            color: tempParticipantType == 'team'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text(
                            'Người chơi',
                            style: TextStyle(fontSize: 16),
                          ),
                          selected: tempParticipantType == 'player',
                          onSelected: (bool selected) {
                            setState(() {
                              tempParticipantType = 'player';
                            });
                          },
                          selectedColor: Colors.green,
                          labelStyle: TextStyle(
                            color: tempParticipantType == 'player'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (tempParticipantType == 'team') ...[
                    // UI cho kiểu Đội
                    const Text(
                      'Số đội chơi tối đa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildNumberSelector(
                      value: tempMaxTeams,
                      onDecrease: () => setState(() {
                        if (tempMaxTeams > 2) tempMaxTeams--;
                      }),
                      onIncrease: () => setState(() {
                        if (tempMaxTeams < 32) tempMaxTeams++;
                      }),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Số thành viên mỗi đội',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Tối thiểu'),
                            const SizedBox(height: 8),
                            _buildNumberSelector(
                              value: tempMinPlayers,
                              onDecrease: () => setState(() {
                                if (tempMinPlayers > 1) tempMinPlayers--;
                              }),
                              onIncrease: () => setState(() {
                                if (tempMinPlayers < tempMaxPlayers)
                                  tempMinPlayers++;
                              }),
                            ),
                          ],
                        )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Tối đa'),
                              const SizedBox(height: 8),
                              _buildNumberSelector(
                                value: tempMaxPlayers,
                                onDecrease: () => setState(() {
                                  if (tempMaxPlayers > tempMinPlayers)
                                    tempMaxPlayers--;
                                }),
                                onIncrease: () => setState(() {
                                  if (tempMaxPlayers < 10) tempMaxPlayers++;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // UI cho kiểu Người chơi
                    const Text(
                      'Số người chơi tối đa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildNumberSelector(
                      value: tempMaxPlayers,
                      onDecrease: () => setState(() {
                        if (tempMaxPlayers > 2) tempMaxPlayers--;
                      }),
                      onIncrease: () => setState(() {
                        if (tempMaxPlayers < 32) tempMaxPlayers++;
                      }),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      this.setState(() {
                        participantType = tempParticipantType;
                        if (participantType == 'team') {
                          maxTeams = tempMaxTeams;
                          minPlayersPerTeam = tempMinPlayers;
                          maxPlayersPerTeam = tempMaxPlayers;
                        } else {
                          maxPlayers = tempMaxPlayers;
                        }
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Widget helper để tạo bộ chọn số
  Widget _buildNumberSelector({
    required int value,
    required VoidCallback onDecrease,
    required VoidCallback onIncrease,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: onDecrease,
        ),
        const SizedBox(width: 16),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: onIncrease,
        ),
      ],
    );
  }

// Cập nhật _buildSettingItem để hiển thị thông tin người tham gia
  Widget _buildParticipantsItem() {
    String displayText = participantType == 'team'
        ? 'Tối đa $maxTeams Đội\n$minPlayersPerTeam-$maxPlayersPerTeam người chơi mỗi đội'
        : 'Tối đa $maxPlayers người chơi';

    return _buildSettingItem(
      icon: Icons.group,
      title: 'Người tham gia',
      subtitle: displayText,
      showArrow: true,
      onTap: _showParticipantsDialog,
    );
  }

// Cập nhật _buildSettingItem để hiển thị phí giải đấu
  Widget _buildTournamentFeeItem() {
    String displayText = '';
    if (feeType == 'per_team') {
      displayText = '${standardFee?.toStringAsFixed(0) ?? '0'} đ mỗi đội';
    } else if (feeType == 'free') {
      displayText = 'Miễn phí';
    }

    return _buildSettingItem(
      icon: Icons.attach_money,
      title: 'Phí giải đấu',
      subtitle: displayText.isNotEmpty ? displayText : null,
      showArrow: true,
      onTap: _showTournamentFeeDialog,
    );
  }

  // Cập nhật phương thức build chi tiết địa điểm
  Widget _buildLocationDetail() {
    if (_selectedCourt == null) {
      return const Text(
        'Chưa chọn địa điểm',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedCourt!.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _selectedCourt!.address,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
            Text(
              '${_selectedCourt!.pricePerHour.toStringAsFixed(0)}đ/giờ',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 16),
            Icon(Icons.star, size: 16, color: Colors.amber),
            Text(
              _selectedCourt!.rating.toString(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        if (_selectedCourt!.amenities != null && _selectedCourt!.amenities!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: _selectedCourt!.amenities!.map((amenity) => Chip(
                label: Text(
                  amenity,
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.grey[200],
                padding: const EdgeInsets.symmetric(horizontal: 8),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )).toList(),
            ),
          ),
      ],
    );
  }

  // Phương thức chọn ngày bắt đầu
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      // Sau khi chọn ngày, hiển thị time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _startDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _startDateSelected = true;
        });
      }
    }
  }

  // Cập nhật phương thức chọn hạn chót đăng ký
  void _selectRegistrationDeadline() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _registrationDeadline = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          _registrationDeadlineSelected = true;
        });
      }
    }
  }

  Widget _buildSportsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MÔN THỂ THAO',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSportOption('Cầu lông', 'assets/badminton.png'),
            const SizedBox(width: 12),
            _buildSportOption('Pickleball', 'assets/pickle.png'),
            const SizedBox(width: 12),
            _buildSportOption('Tennis', 'assets/tennis.png'),
          ],
        ),
      ],
    );
  }

  // Cập nhật phần _buildDetailsSection
  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'CHI TIẾT',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildSettingItem(
          icon: Icons.location_on,
          title: 'Chọn địa điểm',
          trailing: _locationSelected ? null : const Text(''),
          showArrow: true,
          onTap: _selectLocation,
          content: _locationSelected ? _buildLocationDetail() : null,
        ),
        _buildSettingItem(
          icon: Icons.calendar_today,
          title: 'Thời gian bắt đầu giải',
          subtitle:
              'Bạn có thể bắt đầu giải ngay khi có đủ người chơi hoặc đợi chờ.',
          showArrow: true,
          onTap: _selectStartDate,
        ),
      ],
    );
  }

  Widget _buildRegistrationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'THỜI GIAN ĐĂNG KÝ',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        _buildRegistrationItem(
          'A',
          'Hạn chót đăng ký',
          _registrationDeadline != null
              ? '${_registrationDeadline!.day}/${_registrationDeadline!.month}/${_registrationDeadline!.year}'
              : '',
          _registrationDeadlineSelected ? 'sửa' : 'thêm',
          onTap: _selectRegistrationDeadline,
        ),
        _buildSkillLevelItem(),
        _buildPlayerRestrictionItem(),
        _buildTournamentFeeItem(),
        _buildParticipantsItem(),
        _buildPrivacyItem(),
      ],
    );
  }

  // Cập nhật lại _buildRegistrationItem để thêm onTap
  Widget _buildRegistrationItem(
    String letter,
    String title,
    String subtitle,
    String action, {
    VoidCallback? onTap,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.grey[300],
          child: Text(letter),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            action,
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildTournamentNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tên giải đấu',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _tournamentNameController,
          decoration: const InputDecoration(
            hintText: 'Tên giải đấu',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'LƯU Ý',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Thêm ghi chú',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  // Phương thức hiển thị dialog bảo mật
  Future<void> _showPrivacyDialog() async {
    String tempPrivacyType = privacyType;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Bảo mật',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  setState(() {
                    tempPrivacyType = 'public';
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.public,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Giải công khai',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ai cũng có thể tìm thấy và đăng ký tham gia',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (tempPrivacyType == 'public')
                        const Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  setState(() {
                    tempPrivacyType = 'private';
                  });
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Giải riêng tư',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Chỉ dành cho những ai được mời',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (tempPrivacyType == 'private')
                        const Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      setState(() {
        privacyType = tempPrivacyType;
      });
    });
  }

// Cập nhật _buildSettingItem để hiển thị bảo mật
  Widget _buildPrivacyItem() {
    String displayText = privacyType == 'public' ? 'Công khai' : 'Riêng tư';

    return _buildSettingItem(
      icon: Icons.public,
      title: 'Bảo mật',
      subtitle: displayText,
      showArrow: true,
      onTap: _showPrivacyDialog,
    );
  }

  // Phương thức hiển thị dialog giới hạn người chơi
  Future<void> _showPlayerRestrictionDialog() async {
    String? tempAgeGroup = selectedAgeGroup;
    String? tempGender = selectedGender;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giới hạn người chơi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Độ tuổi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildAgeGroupChip(
                        'Người lớn\n(từ 18 - 55)',
                        'adult',
                        tempAgeGroup,
                        (value) => setState(() => tempAgeGroup = value),
                      ),
                      const SizedBox(width: 8),
                      _buildAgeGroupChip(
                        'Thiếu niên\n(dưới 18)',
                        'teen',
                        tempAgeGroup,
                        (value) => setState(() => tempAgeGroup = value),
                      ),
                      const SizedBox(width: 8),
                      _buildAgeGroupChip(
                        'Cao tuổi\n(trên 55)',
                        'senior',
                        tempAgeGroup,
                        (value) => setState(() => tempAgeGroup = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Giới tính',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildGenderChip(
                        'Nam nữ',
                        'both',
                        tempGender,
                        (value) => setState(() => tempGender = value),
                      ),
                      const SizedBox(width: 8),
                      _buildGenderChip(
                        'Nam',
                        'male',
                        tempGender,
                        (value) => setState(() => tempGender = value),
                      ),
                      const SizedBox(width: 8),
                      _buildGenderChip(
                        'Nữ',
                        'female',
                        tempGender,
                        (value) => setState(() => tempGender = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      this.setState(() {
                        selectedAgeGroup = tempAgeGroup;
                        selectedGender = tempGender;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Widget cho chip độ tuổi
  Widget _buildAgeGroupChip(
    String label,
    String value,
    String? selectedValue,
    Function(String?) onSelected,
  ) {
    return Expanded(
      child: ChoiceChip(
        label: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selectedValue == value ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        selected: selectedValue == value,
        onSelected: (bool selected) {
          onSelected(selected ? value : null);
        },
        selectedColor: Colors.green,
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

// Widget cho chip giới tính
  Widget _buildGenderChip(
    String label,
    String value,
    String? selectedValue,
    Function(String?) onSelected,
  ) {
    return Expanded(
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: selectedValue == value ? Colors.black : Colors.black,
            fontSize: 14,
          ),
        ),
        selected: selectedValue == value,
        onSelected: (bool selected) {
          onSelected(selected ? value : null);
        },
        selectedColor: Colors.grey[300],
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }

// Cập nhật _buildSettingItem để hiển thị giới hạn người chơi
  Widget _buildPlayerRestrictionItem() {
    String displayText = '';
    if (selectedAgeGroup != null) {
      String ageText = selectedAgeGroup == 'adult'
          ? 'Người lớn'
          : selectedAgeGroup == 'teen'
              ? 'Thiếu niên'
              : 'Cao tuổi';
      displayText = ageText;
    }
    if (selectedGender != null) {
      String genderText = selectedGender == 'both'
          ? 'Nam nữ'
          : selectedGender == 'male'
              ? 'Nam'
              : 'Nữ';
      displayText += displayText.isEmpty ? genderText : ' - $genderText';
    }

    return _buildSettingItem(
      icon: Icons.people,
      title: 'Giới hạn người chơi',
      subtitle: displayText.isNotEmpty ? displayText : null,
      showArrow: true,
      onTap: _showPlayerRestrictionDialog,
    );
  }

  // Phương thức hiển thị dialog chọn trình độ
  Future<void> _showSkillLevelDialog() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Giới hạn trình độ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trình độ tối thiểu',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: skillLevels[selectedSport]!.map((level) {
                            bool isSelected = minSkillLevel == level;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(level),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  setState(() {
                                    minSkillLevel = selected ? level : null;
                                  });
                                },
                                selectedColor: Colors.blue.withOpacity(0.2),
                                backgroundColor: Colors.grey[200],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Trình độ tối đa',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: skillLevels[selectedSport]!.map((level) {
                            bool isSelected = maxSkillLevel == level;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(level),
                                selected: isSelected,
                                onSelected: (bool selected) {
                                  setState(() {
                                    maxSkillLevel = selected ? level : null;
                                  });
                                },
                                selectedColor: Colors.blue.withOpacity(0.2),
                                backgroundColor: Colors.grey[200],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      this.setState(() {}); // Cập nhật UI của màn hình chính
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

// Cập nhật _buildSettingItem để hiển thị trình độ đã chọn
  Widget _buildSkillLevelItem() {
    return _buildSettingItem(
      icon: Icons.emoji_events,
      title: 'Giới hạn trình độ',
      subtitle: minSkillLevel != null && maxSkillLevel != null
          ? '$minSkillLevel - $maxSkillLevel'
          : null,
      showArrow: true,
      onTap: _showSkillLevelDialog,
    );
  }

  Widget _buildSportOption(String name, String assetPath) {
    bool isSelected = selectedSport == name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSport = name;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              assetPath,
              width: 32,
              height: 32,
              color: isSelected ? Colors.blue : Colors.grey[600],
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sửa lại phương thức _buildSettingItem để hiển thị thời gian cho cả hạn chót đăng ký
  Widget _buildSettingItem({
    Key? key,
    required IconData icon,
    required String title,
    Widget? trailing,
    String? subtitle,
    bool showArrow = false,
    VoidCallback? onTap,
    Widget? content,
  }) {
    return Column(
      key: key,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: Colors.blue),
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (subtitle != null) Text(subtitle),
              if (title == 'Thời gian bắt đầu giải' && _startDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${_startDate!.day}/${_startDate!.month}/${_startDate!.year} ${_startDate!.hour.toString().padLeft(2, '0')}:${_startDate!.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (title == 'Hạn chót đăng ký' && _registrationDeadline != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${_registrationDeadline!.day}/${_registrationDeadline!.month}/${_registrationDeadline!.year} ${_registrationDeadline!.hour.toString().padLeft(2, '0')}:${_registrationDeadline!.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (title == 'Chọn địa điểm' && _selectedLocation != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _selectedLocation!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          trailing: showArrow
              ? const Icon(Icons.arrow_forward_ios, size: 16)
              : trailing,
          onTap: onTap,
        ),
        if (content != null)
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 16),
            child: content,
          ),
      ],
    );
  }

  // Cập nhật widget nút Tiếp tục
  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFormValid
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TournamentFormatScreen(),
                  ),
                );
              }
            : () => _showMissingFieldsDialog(),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid ? Colors.blue : Colors.grey[400],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Tiếp tục',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

// Thêm phương thức hiển thị thông báo và scroll đến trường thiếu
  void _showMissingFieldsDialog() {
    String missingFields = '';

    if (!_locationSelected) {
      missingFields += '- Địa điểm\n';
    }
    if (!_startDateSelected) {
      missingFields += '- Thời gian bắt đầu giải\n';
    }
    if (!_registrationDeadlineSelected) {
      missingFields += '- Hạn chót đăng ký\n';
    }
    if (_tournamentNameController.text.trim().isEmpty) {
      missingFields += '- Tên giải đấu\n';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông tin chưa đầy đủ'),
          content:
              Text('Vui lòng điền đầy đủ các thông tin sau:\n$missingFields'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _scrollToMissingField();
              },
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    );
  }

// Thêm ScrollController
  final ScrollController _scrollController = ScrollController();

// Thêm phương thức scroll đến trường thiếu
  void _scrollToMissingField() {
    if (!_locationSelected) {
      _scrollToField(_locationKey);
    } else if (!_startDateSelected) {
      _scrollToField(_startDateKey);
    } else if (!_registrationDeadlineSelected) {
      _scrollToField(_registrationDeadlineKey);
    } else if (_tournamentNameController.text.trim().isEmpty) {
      _scrollToField(_tournamentNameKey);
    }
  }

// Thêm các GlobalKey cho các trường
  final GlobalKey _locationKey = GlobalKey();
  final GlobalKey _startDateKey = GlobalKey();
  final GlobalKey _registrationDeadlineKey = GlobalKey();
  final GlobalKey _tournamentNameKey = GlobalKey();

// Sửa lại phương thức scroll để không sử dụng RenderAbstractViewport
  void _scrollToField(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  @override
  void dispose() {
    _tournamentNameController.removeListener(_onTournamentNameChanged);
    _tournamentNameController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
