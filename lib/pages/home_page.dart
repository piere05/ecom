// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'product_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top logo section
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Image.asset('logo.png', width: 320, height: 150)],
              ),
            ),
            SizedBox(height: 20),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
            ),
            SizedBox(height: 30),
            // Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset('banner1.webp', fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Product cards (2 per row)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ProductCard(
                      id: 1,
                      image: 'assets/logo.png',
                      name: 'Formal Shirt',
                      price: 579,
                      originalPrice: 1099,
                      brand: 'Allen Solly',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ProductCard(
                      id: 2,
                      image: 'assets/logo.png',
                      name: 'Round Neck T-Shirt',
                      price: 584,
                      originalPrice: 1299,
                      brand: 'Peter England',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
