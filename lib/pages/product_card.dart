// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'product_detail.dart';

String buildImageUrl(String path) {
  return Uri.encodeFull("https://gurunath.piere.in.net/adminln/$path");
}

class ProductCard extends StatelessWidget {
  final String image;
  final String name;
  final int price;
  final int originalPrice;
  final String brand;
  final int id;

  ProductCard({
    required this.image,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.brand,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  image,
                  height: constraints.maxHeight * 0.4, // dynamic image height
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: constraints.maxHeight * 0.4,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),

              // Content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Brand: $brand',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹$price',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '₹$originalPrice',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.to(() => ProductDetail(id: id));
                          },
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Buy Now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
