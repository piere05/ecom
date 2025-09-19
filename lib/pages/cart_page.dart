// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString('mobile');
    if (mobile == null || mobile.isEmpty) return;

    final url = Uri.parse(
      "https://gurunath.piere.in.net/api/get_cart.php?action=fetch&mobile=$mobile",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        cartItems = List<Map<String, dynamic>>.from(data['data'] ?? []);
        isLoading = false;
      });
    }
  }

  Future<void> updateQuantity(int cartId, int newQty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString('mobile');
    if (mobile == null || mobile.isEmpty) return;

    final url = Uri.parse(
      "https://gurunath.piere.in.net/api/get_cart.php?action=update",
    );
    await http.post(
      url,
      body: {
        "cart_id": cartId.toString(),
        "qty": newQty.toString(),
        "mobile": mobile,
      },
    );
    fetchCart();
  }

  Future<void> removeItem(int cartId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString('mobile');
    if (mobile == null || mobile.isEmpty) return;

    final url = Uri.parse(
      "https://gurunath.piere.in.net/api/get_cart.php?action=remove",
    );
    await http.post(
      url,
      body: {"cart_id": cartId.toString(), "mobile": mobile},
    );
    fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        foregroundColor: Color(0xFFebcd66),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Add products to see them here',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                int qty = item['qty'];
                double price = double.tryParse(item['price'].toString()) ?? 0;

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          item['image1'],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text("Price: ₹$price"),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: qty > 1
                                        ? () {
                                            updateQuantity(
                                              item['cart_id'],
                                              qty - 1,
                                            );
                                          }
                                        : null,
                                    icon: Icon(Icons.remove),
                                  ),
                                  Text(
                                    qty.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      updateQuantity(item['cart_id'], qty + 1);
                                    },
                                    icon: Icon(Icons.add),
                                  ),
                                  Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      removeItem(item['cart_id']);
                                    },
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
