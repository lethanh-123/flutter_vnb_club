import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user.dart';
import 'booking.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedRole;
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final fetchedUsers = await ApiService.fetchUsers();
      setState(() {
        users = fetchedUsers;
        filteredUsers = users;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        final nameMatch = user.name.toLowerCase().contains(query.toLowerCase());
        final emailMatch =
            user.email.toLowerCase().contains(query.toLowerCase());
        final roleMatch = _selectedRole == null || user.role == _selectedRole;
        return (nameMatch || emailMatch) && roleMatch;
      }).toList();
    });
  }

  Widget _buildUserDetails(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(user.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Email: ${user.email}'),
              Text('Ngày tạo: ${user.createdAt}'),
              if (user.lastLogin != null)
                Text('Đăng nhập cuối: ${user.lastLogin}'),
            ],
          ),
          trailing: Chip(
            label: Text(
              user.getRoleName(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            backgroundColor: user.getRoleColor(),
          ),
        ),
        if (user.role == 'customer' && user.bookings != null) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Lịch sử đặt sân',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...user.bookings!.map((booking) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text('Sân ${booking.courtId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ngày: ${booking.date}'),
                      Text(
                          'Thời gian: ${booking.startTime} - ${booking.endTime}'),
                      Row(
                        children: [
                          Chip(
                            label: Text(
                              booking.status,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: booking.status == 'confirmed'
                                ? Colors.green
                                : Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              booking.paymentStatus,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: booking.paymentStatus == 'paid'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(
                    '${booking.totalPrice.toStringAsFixed(0)}đ',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
        ],
        if (user.role == 'court_owner' && user.courts != null) ...[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Danh sách sân',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...user.courts!.map((court) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(court.logoUrl),
                  ),
                  title: Text(court.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(court.address),
                      Row(
                        children: [
                          Icon(
                            court.getCourtTypeIcon(),
                            color: court.getCourtTypeColor(),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(court.getCourtTypeName()),
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(
                    court.formatPrice(),
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              ElevatedButton(
                onPressed: _fetchUsers,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm theo tên hoặc email...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: _filterUsers,
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Tất cả'),
                        selected: _selectedRole == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedRole = null;
                            _filterUsers(_searchController.text);
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ...['admin', 'court_owner', 'staff', 'customer']
                          .map((role) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(User(
                                    id: '',
                                    name: '',
                                    email: '',
                                    role: role,
                                    createdAt: '',
                                    phone: '',
                                  ).getRoleName()),
                                  selected: _selectedRole == role,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedRole = selected ? role : null;
                                      _filterUsers(_searchController.text);
                                    });
                                  },
                                ),
                              )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      child: Text(user.name[0].toUpperCase()),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Chip(
                      label: Text(
                        user.getRoleName(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: user.getRoleColor(),
                    ),
                    children: [_buildUserDetails(user)],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
