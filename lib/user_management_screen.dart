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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRoleForAdd;
  
  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm người dùng mới'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!value.contains('@')) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedRoleForAdd,
                decoration: const InputDecoration(labelText: 'Vai trò'),
                items: ['admin', 'court_owner', 'staff', 'customer']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(User(
                            id: '',
                            name: '',
                            email: '',
                            role: role,
                            createdAt: '',
                          ).getRoleName()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoleForAdd = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn vai trò';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  final success = await ApiService.createUser({
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'password': _passwordController.text,
                    'role': _selectedRoleForAdd,
                  });

                  if (success) {
                    Navigator.pop(context);
                    _fetchUsers();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Thêm người dùng thành công')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _selectedRoleForAdd = user.role;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa thông tin người dùng'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!value.contains('@')) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới (để trống nếu không đổi)',
                ),
                obscureText: true,
              ),
              DropdownButtonFormField<String>(
                value: _selectedRoleForAdd,
                decoration: const InputDecoration(labelText: 'Vai trò'),
                items: ['admin', 'court_owner', 'staff', 'customer']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(User(
                            id: '',
                            name: '',
                            email: '',
                            role: role,
                            createdAt: '',
                          ).getRoleName()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoleForAdd = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Vui lòng chọn vai trò';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  final userData = {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'role': _selectedRoleForAdd,
                  };

                  if (_passwordController.text.isNotEmpty) {
                    userData['password'] = _passwordController.text;
                  }

                  final success = await ApiService.updateUser(user.id, userData);

                  if (success) {
                    Navigator.pop(context);
                    _fetchUsers();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cập nhật thông tin thành công'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa người dùng ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () async {
              try {
                final success = await ApiService.deleteUser(user.id);

                if (success) {
                  Navigator.pop(context);
                  _fetchUsers();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Xóa người dùng thành công')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: $e')),
                );
              }
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddUserDialog,
          ),
        ],
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
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      child: Text(user.name[0].toUpperCase()),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(
                            user.getRoleName(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: user.getRoleColor(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditUserDialog(user),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmDialog(user),
                        ),
                      ],
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

}
