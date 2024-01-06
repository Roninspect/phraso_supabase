import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:phraso/core/colors/colors.dart';
import '../../../core/constants/tab_widgets.dart';
import '../controller/nav_controller.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(navNotifierProvider);
    return Scaffold(
      body: PageView(
          controller: _pageController,
          children: TabWidgets.tabwidgets,
          onPageChanged: (value) {
            ref.read(navNotifierProvider.notifier).navStateChange(value);
          }),
      bottomNavigationBar: Container(
        height: 85,
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: GNav(
            backgroundColor: backgroundColor,
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(10),
            tabActiveBorder: Border.all(width: 2),
            gap: 10,
            tabBackgroundColor: orangeColor,
            tabs: const [
              GButton(
                icon: FontAwesome.home,
                text: "Home",
              ),
              GButton(
                icon: Ionicons.ios_map_sharp,
                text: "Itinerary",
              ),
              GButton(
                icon: FontAwesome.plane,
                text: "Booking",
              ),
              GButton(
                icon: MaterialIcons.article,
                text: "Blog",
              ),
              GButton(
                icon: MaterialIcons.article,
                text: "Blog",
              ),
            ],
            selectedIndex: index,
            onTabChange: (value) {
              ref.read(navNotifierProvider.notifier).navStateChange(value);
              _pageController.jumpToPage(value);
            },
          ),
        ),
      ),
    );
  }
}
