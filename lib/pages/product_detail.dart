// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_kit/pages/home_page.dart';
import '../pages/login_page.dart';

class ProductDetail extends StatefulWidget {
  final int id;
  ProductDetail({required this.id});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Map<String, dynamic>? productData;
  int _currentPage = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final url = Uri.parse(
      "https://gurunath.piere.in.net/api/select-product-det.php?id=${widget.id}",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        productData = json.decode(response.body);
      });
      _autoScroll();
    }
  }

  void _autoScroll() {
    Future.delayed(Duration(seconds: 3), () {
      if (_pageController.hasClients && productData != null) {
        List<String> images = _getImages();
        int nextPage = (_currentPage + 1) % images.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = nextPage;
        });
      }
      _autoScroll();
    });
  }

  List<String> _getImages() {
    if (productData == null) return [];
    return [
      (productData!['image1'] ?? '') as String,
      (productData!['image2'] ?? '') as String,
      (productData!['image3'] ?? '') as String,
      (productData!['image4'] ?? '') as String,
    ].where((img) => img.isNotEmpty).toList();
  }

  Future<bool> _checkInCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobile = prefs.getString('mobile');
    if (mobile == null || mobile.isEmpty) return false;

    final url = Uri.parse(
      "https://gurunath.piere.in.net/api/check_cart.php?mobile=$mobile&product_id=${widget.id}",
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['in_cart'] == true ||
          data['in_cart'] == 1 ||
          data['in_cart'] == "1") {
        return true;
      }
    }
    return false;
  }

  Future<void> _addToCart(String mobile, int productId) async {
    final url = Uri.parse("https://gurunath.piere.in.net/api/add_to_cart.php");
    final response = await http.post(
      url,
      body: {"mobile": mobile, "product_id": productId.toString()},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true) {
        Get.snackbar(
          "Cart",
          data['message'] ?? "Updated",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 2),
        );
        setState(() {});
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Something went wrong",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 2),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (productData == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    //final product_id = productData!['id'] ?? '';
    final images = _getImages();

    return Scaffold(
      bottomNavigationBar: FutureBuilder<bool>(
        future: _checkInCart(),
        builder: (context, snapshot) {
          bool inCart = snapshot.data ?? false;

          return Container(
            height: 60,
            //color: Colors.black, // optional background for bar
            padding: EdgeInsets.symmetric(horizontal: 8), // spacing on sides
            child: Row(
              children: [
                // Add to Cart button
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? mobile = prefs.getString('mobile');
                      if (mobile == null || mobile.isEmpty) {
                        Get.to(() => LoginPage());
                      } else {
                        await _addToCart(mobile, widget.id);
                        setState(() {});
                      }
                    },
                    child: Center(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                if (inCart)
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => HomePage());
                      },
                      child: Center(
                        child: Text(
                          "Go to Cart",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),

      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                color: Colors.black,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                    width: 200,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 400,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          images[index],
                          fit: BoxFit.contain,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productData!['name'] ?? '',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          productData!['brand_name'] ?? '',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "₹${productData!['current_price']}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "₹${productData!['mrp']}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          productData!['description'] ?? '',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
