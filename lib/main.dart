// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'widgets/bottom_nav_bar.dart';
import 'pages/login_page.dart';

void main() {
  setUrlStrategy(PathUrlStrategy()); // remove # from URL
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final BottomNavController bottomNavController = Get.put(
    BottomNavController(),
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final BottomNavController bottomNavController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // Add LoginPage as one of the IndexedStack children
          switch (bottomNavController.selectedIndex.value) {
            case 0:
              return BottomNavBarWidget().getPage(0);
            case 1:
              return BottomNavBarWidget().getPage(1);
            case 2:
              return BottomNavBarWidget().getPage(2);
            case 3:
              return BottomNavBarWidget().getPage(3);
            case 4: // LoginPage
              return LoginPage();
            default:
              return BottomNavBarWidget().getPage(0);
          }
        }),
      ),
      bottomNavigationBar: BottomNavBarWidget(),
    );
  }
}
