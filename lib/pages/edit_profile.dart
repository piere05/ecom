// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  String? mobile;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobile = prefs.getString('mobile');
    if (mobile != null) {
      var response = await http.post(
        Uri.parse('https://mini.piere.in.net/api/fetch_user.php'),
        body: {'mobile': mobile},
      );
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        firstnameController.text = data['user']['firstname'];
        lastnameController.text = data['user']['lastname'];
        addressController.text = data['user']['address'];
        mobileController.text = data['user']['mobile'];
        emailController.text = data['user']['email'];
        passwordController.text = data['user']['password'];
        landmarkController.text = data['user']['landmark'];
        cityController.text = data['user']['city'];
        stateController.text = data['user']['state'];
        pincodeController.text = data['user']['pincode'];
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch user data",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  void updateUser() async {
    var response = await http.post(
      Uri.parse('https://mini.piere.in.net/api/fetch_user.php'),
      body: {
        'firstname': firstnameController.text,
        'lastname': lastnameController.text,
        'address': addressController.text,
        'mobile': mobileController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'landmark': landmarkController.text,
        'city': cityController.text,
        'state': stateController.text,
        'pincode': pincodeController.text,
        'update': '1',
      },
    );

    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      Get.snackbar(
        "Success",
        "Profile updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Update failed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Edit Profile", style: TextStyle(color: Color(0xFFebcd66))),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("First Name", firstnameController),
              buildTextField("Last Name", lastnameController),
              buildTextField("Address", addressController),
              buildTextField("Email", emailController),
              buildTextField(
                "Password",
                passwordController,
                obscure: _obscurePassword,
              ),
              buildTextField("Landmark", landmarkController),
              buildTextField("City", cityController),
              buildTextField("State", stateController),
              buildTextField("Pincode", pincodeController),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: updateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFebcd66),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Update Profile",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        enabled: enabled,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFebcd66)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFebcd66), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Colors.grey[200],
          filled: true,
          suffixIcon: label == "Password"
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[700],
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
