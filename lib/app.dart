import 'package:flutter/material.dart';
import 'feature/historyAndProfile/presentation/screens/history_screen.dart';
import 'feature/historyAndProfile/presentation/screens/profile_screen.dart';
import 'feature/map/presentation/screens/work/home_screen_driver.dart';
import 'navigation/custom_bottom_nev_bar.dart';

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreenDriver(),
    //HomeScreen(),
    SizedBox(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
