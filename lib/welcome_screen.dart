import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vnb_ios/api_service.dart';
import 'preferences.dart';
import 'dart:convert';
import 'auth_sreen.dart';
import 'package:flutter/material.dart';
import 'auth_form.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100], // Light yellow background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // VNB Logo
            Image.asset(
              'assets/icon_vnb.png', // Replace with your logo path
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 20),
            // Welcome Text
            const Text(
              "Chào mừng bạn đến với VNB",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.deepOrange, // Custom button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => const AuthScreen()),
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: const Text(
                "Đăng nhập / Đăng ký",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 50),
            // App Version
            const Text(
              "Phiên bản 1.0.0", // Update version as needed
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
