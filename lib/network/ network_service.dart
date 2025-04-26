import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:e_commerce_task/model/product_model.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  static Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$_baseUrl/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to fetch products. Status code: ${response.statusCode}',
      );
    }
  }
}
