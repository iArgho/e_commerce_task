import 'package:e_commerce_task/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class Ecommerce extends StatelessWidget {
  const Ecommerce({super.key}); // Constructor should not have parentheses

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const HomeScreen(), // Make sure to instantiate HomePage
    );
  }
}
