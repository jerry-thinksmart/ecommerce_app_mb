import 'package:ecommerce_app/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  static const routeName = '/edit-products';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool _isLoading = false;
  String? _error;

   


  @override
  void initState() {
    super.initState();
    if (context.read<ProductsProvider>().products.isEmpty) {
      Future.microtask(_loadProducts);
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await context.read<ProductsProvider>().fetchProducts();
    } on ProductProviderException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not load products.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showFilters() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort products',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.arrow_upward_rounded),
                title: const Text('Price: low to high'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.arrow_downward_rounded),
                title: const Text('Price: high to low'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().products;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 76,
        leadingWidth: 62,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: const Color(0xFF9397A7),
          iconSize: 23,
        ),
        titleSpacing: 0,
        title: const Text(
          'Noodles',
          style: TextStyle(
            color: Color(0xFF111111),
            fontFamily: 'Poppins',
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilters,
            tooltip: 'Filter products',
            icon: const Icon(Icons.tune_rounded),
            color: const Color(0xFF9397A7),
            iconSize: 29,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: _ProductsBody(
        products: products,
        isLoading: _isLoading,
        error: _error,
        onRetry: _loadProducts,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: 78,
        height: 78,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF1235).withValues(alpha: 0.28),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: FloatingActionButton(
          heroTag: 'edit-products-cart',
          onPressed: () {},
          elevation: 0,
          backgroundColor: const Color(0xFFFF1235),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(Icons.shopping_cart_rounded, size: 35),
        ),
      ),
    );
  }
}

class _ProductsBody extends StatelessWidget {
  const _ProductsBody({
    required this.products,
    required this.isLoading,
    required this.error,
    required this.onRetry,
  });

  final List<Product> products;
  final bool isLoading;
  final String? error;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF1235)),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 14),
              FilledButton(onPressed: onRetry, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products available.',
          style: TextStyle(fontFamily: 'Poppins', color: Color(0xFF8D8F98)),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(32, 8, 32, 118),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => _ProductTile(product: products[index]),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    print(product.id);
        return Material(
      color: const Color(0xFFF8F8FB),
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 16, 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Center(child: _ProductImage(imageUrl: product.imageUrl)),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 3,
                child: Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF92949C),
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    height: 1.28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: product.price.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(
                          text: ' zł',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                       
                      ],
                    ),
                    style: const TextStyle(
                      color: Color(0xFF343437),
                      fontFamily: 'Poppins',
                      height: 1,
                    ),
                  ),
                   IconButton(onPressed: (){
                      Navigator.of(context).pushReplacementNamed('/upload-product', arguments:  product.id);

                   }, icon: Icon(Icons.edit)),
                ],

              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) {
      return const Icon(
        Icons.inventory_2_outlined,
        size: 72,
        color: Color(0xFFB8BBC5),
      );
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      width: double.infinity,
      errorBuilder: (_, _, _) => const Icon(
        Icons.inventory_2_outlined,
        size: 72,
        color: Color(0xFFB8BBC5),
      ),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox.square(
            dimension: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFB8BBC5),
            ),
          ),
        );
      },
    );
  }
}
