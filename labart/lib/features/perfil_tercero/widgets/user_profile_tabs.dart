import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/utils/constants/sizes.dart';

class UserProfileTabs extends StatelessWidget {
  final TabController tabController;

  const UserProfileTabs({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        TabBar(
          controller: tabController,
          
          isScrollable: false,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view_rounded, size: 24)),
            Tab(icon: Icon(Iconsax.save_2, size: 24)),
          ],
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).disabledColor,
          indicator: CustomTabIndicator(
            color: Theme.of(context).primaryColor,
            radius: 4, // Radio de las esquinas
            height: 4, // Altura de la línea
            horizontalPadding: 20, // Espacio horizontal para hacerla más corta que el tab
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelPadding: const EdgeInsets.symmetric(horizontal: TSizes.lg),
          padding: const EdgeInsets.symmetric(horizontal: 80),
        ),
      ),
    );
  }
}

// Indicador personalizado con borderRadius y tamaño ajustable
class CustomTabIndicator extends Decoration {
  final Color color;
  final double radius;
  final double height;
  final double horizontalPadding;

  const CustomTabIndicator({
    required this.color,
    this.radius = 2,
    this.height = 2,
    this.horizontalPadding = 0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(
      color: color,
      radius: radius,
      height: height,
      horizontalPadding: horizontalPadding,
    );
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final Color color;
  final double radius;
  final double height;
  final double horizontalPadding;

  _CustomTabIndicatorPainter({
    required this.color,
    required this.radius,
    required this.height,
    required this.horizontalPadding,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = Offset(
          offset.dx + horizontalPadding,
          configuration.size!.height - height,
        ) &
        Size(
          configuration.size!.width - (2 * horizontalPadding),
          height,
        );

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Color de fondo del contenedor
      child: Theme(
        data: Theme.of(context).copyWith(
          tabBarTheme: TabBarTheme(
            dividerColor: Colors.transparent,
            overlayColor: const MaterialStatePropertyAll(Colors.transparent),
            // Asegurar que el fondo del TabBar sea transparente para heredar el color
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).disabledColor,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent, // Hacer el Material transparente
          elevation: 0,
          child: _tabBar,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => true;
}