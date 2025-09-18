// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_nav_bar.dart';
import 'register_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    if (mobile.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter mobile and password",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final response = await http.post(
      Uri.parse("https://gurunath.piere.in.net/api/login_user.php"),
      body: {"mobile": mobile, "password": password},
    );

    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data["status"] == "success") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('mobile', mobile);

        // set expiry (7 days)
        final expiryDate = DateTime.now()
            .add(const Duration(days: 7))
            .toIso8601String();
        await prefs.setString('expiry', expiryDate);

        final bottomNavController = Get.find<BottomNavController>();
        bottomNavController.changePage(0);

        Get.offAll(
          () => Scaffold(
            body: Obx(
              () => IndexedStack(
                index: bottomNavController.selectedIndex.value,
                children: [
                  BottomNavBarWidget().getPage(0),
                  BottomNavBarWidget().getPage(1),
                  BottomNavBarWidget().getPage(2),
                  BottomNavBarWidget().getPage(3),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavBarWidget(),
          ),
        );
      } else {
        Get.snackbar(
          "Login Failed",
          "Invalid mobile or password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Server error",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Center(
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Color(0xFFebcd66),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Login to continue",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                  ),
                ),
                SizedBox(height: 60),
                Text(
                  "Mobile Number",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter your mobile number",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.phone, color: Color(0xFFebcd66)),
                  ),
                ),
                SizedBox(height: 20),
                Text("Password", style: TextStyle(color: Colors.grey.shade400)),
                SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Color(0xFFebcd66)),
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFebcd66),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => RegisterPage());
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Not Yet Registered? ",
                        style: TextStyle(color: Colors.grey.shade400),
                        children: [
                          TextSpan(
                            text: "Register Now",
                            style: TextStyle(
                              color: Color(0xFFebcd66),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Home Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final bottomNavController =
                          Get.find<BottomNavController>();
                      bottomNavController.changePage(0); // switch to Home tab
                      Get.offAll(
                        () => Scaffold(
                          body: Obx(
                            () => IndexedStack(
                              index: bottomNavController.selectedIndex.value,
                              children: [
                                BottomNavBarWidget().getPage(0),
                                BottomNavBarWidget().getPage(1),
                                BottomNavBarWidget().getPage(2),
                                BottomNavBarWidget().getPage(3),
                              ],
                            ),
                          ),
                          bottomNavigationBar: BottomNavBarWidget(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Go to Home", style: TextStyle(fontSize: 16)),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
