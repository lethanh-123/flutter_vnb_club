import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vnb_ios/api_service.dart';
import 'preferences.dart';
import 'dart:convert';
import 'dieu_khoan_dich_vu.dart';

class AuthForm extends StatefulWidget {
  final bool isLoginMode;

  const AuthForm({Key? key, required this.isLoginMode}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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

  void login() async {
    final email = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorDialog("Vui lòng nhập email và mật khẩu.");
      return;
    }

    final response = await ApiService.callApi('login.php', {
      'email': email,
      'password': password,
    });
    debugPrint("responsefsdf " + response.toString());
    if (response != null && response['success'] == true) {
      // await Preferences.saveUserInfo(response);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showErrorDialog(response?['error'] ?? "Thông tin đăng nhập không đúng.");
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

    final response = await ApiService.callApi('register.php', {
      'name': name,
      'email': email,
      'password': password,
    });
    if (response != null && response['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TermsAndPolicyScreen()),
      );
      setState(() => isLogin = true);
    } else {
      showErrorDialog(response?['error'] ?? "Đăng ký thất bại.");
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
