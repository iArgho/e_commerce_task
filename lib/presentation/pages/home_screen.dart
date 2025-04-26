import 'package:e_commerce_task/model/product_model.dart';
import 'package:e_commerce_task/network/%20network_service.dart';
import 'package:e_commerce_task/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  bool isLoading = true;
  String errorMessage = '';
  String searchQuery = '';
  String sortOption = 'high_to_low'; // default sorting

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      allProducts = await ProductService.fetchProducts();
      _filterAndSortProducts();
    } catch (e) {
      errorMessage = 'Failed to load products';
    }
    setState(() => isLoading = false);
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
                  product.category.toLowerCase().contains(searchQuery),
            )
            .toList();

    filteredProducts.sort((a, b) {
      if (sortOption == 'low_to_high') {
        return a.price.compareTo(b.price);
      } else {
        return b.price.compareTo(a.price);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-Commerce',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : Column(
                  children: [
                    // Search Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: _onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sort Dropdown
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: sortOption,
                            items: const [
                              DropdownMenuItem(
                                value: 'high_to_low',
                                child: Text('Price: High to Low'),
                              ),
                              DropdownMenuItem(
                                value: 'low_to_high',
                                child: Text('Price: Low to High'),
                              ),
                            ],
                            onChanged: _onSortChanged,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Product Grid
                    Expanded(
                      child:
                          filteredProducts.isEmpty
                              ? const Center(child: Text('No products found.'))
                              : GridView.builder(
                                itemCount: filteredProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      mainAxisExtent: 300,
                                    ),
                                itemBuilder: (context, index) {
                                  return ProductCard(
                                    product: filteredProducts[index],
                                  );
                                },
                              ),
                    ),
                  ],
                ),
      ),
    );
  }
}
