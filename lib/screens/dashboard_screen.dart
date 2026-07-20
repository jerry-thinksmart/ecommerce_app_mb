import 'package:flutter/material.dart';
import 'package:ecommerce_app/screens/upload_product_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const routeName = '/dashboard';

  static const _categories = [
    _CategoryItem('🍔', true),
    _CategoryItem('🍟', false),
    _CategoryItem('🍗', false),
    _CategoryItem('🍣', false),
    _CategoryItem('🌭', false),
  ];

  static const _foods = [
    _FoodItem(
      name: 'Noodles',
      price: '\$24.00',
      image: '🍜',
      color: Color(0xFFFFF8B9),
    ),
    _FoodItem(
      name: 'Chocolate',
      price: '\$15.00',
      image: '🧁',
      color: Color(0xFFFFD6C4),
    ),
    _FoodItem(
      name: 'French Fries',
      price: '\$18.00',
      image: '🍟',
      color: Color(0xFFFFB9B5),
    ),
    _FoodItem(
      name: 'Chicken',
      price: '\$20.00',
      image: '🍗',
      color: Color(0xFFFFEAA3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E8B6),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(UploadProductScreen.routeName);
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
                    'Recommend Food',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _RecommendedGrid(),
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
            'Search Food',
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

class _RecommendedGrid extends StatelessWidget {
  const _RecommendedGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: DashboardScreen._foods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 22,
        mainAxisSpacing: 30,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        return _FoodCard(food: DashboardScreen._foods[index]);
      },
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({required this.food});

  final _FoodItem food;

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
                  color: food.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.fromLTRB(12, 88, 12, 16),
                child: Column(
                  children: [
                    const _RatingRow(),
                    const SizedBox(height: 8),
                    Text(
                      food.name,
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
                          food.price,
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
                child: FittedBox(fit: BoxFit.contain, child: Text(food.image)),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: Color(0xFFFF2F00), size: 18),
        SizedBox(width: 3),
        Flexible(
          child: Text(
            '4.9  (54 Reviews)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF565656),
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem {
  const _CategoryItem(this.icon, this.isSelected);

  final String icon;
  final bool isSelected;
}

class _FoodItem {
  const _FoodItem({
    required this.name,
    required this.price,
    required this.image,
    required this.color,
  });

  final String name;
  final String price;
  final String image;
  final Color color;
}
