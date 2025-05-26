import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/features/notifications/widgets/tabbar/widgets/overshoot_curve.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/sizes.dart';


class TabBarWithIndicator extends StatefulWidget implements PreferredSizeWidget {
  final bool isDark;
  final TabController tabController;

  const TabBarWithIndicator({
    super.key,
    required this.isDark,
    required this.tabController, required List<Tab> tabs,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  State<TabBarWithIndicator> createState() => _TabBarWithIndicatorState();
}

class _TabBarWithIndicatorState extends State<TabBarWithIndicator> 
    with SingleTickerProviderStateMixin {
  late AnimationController _indicatorController;
  late Animation<Alignment> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _updateIndicatorAnimation();
    widget.tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_indicatorController.isAnimating) {
      _updateIndicatorAnimation();
      _indicatorController.forward(from: 0);
    }
  }

  Alignment _getAlignmentForIndex(int index) {
    return index == 0 ? Alignment.centerLeft : Alignment.centerRight;
  }

  void _updateIndicatorAnimation() {
    final targetIndex = widget.tabController.index;
    
    _indicatorAnimation = Tween<Alignment>(
      begin: _getAlignmentForIndex(targetIndex == 0 ? 1 : 0),
      end: _getAlignmentForIndex(targetIndex),
    ).animate(
      CurvedAnimation(
        parent: _indicatorController,
        curve: OvershootCurve(),
      ),
    );
    
    _indicatorController.forward(from: 0);
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    widget.tabController.removeListener(_handleTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.md, vertical: TSizes.sm),
        child: Stack(
          children: [
            // Fondo del tab bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: widget.isDark ? const Color.fromARGB(146, 32, 39, 41) : Color.fromARGB(255, 238, 238, 238),
                borderRadius: BorderRadius.circular(35),

              ),
            ),
            
            // Indicador animado
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _indicatorController,
                builder: (context, child) {
                  return Align(
                    alignment: _indicatorAnimation.value,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: widget.isDark ? const Color.fromARGB(255, 38, 46, 48) : TColors.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                              color: widget.isDark ? const Color.fromARGB(255, 87, 87, 87).withOpacity(0.15) : TColors.black.withOpacity(0.1),
                              blurRadius: 3,
                              spreadRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Pestañas
            Theme(
  data: Theme.of(context).copyWith(
    tabBarTheme: TabBarTheme(
      dividerColor: Colors.transparent, // 🔥 Elimina la línea divisoria
      labelColor: widget.isDark ? Colors.white : Colors.black,
      unselectedLabelColor: widget.isDark 
          ? const Color.fromARGB(113, 255, 255, 255) 
          : Colors.black54,
      labelStyle: const TextStyle(
        fontSize: 16, // 🔥 Tamaño más grande cuando está seleccionado
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 13, // 🔥 Tamaño normal cuando NO está seleccionado
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  child: TabBar(
    controller: widget.tabController,
    indicatorColor: Colors.transparent,
    indicatorSize: TabBarIndicatorSize.tab,
    splashFactory: NoSplash.splashFactory,
    overlayColor: MaterialStateProperty.all(Colors.transparent),
    onTap: (index) {
      widget.tabController.animateTo(index);
    },
    tabs: const [
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.message_copy, size: 20),
            SizedBox(width: 3),
            Text('Comentarios'),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.heart_copy, size: 20),
            SizedBox(width: 3),
            Text('Reacciones'),
          ],
        ),
      ),
    ],
  ),
),

          ],
        ),
      ),
    );
  }
}