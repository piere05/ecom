// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'checkout_page.dart';
class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  bool isLoggedIn = true;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    checkLoginAndFetch();
  }

  Future<void> checkLoginAndFetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString('mobile');

    if (mobile == null || mobile.isEmpty) {
      setState(() {
        isLoggedIn = false;
        isLoading = false;
        cartItems = [];
        totalPrice = 0;
      });
    } else {
      fetchCart(mobile);
    }
  }

  Future<void> fetchCart(String mobile) async {
    final url = Uri.parse(
      "https://mini.piere.in.net/api/get_cart.php?action=fetch&mobile=$mobile",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> items =
          List<Map<String, dynamic>>.from(data['data'] ?? []);
      double total = 0;
      for (var item in items) {
        double price = double.tryParse(item['price'].toString()) ?? 0;
        int qty = item['qty'];
        total += price * qty;
      }

      setState(() {
        cartItems = items;
        totalPrice = total;
        isLoading = false;
      });
    } else {
      setState(() {
        cartItems = [];
        totalPrice = 0;
        isLoading = false;
      });
    }
  }

  Future<void> updateQuantity(int cartId, int newQty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString('mobile');
    if (mobile == null || mobile.isEmpty) return;

    final url = Uri.parse(
      "https://mini.piere.in.net/api/get_cart.php?action=update",
    );
    await http.post(
      url,
      body: {
        "cart_id": cartId.toString(),
        "qty": newQty.toString(),
        "mobile": mobile,
      },
    );
    fetchCart(mobile);
  }

  Future<void> removeItem(int cartId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString('mobile');
    if (mobile == null || mobile.isEmpty) return;

    final url = Uri.parse(
      "https://mini.piere.in.net/api/get_cart.php?action=remove",
    );
    await http.post(
      url,
      body: {"cart_id": cartId.toString(), "mobile": mobile},
    );
    fetchCart(mobile);
  }

  @override
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
            ? buildEmptyCart()
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
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
                  ),
                  // Bottom Total + Checkout Button
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total: ₹${cartItems.fold<double>(0, (sum, item) => sum + (double.tryParse(item['price'].toString()) ?? 0) * (item['qty'] ?? 1))}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to Checkout Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(), // your checkout page widget
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          ),
                          child: Text(
                            "Checkout",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
  );
}


  Widget buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            isLoggedIn ? 'Your cart is empty' : 'Please login to view your cart',
            style: TextStyle(fontSize: 20, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            isLoggedIn
                ? 'Add products to see them here'
                : 'Login to start adding products',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
