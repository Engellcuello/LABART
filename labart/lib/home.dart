import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/widgets/RecomendacionesWidget.dart';
import 'package:labart/widgets/publicaciones_widget.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<RxList<Publicacion>> _tabPublicaciones = [
    <Publicacion>[].obs,
    <Publicacion>[].obs,
    // <Publicacion>[].obs,
    // <Publicacion>[].obs,
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).padding.top.clamp(0, 0),
          ),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              title: TabBar(
                controller: _tabController,
                indicatorColor: TColors.primary,
                labelColor: dark ? TColors.white : TColors.darkerGrey,
                unselectedLabelColor: dark ? TColors.darkGrey : TColors.darkGrey,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Recomendado para ti'),
                  Tab(text: 'Publicaciones'),
                  // Tab(text: 'Nuevo'),
                  // Tab(text: 'Popular'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            RecomendacionesWidget(
              isDark: isDark,
            ), // Aquí usas tu widget de recomendaciones
            PublicacionesWidget(
              isDark: isDark,
              initialPublicaciones: _tabPublicaciones[1],
            ),
            // Tercera pestaña (índice 2)
            // PublicacionesWidget(
            //   isDark: isDark,
            //   initialPublicaciones: _tabPublicaciones[2],
            // ),
            // // Cuarta pestaña (índice 3)
            // PublicacionesWidget(
            //   isDark: isDark,
            //   initialPublicaciones: _tabPublicaciones[3],
            // ),
          ],
        ),
      ),
    );
  }
}