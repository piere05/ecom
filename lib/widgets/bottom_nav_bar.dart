// ignore_for_file: use_key_in_widget_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/home_page.dart';
import '../pages/orders_page.dart';
import '../pages/profile_page.dart';
import '../pages/cart_page.dart';
import '../pages/login_page.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }
}

class BottomNavBarWidget extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        currentIndex: controller.selectedIndex.value,
        onTap: (index) async {
          if (index == 3) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? mobile = prefs.getString('mobile');
            if (mobile == null || mobile.isEmpty) {
              Get.to(() => LoginPage());
            } else {
              controller.changePage(index);
            }
          } else {
            controller.changePage(index);
          }
        },
        selectedItemColor: Color(0xFFebcd66),
        unselectedItemColor: Colors.white.withOpacity(0.6),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return OrdersPage();
      case 2:
        return CartPage();
      case 3:
        return ProfilePage();
      default:
        return HomePage();
    }
  }
}
