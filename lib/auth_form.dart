import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vnb_ios/api_service.dart';
import 'preferences.dart';
import 'dart:convert';
import 'dieu_khoan_dich_vu.dart';
import 'home_screen.dart';

class AuthForm extends StatefulWidget {
  final bool isLoginMode;

  const AuthForm({Key? key, required this.isLoginMode}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController usernameController =
      TextEditingController(text: "ltthanh.hvmm@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "123456");
  final TextEditingController nameController = TextEditingController();

  final FocusNode passwordFocusNode = FocusNode();
  late bool isLogin;
  @override
  void initState() {
    super.initState();
    isLogin = widget.isLoginMode; // Khởi tạo từ widget
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
// void login() async {
//   var url = Uri.parse("https://cosports.appvnb.com/DangNhap");
//   var response = await http.post(
//     url,
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({"email": "lltthanh.hvmm@gmail.com", "password": "123456"}),
//   );

//   print(response.body);
// }
  void login() async {
    final email = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog("Vui lòng nhập email và mật khẩu.");
      return;
    }

    try {
      final response = await ApiService.callApi('DangNhap', {
        'email': email,
        'password': password,
      });
      debugPrint("response1213" + response.toString());
      if (response == null) {
        showErrorDialog("Không nhận được phản hồi từ máy chủ.");
        return;
      }

      if (response['success'] == true && response.containsKey('data')) {
        final prefs = await SharedPreferences.getInstance();
        final userData =
            response['data']['user'] as Map<String, dynamic>? ?? {};
        final accessToken = response['data']['access_token'] as String? ?? '';

        if (userData.isNotEmpty && accessToken.isNotEmpty) {
          print('Saving user data - ID: ${userData['id']}'); // Debug log

          await prefs.setInt('userId', userData['id']);
          await prefs.setString('userEmail', userData['email'] ?? '');
          await prefs.setString('userName', userData['name'] ?? '');
          await prefs.setString('accessToken', accessToken);
          await prefs.setBool('isLoggedIn', true);

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          showErrorDialog("Dữ liệu phản hồi không hợp lệ.");
        }
      } else {
        final errorMsg = response['message'] ?? "Đăng nhập thất bại";
        showErrorDialog(errorMsg);
      }
    } catch (e) {
      print('Login error: $e'); // Debug log
      showErrorDialog("Có lỗi xảy ra: ${e.toString()}");
    }
  }

  void register() async {
    final email = usernameController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      showErrorDialog("Vui lòng điền đầy đủ thông tin.");
      return;
    }

    try {
      final response = await ApiService.callApi('DangKy', {
        'name': name,
        'email': email,
        'password': password,
      });

      print('Register response: $response'); // For debugging

      // Kiểm tra response không null và success là true
      if (response != null && response['success'] == true) {
        if (!mounted) return;

        // Chuyển đến màn hình điều khoản
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TermsAndPolicyScreen()),
        );

        // Chuyển sang chế độ đăng nhập
        setState(() => isLogin = true);
      } else {
        // Hiển thị lỗi từ server hoặc lỗi mặc định
        showErrorDialog(response?['error'] ?? "Đăng ký thất bại");
      }
    } catch (e) {
      print('Registration error: $e'); // For debugging
      showErrorDialog("Có lỗi xảy ra khi đăng ký: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.isLoginMode)
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Họ tên",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        if (!widget.isLoginMode) const SizedBox(height: 16),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            hintText: "Tên đăng nhập",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => passwordFocusNode.requestFocus(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          focusNode: passwordFocusNode,
          decoration: InputDecoration(
            hintText: "Mật khẩu",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: widget.isLoginMode ? login : register,
          child: Text(
            widget.isLoginMode ? "Đăng nhập" : "Đăng ký",
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
