// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/bottom_nav_bar.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> _register(BuildContext context) async {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final mobile = mobileController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final landmark = landmarkController.text.trim();
    final address = addressController.text.trim();
    final city = cityController.text.trim();
    final state = stateController.text.trim();
    final pincode = pincodeController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        mobile.isEmpty ||
        password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://gurunath.piere.in.net/api/register_user.php"),
        body: {
          "firstname": firstName,
          "lastname": lastName,
          "mobile": mobile,
          "email": email,
          "password": password,
          "landmark": landmark,
          "address": address,
          "city": city,
          "state": state,
          "pincode": pincode,
        },
      );

      final data = jsonDecode(response.body);

      if (data['status'] == "exists") {
        Get.snackbar(
          "Error",
          "Mobile number already exists",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (data['status'] == "success") {
        Get.snackbar(
          "Success",
          "Registered successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(() => LoginPage());
      } else {
        Get.snackbar(
          "Error",
          "Registration failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavController>();

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

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => _register(context),
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

                // Go to Login button
                Center(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => LoginPage()),
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
                SizedBox(height: 10),

                // Go to Home button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
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
