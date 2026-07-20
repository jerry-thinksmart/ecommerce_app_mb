import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.creatorId,
    required this.shipDate,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String creatorId;
  final DateTime? shipDate;
}

class ProductProviderException implements Exception {
  final String message;
  const ProductProviderException(this.message);

  @override
  String toString() => message;
}

class ProductsProvider with ChangeNotifier {
  ProductsProvider({String? authToken, String? userId, http.Client? client})
    : _authToken = authToken,
      _userId = userId,
      _client = client ?? http.Client();

  static const _databaseUrl =
      'https://test-app-23cc7-default-rtdb.firebaseio.com/';

  final http.Client _client;
  String? _authToken;
  String? _userId;
  List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  Product? findById(String id) {
    for (final product in _products) {
      if (product.id == id) return product;
    }
    return null;
  }

  void updateAuth({required String? authToken, required String? userId}) {
    _authToken = authToken;
    _userId = userId;
  }

  Future<void> addProduct({
    required String title,
    required String description,
    required double price,
    String imageUrl = '',
    required DateTime shipDate,
  }) async {
    final userId = _requireUserId();
    final response = await _client.post(
      _productsUri(),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title.trim(),
        'description': description.trim(),
        'price': price,
        'imageUrl': imageUrl.trim(),
        'creatorId': userId,
        'shipDate': shipDate.toIso8601String(),
      }),
    );

    _throwForBadResponse(response, 'Could not upload the product.');
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    final productId = responseData['name'] as String?;
    if (productId == null) {
      throw const ProductProviderException(
        'The server did not return a product ID.',
      );
    }

    _products.add(
      Product(
        id: productId,
        title: title.trim(),
        description: description.trim(),
        price: price,
        imageUrl: imageUrl.trim(),
        creatorId: userId,
        shipDate: shipDate,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final response = await _client.get(_productsUri());
    _throwForBadResponse(response, 'Could not load the products.');

    if (response.body == 'null') {
      _products = [];
      notifyListeners();
      return;
    }

    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    final loadedProducts = <Product>[];

    for (final entry in responseData.entries) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      loadedProducts.add(
        Product(
          id: entry.key,
          title: data['title'] as String? ?? '',
          description: data['description'] as String? ?? '',
          price: (data['price'] as num?)?.toDouble() ?? 0,
          imageUrl: data['imageUrl'] as String? ?? '',
          creatorId: data['creatorId'] as String? ?? '',
          shipDate: DateTime.tryParse(data['shipDate'] as String? ?? ''),
        ),
      );
    }

    _products = loadedProducts;
    notifyListeners();
  }

  Uri _productsUri() {
    final token = _authToken;
    return Uri.parse(
      '$_databaseUrl/products.json',
    ).replace(queryParameters: token == null ? null : {'auth': token});
  }

  String _requireUserId() {
    final userId = _userId;
    if (userId == null) {
      throw const ProductProviderException(
        'You must be logged in before uploading a product.',
      );
    }
    return userId;
  }

  void _throwForBadResponse(http.Response response, String fallbackMessage) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    var message = fallbackMessage;
    try {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      final error = responseData['error'];
      if (error is String) message = error;
      if (error is Map && error['message'] is String) {
        message = error['message'] as String;
      }
    } on FormatException {
      // Use the user-friendly fallback when Firebase returns non-JSON content.
    }
    throw ProductProviderException(message);
  }
}
