import 'package:flutter/material.dart';
import 'api_service.dart';
import 'user.dart';
import 'booking.dart';
import 'auth_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isAdmin = false;
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
    _checkAdminRole();
    _fetchUsers();
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        final nameLower = user.name.toLowerCase();
        final emailLower = user.email.toLowerCase();
        final searchLower = query.toLowerCase();
        return nameLower.contains(searchLower) ||
            emailLower.contains(searchLower);
      }).toList();
    });
  }

  Future<void> _checkAdminRole() async {
    try {
      final currentUser = await AuthService.getCurrentUser();
      setState(() {
        isAdmin = currentUser?.role == 'admin';
      });
    } catch (e) {
      print('Error checking admin role: $e');
    }
  }

  Future<void> _fetchUsers() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedUsers = await ApiService.fetchUsers(role: _selectedRole);
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

  Future<void> _showAddUserDialog() async {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _selectedRoleForAdd = null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm người dùng mới'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                            child: Text(role == 'admin'
                                ? 'Admin'
                                : role == 'court_owner'
                                    ? 'Chủ sân'
                                    : role == 'staff'
                                        ? 'Nhân viên'
                                        : 'Khách hàng'),
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
                      const SnackBar(
                          content: Text('Thêm người dùng thành công')),
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

  Future<void> _showEditUserDialog(User user) async {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _passwordController.clear();
    _selectedRoleForAdd = user.role;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cập nhật người dùng'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Mật khẩu phải có ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),
                if (isAdmin)
                  DropdownButtonFormField<String>(
                    value: _selectedRoleForAdd,
                    decoration: const InputDecoration(labelText: 'Vai trò'),
                    items: ['admin', 'court_owner', 'staff', 'customer']
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role == 'admin'
                                  ? 'Admin'
                                  : role == 'court_owner'
                                      ? 'Chủ sân'
                                      : role == 'staff'
                                          ? 'Nhân viên'
                                          : 'Khách hàng'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRoleForAdd = value;
                      });
                    },
                  ),
              ],
            ),
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
                  final updateData = {
                    'id': user.id,
                    'name': _nameController.text,
                    'email': _emailController.text,
                  };

                  if (_passwordController.text.isNotEmpty) {
                    updateData['password'] = _passwordController.text;
                  }

                  if (isAdmin && _selectedRoleForAdd != null) {
                    updateData['role'] = _selectedRoleForAdd ?? "";
                  }

                  final success = await ApiService.updateUser(updateData);

                  if (success) {
                    Navigator.pop(context);
                    _fetchUsers();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Cập nhật người dùng thành công')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildUserListItem(User user) {
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
            if (isAdmin) ...[
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditUserDialog(user),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmDialog(user),
              ),
            ],
          ],
        ),
        children: [_buildUserDetails(user)],
      ),
    );
  }

  Future<void> _showDeleteConfirmDialog(User user) async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _showAddUserDialog,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Tìm kiếm theo tên hoặc email...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _filterUsers,
                  ),
                ),
                if (isAdmin) ...[
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedRole,
                    hint: const Text('Tất cả'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Tất cả'),
                      ),
                      ...['admin', 'court_owner', 'staff', 'customer']
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role == 'admin'
                                    ? 'Admin'
                                    : role == 'court_owner'
                                        ? 'Chủ sân'
                                        : role == 'staff'
                                            ? 'Nhân viên'
                                            : 'Khách hàng'),
                              ))
                          .toList(),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                      _fetchUsers();
                    },
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                    ? Center(child: Text('Lỗi: $error'))
                    : filteredUsers.isEmpty
                        ? const Center(child: Text('Không có người dùng nào'))
                        : ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: user.getRoleColor(),
                                  child: Text(
                                    user.name[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(user.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.email),
                                    Text(
                                      user.getRoleName(),
                                      style: TextStyle(
                                        color: user.getRoleColor(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: isAdmin
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () =>
                                                _showEditUserDialog(user),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete),
                                            color: Colors.red,
                                            onPressed: () =>
                                                _showDeleteConfirmDialog(user),
                                          ),
                                        ],
                                      )
                                    : null,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
