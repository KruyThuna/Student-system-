import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Ecommerce',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const HomePage(),
    );
  }
}

class Product {
  String name;
  String description;
  double price;
  String imageUrl;
  String category;
  int stock;
  int returns;
  int problems;
  double refundPaid;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.stock = 0,
    this.returns = 0,
    this.problems = 0,
    this.refundPaid = 0.0,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentSlide = 0;

  final List<Product> _products = [
    Product(
      name: 'Smart Watch',
      description: 'Track fitness, sleep, and notifications in one stylish device.',
      price: 129.99,
      imageUrl: 'https://picsum.photos/seed/watch/800/500',
      category: 'Wearables',
      stock: 24,
      returns: 1,
      problems: 2,
      refundPaid: 19.99,
    ),
    Product(
      name: 'Wireless Earbuds',
      description: 'Enjoy powerful sound with noise isolation and long battery life.',
      price: 79.99,
      imageUrl: 'https://picsum.photos/seed/earbuds/800/500',
      category: 'Audio',
      stock: 40,
      returns: 0,
      problems: 1,
      refundPaid: 0.0,
    ),
    Product(
      name: 'Travel Backpack',
      description: 'Durable, water-resistant pack with laptop and organizer pockets.',
      price: 64.50,
      imageUrl: 'https://picsum.photos/seed/backpack/800/500',
      category: 'Travel',
      stock: 18,
      returns: 2,
      problems: 0,
      refundPaid: 25.50,
    ),
    Product(
      name: 'Running Shoes',
      description: 'Comfortable design for daily training and weekend runs.',
      price: 99.90,
      imageUrl: 'https://picsum.photos/seed/shoes/800/500',
      category: 'Footwear',
      stock: 12,
      returns: 0,
      problems: 0,
      refundPaid: 0.0,
    ),
  ];

  final List<String> _categories = ['All', 'Wearables', 'Audio', 'Travel', 'Footwear'];
  String _selectedCategory = 'All';

  final List<Map<String, String>> _slides = [
    {
      'title': 'About App Ecommerce',
      'content': 'A modern shopping demo with product cards and a friendly slideshow.',
    },
    {
      'title': 'Built for Users',
      'content': 'Provides fast browsing and clear product details for easy buying decisions.',
    },
    {
      'title': 'Flexible Design',
      'content': 'A clean mobile layout that is easy to extend with real product data.',
    },
  ];

  int get _totalStock => _products.fold(0, (value, product) => value + product.stock);
  double get _averageStock => _products.isEmpty ? 0 : _totalStock / _products.length;
  int get _totalReturns => _products.fold(0, (value, product) => value + product.returns);
  int get _totalProblems => _products.fold(0, (value, product) => value + product.problems);
  List<Product> get _filteredProducts {
    if (_selectedCategory == 'All') {
      return _products;
    }
    return _products.where((product) => product.category == _selectedCategory).toList();
  }

  double get _refundPaidTotal => _products.fold(0, (value, product) => value + product.refundPaid);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showProductDialog({Product? product}) {
    final isUpdate = product != null;
    final nameController = TextEditingController(text: product?.name ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    final priceController = TextEditingController(text: product?.price.toStringAsFixed(2) ?? '0.00');
    final stockController = TextEditingController(text: product?.stock.toString() ?? '0');
    final imageController = TextEditingController(text: product?.imageUrl ?? 'https://picsum.photos/seed/new/800/500');
    String categoryValue = product?.category ?? _categories.firstWhere((c) => c != 'All', orElse: () => 'Wearables');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isUpdate ? 'Update Product' : 'Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                DropdownButtonFormField<String>(
                  initialValue: categoryValue,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories
                      .where((c) => c != 'All')
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      categoryValue = value;
                    }
                  },
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock Count'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final description = descriptionController.text.trim();
                final price = double.tryParse(priceController.text) ?? 0.0;
                final stock = int.tryParse(stockController.text) ?? 0;
                final imageUrl = imageController.text.trim();

                if (name.isEmpty || description.isEmpty) return;

                setState(() {
                  if (product != null) {
                    product.name = name;
                    product.description = description;
                    product.price = price;
                    product.stock = stock;
                    product.imageUrl = imageUrl;
                    product.category = categoryValue;
                  } else {
                    _products.add(Product(
                      name: name,
                      description: description,
                      price: price,
                      imageUrl: imageUrl,
                      category: categoryValue,
                      stock: stock,
                    ));
                  }
                });

                Navigator.of(context).pop();
              },
              child: Text(isUpdate ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  void _adjustStock(Product product, int delta) {
    setState(() {
      product.stock = (product.stock + delta).clamp(0, 9999);
    });
  }

  void _recordReturn(Product product) {
    setState(() {
      product.returns += 1;
      product.refundPaid += product.price * 0.15;
    });
  }

  void _recordProblem(Product product) {
    setState(() {
      product.problems += 1;
    });
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(label,
          style: TextStyle(color: _darken(color), fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Color _darken(Color color, [double amount = .25]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  Widget _buildProductTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 700;
        return Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final selected = category == _selectedCategory;
                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.blue.shade600,
                    backgroundColor: Colors.grey.shade200,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 2 : 1,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: isTablet ? 1.7 : 1.05,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(child: CircularProgressIndicator()),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(child: Icon(Icons.broken_image, size: 40)),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.category.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                      fontSize: 12,
                                    )),
                                const SizedBox(height: 6),
                                Text(product.name,
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(product.description,
                                    style: const TextStyle(fontSize: 15, color: Colors.black87)),
                                const Spacer(),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildBadge('Stock: ${product.stock}', Colors.green),
                                    _buildBadge('Returns: ${product.returns}', Colors.orange),
                                    _buildBadge('Problems: ${product.problems}', Colors.red),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                    ElevatedButton(
                                      onPressed: () => _showProductDialog(product: product),
                                      child: const Text('Edit'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDashboardTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildMetricCard('Total Products', '${_products.length}', Icons.inventory_2, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard('Stock Total', '$_totalStock', Icons.storage, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMetricCard('Average Stock', _averageStock.toStringAsFixed(1), Icons.bar_chart, Colors.purple)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard('Return Count', '$_totalReturns', Icons.undo, Colors.orange)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMetricCard('Problems', '$_totalProblems', Icons.report_problem, Colors.red)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard('Refund Paid', '\$${_refundPaidTotal.toStringAsFixed(2)}', Icons.payment, Colors.teal)),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _showProductDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(product.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('\$${product.price.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(product.description, style: const TextStyle(color: Colors.black87)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          children: [
                            _buildBadge('Stock ${product.stock}', Colors.green),
                            _buildBadge('Returns ${product.returns}', Colors.orange),
                            _buildBadge('Problems ${product.problems}', Colors.red),
                            _buildBadge('Refund \$${product.refundPaid.toStringAsFixed(2)}', Colors.teal),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => _adjustStock(product, -1),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                IconButton(
                                  onPressed: () => _adjustStock(product, 1),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () => _recordReturn(product),
                                  child: const Text('Return'),
                                ),
                                TextButton(
                                  onPressed: () => _recordProblem(product),
                                  child: const Text('Problem'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      product.refundPaid += 10.0;
                                    });
                                  },
                                  child: const Text('Pay Refund'),
                                ),
                                TextButton(
                                  onPressed: () => _showProductDialog(product: product),
                                  child: const Text('Edit'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentSlide = index;
                });
              },
              itemBuilder: (context, index) {
                final slide = _slides[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(slide['title'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 16),
                          Text(slide['content'] ?? '',
                              style: const TextStyle(color: Colors.white70, fontSize: 17, height: 1.4)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: _currentSlide == index ? 16 : 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _currentSlide == index ? Colors.blue : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: () {
              final nextPage = (_currentSlide + 1) % _slides.length;
              _pageController.animateToPage(
                nextPage,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
              );
            },
            child: const Text('Next Slide', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab(BuildContext context) {
    final featuredPhone = Product(
      name: 'ProPhone X',
      description: 'A future-ready smartphone with AI camera, 5G speed, and an OLED edge display.',
      price: 999.00,
      imageUrl: 'https://picsum.photos/seed/smartphone/900/600',
      category: 'Smartphone',
      stock: 16,
      returns: 0,
      problems: 0,
      refundPaid: 0.0,
    );

    final List<Map<String, Object>> techFeatures = [
      {'label': '5G Ultra Speed', 'icon': Icons.network_cell},
      {'label': 'AI Camera', 'icon': Icons.camera_alt},
      {'label': 'OLED Display', 'icon': Icons.screen_search_desktop},
      {'label': 'Fast Charging', 'icon': Icons.bolt},
      {'label': 'Biometric Security', 'icon': Icons.fingerprint},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Home',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Smart Phone Technology',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Discover the latest smartphone innovation with powerful performance, premium display, and intelligent camera features.',
                    style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
                  ),
                  const SizedBox(height: 18),
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                        onPressed: () => DefaultTabController.of(context).animateTo(1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade700,
                        ),
                        child: const Text('Explore Products'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: Image.network(
                    featuredPhone.imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(featuredPhone.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(featuredPhone.description,
                          style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.4)),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: techFeatures.map((feature) {
                          return Chip(
                            label: Text(feature['label']! as String),
                            avatar: Icon(feature['icon'] as IconData, size: 18, color: Colors.blue.shade700),
                            backgroundColor: Colors.blue.shade50,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${featuredPhone.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          Builder(
                            builder: (context) {
                              return ElevatedButton(
                                onPressed: () => DefaultTabController.of(context).animateTo(1),
                                child: const Text('Buy Now'),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Technology Highlights', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 2,
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TechRow(icon: Icons.speed, label: 'Ultra-fast 5G connectivity'),
                  SizedBox(height: 12),
                  _TechRow(icon: Icons.camera_alt, label: 'AI-powered camera system'),
                  SizedBox(height: 12),
                  _TechRow(icon: Icons.battery_charging_full, label: 'Fast charging support'),
                  SizedBox(height: 12),
                  _TechRow(icon: Icons.security, label: 'Face and fingerprint security'),
                  SizedBox(height: 12),
                  _TechRow(icon: Icons.color_lens, label: 'Vibrant OLED display'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('App Ecommerce'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Home', icon: Icon(Icons.home)),
              Tab(text: 'Products', icon: Icon(Icons.shopping_bag)),
              Tab(text: 'Dashboard', icon: Icon(Icons.dashboard)),
              Tab(text: 'About', icon: Icon(Icons.info_outline)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHomeTab(context),
            _buildProductTab(),
            _buildDashboardTab(),
            _buildAboutTab(),
          ],
        ),
      ),
    );
  }
}

class _TechRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TechRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 15, color: Colors.black87))),
      ],
    );
  }
}
