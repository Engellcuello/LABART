import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labart/features/explore_more/screens/explorar/categorias/categoriaScreen.dart';
import 'package:labart/features/explore_more/screens/explorar/categorias/screen_usuarios_top/TopUsersScreen.dart';
import 'package:labart/features/explore_more/screens/explorar/exploreScreen.dart';
import 'package:labart/features/explore_more/widgets/search/search_bar.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/helpers/helper_functions.dart';


class ExploreScreenWithTabs extends StatelessWidget {
  const ExploreScreenWithTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExploreRouteController());
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          /// Espacio fijo para la barra de estado (no se mueve con el scroll)
          Container(
            height: MediaQuery.of(context).padding.top,
            color: dark ? TColors.black : TColors.white,
          ),

          /// Contenido con scroll
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  /// SliverAppBar con SearchBar (con espacio arriba y abajo)
                  SliverAppBar(
                    pinned: false,
                    floating: false,
                    toolbarHeight: 30,
                    backgroundColor: dark ? TColors.black : TColors.white,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        children: [
                          const SizedBox(height: 8), // Added space above
                          const ExploreSearchBar(),
                          const SizedBox(height: 8), // Added space below
                        ],
                      ),
                    ),
                  ),

                  /// SliverPersistentHeader para la barra de rutas (se mantiene visible)
                  Obx(() => SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 55,
                      maxHeight: 55,
                      selectedIndex: controller.selectedIndex.value,
                      child: Container(
                        color: dark ? TColors.black : TColors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 5),
                            ExploreRouteBar(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  )),

                ];
              },
              body: Obx(() => controller.currentScreen),
            ),
          ),
        ],
      ),
    );
  }
}

/// Controlador de tamaño para la barra de rutas
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  final int selectedIndex; // 👈 AÑADIDO

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    required this.selectedIndex, // 👈 AÑADIDO
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
           minHeight != oldDelegate.minHeight ||
           child != oldDelegate.child ||
           selectedIndex != oldDelegate.selectedIndex; // 👈 COMPARA ESTO
  }
}


class ExploreRouteBar extends StatelessWidget {
  const ExploreRouteBar({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = ExploreRouteController.to;

    return Obx(() => SizedBox( // Added Obx here to react to changes
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: TSizes.xs),
        children: [
          _buildRouteTab(
            context,
            'Explorar',
            isActive: controller.selectedIndex.value == 0,
            dark: dark,
            onTap: () => controller.changePage(0),
          ),
          _buildRouteTab(
            context,
            'Categorías',
            isActive: controller.selectedIndex.value == 1,
            dark: dark,
            onTap: () => controller.changePage(1),
          ),
          _buildRouteTab(
            context,
            'Personas',
            isActive: controller.selectedIndex.value == 2,
            dark: dark,
            onTap: () => controller.changePage(2),
          ),
        ],
      ),
    ));
  }

  Widget _buildRouteTab(
    BuildContext context,
    String text, {
    bool isActive = false,
    required bool dark,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: TSizes.xs),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: TSizes.lg,
            vertical: TSizes.sm,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? (dark
                    ? TColors.white.withOpacity(0.2)
                    : TColors.grey.withOpacity(0.6))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isActive
                  ? (dark ? TColors.white : const Color.fromARGB(226, 20, 20, 20))
                  : (dark ? const Color.fromARGB(178, 224, 224, 224) : TColors.textSecondary),
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              fontSize: TSizes.fontSizeMd,
            ),
          ),
        ),
      ),
    );
  }
}

class ExploreRouteController extends GetxController {
  static ExploreRouteController get to => Get.find();

  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> exploreScreens = [ 
    const ExploreScreen(),
    const CategoriaGridScreen(),
    const TopUsersScreen()
  ];

  void changePage(int index) {
    selectedIndex.value = index;
    // Removed the update() call - not needed with .obs
  }

  Widget get currentScreen => exploreScreens[selectedIndex.value];
}