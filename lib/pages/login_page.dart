// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_nav_bar.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('mobile', mobileController.text);
    // After login, switch to Home tab
    final bottomNavController = Get.find<BottomNavController>();
    bottomNavController.changePage(0);
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
