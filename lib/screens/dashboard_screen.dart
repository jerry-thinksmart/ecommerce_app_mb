import 'package:ecommerce_app/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/screens/upload_product_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  static const _categories = [
    _CategoryItem('🍔', true),
    _CategoryItem('🍟', false),
    _CategoryItem('🍗', false),
    _CategoryItem('🍣', false),
    _CategoryItem('🌭', false),
  ];

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadProducts);
  }

  Future<void> _loadProducts() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    }

    try {
      await context.read<ProductsProvider>().fetchProducts();
    } on ProductProviderException catch (error) {
      if (mounted) setState(() => _loadError = error.message);
    } catch (_) {
      if (mounted) {
        setState(
          () => _loadError = 'Could not load products. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductsProvider>().products;

    return Scaffold(
      backgroundColor: const Color(0xFFF8E8B6),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).pushNamed(UploadProductScreen.routeName);
          if (mounted) await _loadProducts();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
      ),
      body: SafeArea(
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
          child: Container(
            color: Colors.white,
            width: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _DashboardHeader(),
                  const SizedBox(height: 34),
                  const _SearchBox(),
                  const SizedBox(height: 28),
                  _SectionHeader(
                    title: 'Category',
                    actionText: 'See All',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 20),
                  const _CategoryList(),
                  const SizedBox(height: 32),
                  const Text(
                    'Products',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ProductsContent(
                    products: products,
                    isLoading: _isLoading,
                    error: _loadError,
                    onRetry: _loadProducts,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.grid_view_rounded),
          color: const Color(0xFF898989),
          iconSize: 34,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          tooltip: 'Menu',
        ),
        Container(
          height: 58,
          width: 58,
          decoration: const BoxDecoration(
            color: Color(0xFFFFCF58),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Color(0xFF3D3D3D),
            size: 34,
          ),
        ),
      ],
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFFE2E2E2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFF9C9C9C), size: 34),
          const SizedBox(width: 14),
          Text(
            'Search Products',
            style: TextStyle(
              color: const Color(0xFF9C9C9C).withValues(alpha: 0.65),
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: onActionTap,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF575757),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
          child: Text(
            actionText,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DashboardScreen._categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = DashboardScreen._categories[index];

          return Container(
            height: 78,
            width: 78,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: item.isSelected ? const Color(0xFFFFEDC1) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: item.isSelected
                    ? const Color(0xFFFFEDC1)
                    : const Color(0xFFE9E9E9),
                width: 1.5,
              ),
              boxShadow: [
                if (item.isSelected)
                  BoxShadow(
                    color: const Color(0xFFFFC84B).withValues(alpha: 0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
              ],
            ),
            child: Text(item.icon, style: const TextStyle(fontSize: 40)),
          );
        },
      ),
    );
  }
}

class _ProductsContent extends StatelessWidget {
  const _ProductsContent({
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Text(
            'No products available yet.',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 22,
        mainAxisSpacing: 30,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        return _ProductCard(product: products[index]);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              top: 56,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8B9),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.fromLTRB(12, 96, 12, 16),
                child: Column(
                  children: [
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: Container(
                        height: 38,
                        constraints: const BoxConstraints(minWidth: 104),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: SizedBox(
                height: 138,
                width: constraints.maxWidth,
                child: _ProductImage(imageUrl: product.imageUrl),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return const _ProductPlaceholder();

    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const _ProductPlaceholder(),
    );
  }
}

class _ProductPlaceholder extends StatelessWidget {
  const _ProductPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      fit: BoxFit.contain,
      child: Icon(Icons.shopping_bag_rounded, color: Color(0xFFFFB000)),
    );
  }
}

class _CategoryItem {
  const _CategoryItem(this.icon, this.isSelected);

  final String icon;
  final bool isSelected;
}
