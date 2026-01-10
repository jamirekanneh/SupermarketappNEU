import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

/* ---------------- PRODUCT MODEL ---------------- */
class Product {
  String id;
  String name;
  String category;
  double price;
  int stock;
  Uint8List? imageBytes;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.imageBytes,
  });
}

class _ProductsPageState extends State<ProductsPage> {
  final _productsRef = FirebaseFirestore.instance.collection('products');

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController stockCtrl = TextEditingController();

  String searchText = '';
  String selectedFilterCategory = 'All';
  String priceOrder = 'None';

  Uint8List? selectedImage;
  String selectedCategory = 'Fruits';
  String? editingProductId;

  final List<String> categories = [
    'Fruits',
    'Dairy',
    'Vegetables',
    'Baked goods',
  ];

  @override
  void dispose() {
    nameCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    super.dispose();
  }

  /* ---------------- DYNAMIC POPUP DIALOG ---------------- */
  void _showDynamicAlert({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => Container(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: color.withOpacity(0.2),
                    child: Icon(icon, color: color, size: 40),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Done", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 10),
            Expanded(child: _productGrid()),
            const SizedBox(height: 10),
            _addProductSection(),
          ],
        ),
      ),
    );
  }

  /* ---------------- HEADER ---------------- */
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Products Inventory",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // 🔍 SEARCH
              Expanded(
                child: TextField(
                  onChanged: (val) {
                    setState(() => searchText = val.toLowerCase());
                  },
                  decoration: InputDecoration(
                    hintText: "Search product...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 📂 CATEGORY FILTER
              _filterDropdown(
                label: "Category",
                value: selectedFilterCategory,
                items: ['All', ...categories],
                onChanged: (val) => setState(() => selectedFilterCategory = val!),
              ),
              const SizedBox(width: 12),
              // 💰 PRICE SORT
              _filterDropdown(
                label: "Sort by",
                value: priceOrder,
                items: const ['None', 'LowHigh', 'HighLow'],
                displayMap: const {
                  'None': 'Price',
                  'LowHigh': 'Low → High',
                  'HighLow': 'High → Low',
                },
                onChanged: (val) => setState(() => priceOrder = val!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    Map<String, String>? displayMap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map((e) => DropdownMenuItem(
            value: e, 
            child: Text(displayMap?[e] ?? e)
          )).toList(),
        ),
      ),
    );
  }

  /* ---------------- PRODUCT GRID (WITH SORTING FIXED) ---------------- */
  Widget _productGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _productsRef.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        List<Product> products = snapshot.data!.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Product(
            id: doc.id,
            name: data['name'] ?? '',
            category: data['category'] ?? '',
            price: (data['price'] ?? 0).toDouble(),
            stock: data['stock'] ?? 0,
            imageBytes: data['image'] != null ? base64Decode(data['image']) : null,
          );
        }).toList();

        // 1. Search Filter
        if (searchText.isNotEmpty) {
          products = products.where((p) => p.name.toLowerCase().contains(searchText)).toList();
        }

        // 2. Category Filter
        if (selectedFilterCategory != 'All') {
          products = products.where((p) => p.category == selectedFilterCategory).toList();
        }

        // 3. Price Sorting
        if (priceOrder == 'LowHigh') {
          products.sort((a, b) => a.price.compareTo(b.price));
        } else if (priceOrder == 'HighLow') {
          products.sort((a, b) => b.price.compareTo(a.price));
        }

        if (products.isEmpty) {
          return const Center(child: Text("No products found"));
        }

        return GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.8,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) => _productCard(products[index]),
        );
      },
    );
  }

  /* ---------------- PRODUCT CARD ---------------- */
  Widget _productCard(Product product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFB7E3FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            height: 90,
            width: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: product.imageBytes != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(product.imageBytes!, fit: BoxFit.cover),
                  )
                : const Icon(Icons.image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(product.category),
                Text("${product.stock} Stock"),
                Text("${product.price.toStringAsFixed(0)} TL"),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _pillButton(text: "Edit", onTap: () => _editProduct(product)),
                    const SizedBox(width: 8),
                    _pillButton(text: "Delete", onTap: () => _deleteProduct(product.id)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _pillButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ),
    );
  }

  /* ---------------- ADD / EDIT SECTION ---------------- */
  Widget _addProductSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(editingProductId == null ? "Add Product" : "Edit Product",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(selectedImage!, fit: BoxFit.cover))
                  : const Icon(Icons.add_a_photo, color: Colors.blue),
            ),
          ),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Product Name")),
          TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Price")),
          TextField(controller: stockCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Stock")),
          DropdownButtonFormField(
            value: selectedCategory,
            items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) => setState(() => selectedCategory = val!),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: _saveProduct,
            child: Text(editingProductId == null ? "Save" : "Update"),
          ),
        ],
      ),
    );
  }

  /* ---------------- LOGIC ---------------- */
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null) setState(() => selectedImage = result.files.single.bytes);
  }

  Future<void> _saveProduct() async {
    if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty || stockCtrl.text.isEmpty || selectedImage == null) {
      _showDynamicAlert(
        title: "Missing Data",
        message: "Please ensure all fields are filled and an image is selected.",
        icon: Icons.warning_amber_rounded,
        color: const Color.fromARGB(255, 59, 6, 183),
      );
      return;
    }

    try {
      final data = {
        'name': nameCtrl.text.trim(),
        'category': selectedCategory,
        'price': double.parse(priceCtrl.text),
        'stock': int.parse(stockCtrl.text),
        'image': base64Encode(selectedImage!),
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (editingProductId == null) {
        await _productsRef.add(data);
        _showDynamicAlert(
          title: "Success!",
          message: "Item was Saved successfully!",
          icon: Icons.check_circle_outline,
          color: const Color.fromARGB(255, 28, 14, 180),
        );
      } else {
        await _productsRef.doc(editingProductId).update(data);
        _showDynamicAlert(
          title: "Updated!",
          message: "Item was Updated successfully!",
          icon: Icons.sync_rounded,
          color: const Color.fromARGB(255, 8, 4, 204),
        );
      }
      _clearForm();
    } catch (e) {
      _showDynamicAlert(title: "Error", message: e.toString(), icon: Icons.error_outline, color: Colors.red);
    }
  }

  void _editProduct(Product product) {
    setState(() {
      editingProductId = product.id;
      nameCtrl.text = product.name;
      priceCtrl.text = product.price.toString();
      stockCtrl.text = product.stock.toString();
      selectedCategory = product.category;
      selectedImage = product.imageBytes;
    });
  }

  Future<void> _deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  void _clearForm() {
    setState(() {
      editingProductId = null;
      nameCtrl.clear();
      priceCtrl.clear();
      stockCtrl.clear();
      selectedImage = null;
      selectedCategory = categories.first;
    });
  }
}