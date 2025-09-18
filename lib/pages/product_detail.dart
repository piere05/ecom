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

  @override
  Widget build(BuildContext context) {
    if (productData == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    //final product_id = productData!['id'] ?? '';
    final images = _getImages();

    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black,
        height: 60,
        child: TextButton(
          onPressed: () async {
            //print("Product ID: $product_id");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? mobile = prefs.getString('mobile');
            if (mobile == null || mobile.isEmpty) {
              Get.to(() => LoginPage());
            } else {
              Get.to(() => HomePage());
            }
          },
          child: Text(
            "Add to Cart",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
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
                  child: Image.asset('assets/logo.png', height: 80, width: 200),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        width: _currentPage == index ? 12 : 8,
                        height: _currentPage == index ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.black
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
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
