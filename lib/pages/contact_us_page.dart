// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  void submitContact() async {
    if (_formKey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse('https://mini.piere.in.net/api/contact_us.php'),
        body: {
          'name': nameController.text,
          'mobile': mobileController.text,
          'email': emailController.text,
          'subject': subjectController.text,
          'message': messageController.text,
        },
      );

      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        Get.snackbar(
          "Success",
          "Message sent successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _formKey.currentState!.reset();
      } else {
        Get.snackbar(
          "Error",
          "Failed to send message",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // page background
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Contact Us", style: TextStyle(color: Color(0xFFebcd66))),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("Name", nameController),
              buildTextField("Mobile", mobileController),
              buildTextField("Email", emailController),
              buildTextField("Subject", subjectController),
              buildTextField("Message", messageController, maxLines: 5),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: submitContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFebcd66),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Submit",
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: Colors.black),
        validator: (value) => value!.isEmpty ? "$label cannot be empty" : null,
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
        ),
      ),
    );
  }
}
