import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/custom_bottom_nav.dart';
import 'home_screen.dart';
import 'menu_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

    final screens = const [
      HomeScreen(),
      MenuScreen(),
      OrderHistoryScreen(showBackButton: false),
      ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: provider.currentNavIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: provider.currentNavIndex,
        onTap: (index) => provider.setNavIndex(index),
      ),
    );
  }
}

