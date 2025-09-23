// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../widgets/bottom_nav_bar.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<Map<String, dynamic>> cartItems = [];
  double totalAmount = 0;
  double gst = 0;
  double netTotal = 0;
  String? mobile;

  @override
  void initState() {
    super.initState();
    loadUserAndCart();
  }

  Future<void> loadUserAndCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobile = prefs.getString('mobile');
    if (mobile == null || mobile!.isEmpty) return;

    var userRes = await http.post(
      Uri.parse('https://mini.piere.in.net/api/fetch_user.php'),
      body: {'mobile': mobile},
    );
    var userData = json.decode(userRes.body);
    if (userData['status'] == 'success') {
      firstNameController.text = userData['user']['firstname'];
      addressController.text =
          "${userData['user']['address']}, ${userData['user']['landmark']}, ${userData['user']['city']}, ${userData['user']['state']}, ${userData['user']['pincode']}";
    }

    var cartRes = await http.get(Uri.parse(
        'https://mini.piere.in.net/api/get_cart.php?action=fetch&mobile=$mobile'));
    var cartData = json.decode(cartRes.body);
    setState(() {
      cartItems = List<Map<String, dynamic>>.from(cartData['data'] ?? []);
      calculateTotals();
    });
  }

  void calculateTotals() {
    totalAmount = 0;
    for (var item in cartItems) {
      double price = double.tryParse(item['price'].toString()) ?? 0;
      int qty = item['qty'] ?? 1;
      totalAmount += price * qty;
    }
    gst = totalAmount * 0.18;
    netTotal = totalAmount + gst;
  }

  Future<void> placeOrder() async {
    if (mobile == null) return;
    String cartItemsJson = json.encode(cartItems);

    var response = await http.post(
      Uri.parse('https://mini.piere.in.net/api/place_order.php'),
      body: {
        'paym': "COD",
        'mobile': mobile,
        'netot': netTotal.toString(),
        'name': firstNameController.text,
        'address': addressController.text,
        'qty': cartItems
            .fold<int>(0, (sum, item) => sum + (item['qty'] as int))
            .toString(),
        'cart_items': cartItemsJson,
      },
    );

    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      Get.snackbar(
        "Success",
        "Order placed successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      setState(() {
        cartItems.clear();
      });

      final BottomNavController bottomNavController = Get.find();
      bottomNavController.changePage(1);

      Get.offAll(() => Scaffold(
            body: Obx(() => IndexedStack(
                  index: bottomNavController.selectedIndex.value,
                  children: [
                    BottomNavBarWidget().getPage(0),
                    BottomNavBarWidget().getPage(1),
                    BottomNavBarWidget().getPage(2),
                    BottomNavBarWidget().getPage(3),
                  ],
                )),
            bottomNavigationBar: BottomNavBarWidget(),
          ));
    } else {
      Get.snackbar(
        "Error",
        "Failed to place order",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        foregroundColor: Color(0xFFebcd66),
        backgroundColor: Colors.black,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // Order summary card
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order Summary",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Amount"),
                              Text("₹${totalAmount.toStringAsFixed(2)}"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("GST 18%"),
                              Text("₹${gst.toStringAsFixed(2)}"),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Net Total",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text("₹${netTotal.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Delivery address
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Delivery Address",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          TextField(
                            controller: firstNameController,
                            decoration: InputDecoration(
                                labelText: "First Name",
                                border: OutlineInputBorder()),
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: addressController,
                            maxLines: 3,
                            decoration: InputDecoration(
                                labelText: "Full Address",
                                border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Proceed button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await placeOrder();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text("Place Order",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
