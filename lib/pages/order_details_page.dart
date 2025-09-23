// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  const OrderDetailsPage({required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Map<String, dynamic>? orderData;
  List<Map<String, dynamic>> orderProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      final response = await http.post(
        Uri.parse("https://mini.piere.in.net/api/get_order_details.php"),
        body: {"order_id": widget.orderId},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            orderData = data['order'];
            orderProducts =
                List<Map<String, dynamic>>.from(orderData!['products'] ?? []);
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching order: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #FC00${widget.orderId}"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber[600],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : orderData == null
              ? Center(
                  child: Text(
                    "Order not found",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Information Card
                      Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order Information",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              buildInfoRow(
                                  "Order ID", "FC00${orderData!['id'] ?? ''}"),
                              buildInfoRow("Name", orderData!['name'] ?? ''),
                              buildInfoRow(
                                  "Address", orderData!['address'] ?? ''),
                              buildInfoRow(
                                  "Mobile", orderData!['mobile'] ?? ''),
                              buildInfoRow("Order Date",
                                  orderData!['created_datetime'] ?? ''),
                            ],
                          ),
                        ),
                      ),

                      // Products Heading
                      Text(
                        "Products",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),

                      // Products List
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: orderProducts.length,
                        itemBuilder: (context, index) {
                          final item = orderProducts[index];
                          double price =
                              double.tryParse(item['p_price'].toString()) ?? 0;
                          int qty = int.tryParse(item['qty'].toString()) ?? 1;
                          double total = price * qty;

                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            margin: EdgeInsets.symmetric(vertical: 6),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                      image: DecorationImage(
                                        image: NetworkImage(item['image1'] ??
                                            'https://via.placeholder.com/150'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),

                                  // Product Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['product_name'] ?? '',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Brand: ${item['brand_name'] ?? 'Unknown'}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700]),
                                        ),
                                        SizedBox(height: 4),
                                        Text("Qty: $qty",
                                            style: TextStyle(fontSize: 14)),
                                        SizedBox(height: 4),
                                        Text("Price: ₹$price",
                                            style: TextStyle(fontSize: 14)),
                                        SizedBox(height: 4),
                                        Text(
                                          "Total: ₹${total.toStringAsFixed(2)}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 20),

                      // Bill Summary Card
                      Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bill Summary",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              buildInfoRow(
                                  "Order ID", "FC00${orderData!['id'] ?? ''}"),
                              buildInfoRow("Total Price",
                                  "₹${orderData!['net_total']?.toStringAsFixed(2) ?? '0.00'}"),
                                                   
                              buildInfoRow("GST 18%", "₹${((orderData!['net_total'] ?? 0) * 0.18).toStringAsFixed(2)}"),

                              Divider(),
                              buildInfoRow(
                                  "Net Total",
                                  "₹${(orderData!['net_total'] ?? 0).toStringAsFixed(2)}",
                                  isBold: true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget buildInfoRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15, fontWeight: isBold ? FontWeight.bold : null)),
          SizedBox(width: 10),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontSize: 15, fontWeight: isBold ? FontWeight.bold : null)),
          )
        ],
      ),
    );
  }
}
