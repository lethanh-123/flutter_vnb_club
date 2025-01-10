import 'package:flutter/material.dart';

enum UserRole { admin, courtOwner, staff, customer }

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  UserRole role;
  final String createdAt;
  bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.role,
    required this.createdAt,
    this.isActive = true,
  });
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  UserRole? _selectedRole;
  List<User> filteredUsers = [];

  // Danh sách người dùng mẫu
  final List<User> users = [
    User(
      id: '1',
      name: 'Admin System',
      email: 'admin@system.com',
      phone: '0901234567',
      avatar: 'assets/admin.jpg',
      role: UserRole.admin,
      createdAt: '2024-01-01',
    ),
    User(
      id: '2',
      name: 'Nguyễn Văn A',
      email: 'vana@email.com',
      phone: '0901234568',
      avatar: 'assets/admin.jpg',
      role: UserRole.courtOwner,
      createdAt: '2024-01-02',
    ),
    User(
      id: '2',
      name: 'Nguyễn Văn B',
      email: 'vanb@email.com',
      phone: '0901234569',
      avatar: 'assets/admin.jpg',
      role: UserRole.staff,
      createdAt: '2024-01-02',
    ),
    User(
      id: '2',
      name: 'Nguyễn Văn C',
      email: 'vanc@email.com',
      phone: '0901234569',
      avatar: 'assets/admin.jpg',
      role: UserRole.customer,
      createdAt: '2024-01-02',
    ),
    // Thêm người dùng mẫu khác...
  ];

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
  }

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.courtOwner:
        return 'Chủ sân';
      case UserRole.staff:
        return 'Nhân viên';
      case UserRole.customer:
        return 'Khách hàng';
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Colors.red;
      case UserRole.courtOwner:
        return Colors.green;
      case UserRole.staff:
        return Colors.blue;
      case UserRole.customer:
        return Colors.grey;
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

  void _showUserDialog(User? user) {
    final isEditing = user != null;
    final nameController = TextEditingController(text: user?.name);
    final emailController = TextEditingController(text: user?.email);
    final phoneController = TextEditingController(text: user?.phone);
    var selectedRole = user?.role ?? UserRole.customer;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Chỉnh sửa người dùng' : 'Thêm người dùng mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tên'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserRole>(
                value: selectedRole,
                decoration: const InputDecoration(labelText: 'Vai trò'),
                items: UserRole.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(_getRoleName(role)),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedRole = value!;
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
            onPressed: () {
              // TODO: Implement save user logic
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Lưu' : 'Thêm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
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
                      ...UserRole.values.map((role) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(_getRoleName(role)),
                            selected: _selectedRole == role,
                            onSelected: (selected) {
                              setState(() {
                                _selectedRole = selected ? role : null;
                                _filterUsers(_searchController.text);
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Users list
          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(user.avatar),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(
                            _getRoleName(user.role),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          backgroundColor: _getRoleColor(user.role),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Chỉnh sửa'),
                            ),
                            PopupMenuItem(
                              value: 'status',
                              child: Text(
                                user.isActive ? 'Vô hiệu hóa' : 'Kích hoạt',
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Xóa'),
                            ),
                          ],
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _showUserDialog(user);
                                break;
                              case 'status':
                                setState(() {
                                  user.isActive = !user.isActive;
                                });
                                break;
                              case 'delete':
                                // TODO: Implement delete user
                                break;
                            }
                          },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
