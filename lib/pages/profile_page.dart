// ignore_for_file: use_key_in_widget_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile.dart';
import 'contact_us_page.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: Color(0xFFebcd66),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),

            Center(
              child: Container(
                height: 120,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: 40),
            // Menu Items
            ProfileMenuItem(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () => Get.to(() => EditProfilePage()),
            ),
            ProfileMenuItem(
              icon: Icons.contact_page,
              title: 'Contact Us',
              onTap: () => Get.to(() => ContactUsPage()),
            ),
            ProfileMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('mobile');
                Get.offAll(() => LoginPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFebcd66)),
        title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }
}
