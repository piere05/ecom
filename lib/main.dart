import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/bottom_nav_bar.dart';
import 'pages/login_page.dart';

/// Conditionally import web URL strategy
// ignore: uri_does_not_exist
import 'package:flutter_web_plugins/flutter_web_plugins.dart'
    if (dart.library.io) 'stub.dart';

void main() {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy()); // Web only
  }
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
          switch (bottomNavController.selectedIndex.value) {
            case 0:
              return BottomNavBarWidget().getPage(0);
            case 1:
              return BottomNavBarWidget().getPage(1);
            case 2:
              return BottomNavBarWidget().getPage(2);
            case 3:
              return BottomNavBarWidget().getPage(3);
            case 4:
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
