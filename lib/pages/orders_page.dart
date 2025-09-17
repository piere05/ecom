// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        foregroundColor: Color(0xFFebcd66),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Start shopping to place your first order!',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
