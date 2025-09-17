// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/bottom_nav_bar.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();

  Future<void> _register() async {
    // You can save user data to SharedPreferences or API here
    final bottomNavController = Get.find<BottomNavController>();
    bottomNavController.changePage(0); // Switch to Home tab
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
                SizedBox(height: 40),
                Center(
                  child: Text(
                    "Create Account",
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
                    "Register to continue",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                  ),
                ),
                SizedBox(height: 40),

                // First Name
                Text(
                  "First Name",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: firstNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter your first name",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Last Name
                Text(
                  "Last Name",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: lastNameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter your last name",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Mobile
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
                SizedBox(height: 16),

                // Email
                Text("Email", style: TextStyle(color: Colors.grey.shade400)),
                SizedBox(height: 8),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter your email",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.email, color: Color(0xFFebcd66)),
                  ),
                ),
                SizedBox(height: 16),

                // Password
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
                SizedBox(height: 16),

                // Landmark
                Text("Landmark", style: TextStyle(color: Colors.grey.shade400)),
                SizedBox(height: 8),
                TextField(
                  controller: landmarkController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter landmark",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Address
                Text("Address", style: TextStyle(color: Colors.grey.shade400)),
                SizedBox(height: 8),
                TextField(
                  controller: addressController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter address",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // City
                Text("City", style: TextStyle(color: Colors.grey.shade400)),
                SizedBox(height: 8),
                TextField(
                  controller: cityController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter city",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // State
                Text("State", style: TextStyle(color: Colors.grey.shade400)),
                SizedBox(height: 8),
                TextField(
                  controller: stateController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter state",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Pincode
                Text("Pincode", style: TextStyle(color: Colors.grey.shade400)),
                SizedBox(height: 8),
                TextField(
                  controller: pincodeController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Enter pincode",
                    hintStyle: TextStyle(color: Colors.grey.shade600),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFebcd66),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Login Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => LoginPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("Go to Login", style: TextStyle(fontSize: 16)),
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
