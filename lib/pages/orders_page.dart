// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'order_details_page.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;
  String? mobile;
  bool isLoggedIn = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    checkLoginAndFetch();

    // Fetch orders every second
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (isLoggedIn) {
        fetchOrders();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> checkLoginAndFetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobile = prefs.getString('mobile');

    if (mobile == null || mobile!.isEmpty) {
      setState(() {
        isLoggedIn = false;
        isLoading = false;
      });
    } else {
      isLoggedIn = true;
      await fetchOrders();
    }
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.post(
        Uri.parse("https://mini.piere.in.net/api/get_orders.php"),
        body: {"mobile": mobile},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'success') {
          List<Map<String, dynamic>> newOrders =
              List<Map<String, dynamic>>.from(data['orders']);

          // Only update state if orders actually changed
          if (!listEquals(orders, newOrders)) {
            setState(() {
              orders = newOrders;
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "received":
        return Colors.blue;
      case "shipped":
        return Colors.orange;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        foregroundColor: Color(0xFFebcd66),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : !isLoggedIn
              ? buildEmptyOrders("Please log in to view your orders")
              : orders.isEmpty
                  ? buildEmptyOrders("No orders found")
                  : ListView.builder(
                      padding: EdgeInsets.all(12),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Order ID: FC00${order['id']}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            _getStatusColor(order['status']),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        order['status'],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text("Name: ${order['name']}",
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(height: 4),
                                Text("Amount: ₹${order['netot']}",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.green)),
                                SizedBox(height: 4),
                                Text("Quantity: ${order['qty']}",
                                    style: TextStyle(fontSize: 15)),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      Get.to(() => OrderDetailsPage(
                                          orderId: order['id'].toString()));
                                    },
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

  Widget buildEmptyOrders(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 90, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(fontSize: 20, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper to compare two lists of maps
  bool listEquals(
      List<Map<String, dynamic>> list1, List<Map<String, dynamic>> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (!mapEquals(list1[i], list2[i])) return false;
    }
    return true;
  }

  bool mapEquals(Map<String, dynamic> map1, Map<String, dynamic> map2) {
    if (map1.length != map2.length) return false;
    for (var key in map1.keys) {
      if (map1[key] != map2[key]) return false;
    }
    return true;
  }
}
