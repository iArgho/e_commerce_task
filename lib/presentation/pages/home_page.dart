import 'package:e_commerce_task/model/product_model.dart';
import 'package:e_commerce_task/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  String sortOption = 'low_to_high';

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Simulating loading products from an API
  void _loadProducts() async {
    // Mock products
    var products = [
      Product(
        id: 1,
        title: "iPhone 13",
        description: "Latest model with A15 chip.",
        price: 999,
        discountPercentage: 10,
        rating: 4.8,
        stock: 10,
        brand: "Apple",
        category: "Smartphones",
        thumbnail: "https://example.com/iphone13.jpg",
        images: [
          "https://example.com/iphone13_1.jpg",
          "https://example.com/iphone13_2.jpg",
        ],
      ),
      Product(
        id: 2,
        title: "Galaxy S21",
        description: "Flagship smartphone with Exynos processor.",
        price: 899,
        discountPercentage: 15,
        rating: 4.6,
        stock: 15,
        brand: "Samsung",
        category: "Smartphones",
        thumbnail: "https://example.com/galaxys21.jpg",
        images: [
          "https://example.com/galaxys21_1.jpg",
          "https://example.com/galaxys21_2.jpg",
        ],
      ),
      // Add more mock products
    ];

    setState(() {
      allProducts = products;
      filteredProducts = List.from(allProducts);
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _filterAndSortProducts();
    });
  }

  void _onSortChanged(String? value) {
    if (value == null) return;
    setState(() {
      sortOption = value;
      _filterAndSortProducts();
    });
  }

  void _filterAndSortProducts() {
    filteredProducts =
        allProducts
            .where(
              (product) =>
                  product.title.toLowerCase().contains(searchQuery) ||
                  product.brand.toLowerCase().contains(searchQuery) ||
                  product.description.toLowerCase().contains(searchQuery) ||
                  product.category.toLowerCase().contains(searchQuery),
            )
            .toList();

    filteredProducts.sort((a, b) {
      if (sortOption == 'low_to_high') {
        return a.price.compareTo(b.price);
      } else if (sortOption == 'high_to_low') {
        return b.price.compareTo(a.price);
      } else if (sortOption == 'rating') {
        return b.rating.compareTo(a.rating);
      } else {
        return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-Commerce'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton<String>(
                  value: sortOption,
                  items: const [
                    DropdownMenuItem(
                      value: 'low_to_high',
                      child: Text('Price: Low to High'),
                    ),
                    DropdownMenuItem(
                      value: 'high_to_low',
                      child: Text('Price: High to Low'),
                    ),
                    DropdownMenuItem(value: 'rating', child: Text('Rating')),
                  ],
                  onChanged: _onSortChanged,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  filteredProducts.isEmpty
                      ? const Center(child: Text('No products found.'))
                      : GridView.builder(
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 280,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          return ProductCard(product: filteredProducts[index]);
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
