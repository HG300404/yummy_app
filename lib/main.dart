

import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:food_app/ui/admin/admin_page.dart';
import 'package:food_app/ui/screens/detail_dish_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var cart = FlutterCart();
  await cart.initializeCart(isPersistenceSupportEnabled: true);

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Onboarding Screen',
      home: DetailDish(),
      debugShowCheckedModeBanner: false,
    );
  }
}