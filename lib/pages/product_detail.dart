// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_final_fields

import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  final int id;
  ProductDetail({required this.id});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final List<String> productImages = [
    '../assets/banner1.webp',
    '../assets/banner1.webp',
    '../assets/banner1.webp',
    '../assets/banner1.webp',
  ];

  int _currentPage = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Auto scroll
    Future.delayed(Duration.zero, () {
      _autoScroll();
    });
  }

  void _autoScroll() {
    Future.delayed(Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % productImages.length;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.black,
        height: 60,
        child: TextButton(
          onPressed: () {},
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
                height: 120,
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
                    height: 250,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: productImages.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          productImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(productImages.length, (index) {
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
                          "Product Name",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Brand Name",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "₹999",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "₹1299",
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
                          "Description of the product goes here. You can show all the details about this product in this section.",
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 80), // space for bottom button
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
