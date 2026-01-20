import 'package:flutter/material.dart';
import 'package:ridetohealthdriver/feature/earning/presentation/screen/earning_screen.dart';
import 'package:ridetohealthdriver/feature/earning/presentation/screen/ride_history_screen.dart';
import 'package:ridetohealthdriver/helpers/remote/data/socket_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'feature/historyAndProfile/presentation/screens/profile_screen.dart';
import 'feature/map/presentation/screens/work/home_screen_driver.dart';
import 'navigation/custom_bottom_nev_bar.dart';
import 'utils/app_constants.dart';

class AppMain extends StatefulWidget {
  const AppMain({super.key,});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  int _selectedIndex = 0;

  final SocketClient socketClient = SocketClient();
  SharedPreferences? sharedPreferences;
  String userId = '';


  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
    _initUserIdAndJoin();
    // SocketClient().connect(url: )
    super.initState();
  }


    Future<void> _initUserIdAndJoin() async {
    final prefs = await SharedPreferences.getInstance();
    sharedPreferences = prefs;
    final storedUserId = prefs.getString(AppConstants.userId) ?? '';
    if (!mounted) return;
    setState(() {
      userId = storedUserId;
    });
    if (userId.isEmpty) {
      print('⚠️ User ID not found in SharedPreferences');
      return;
    }
    if (socketClient.isConnected) {
      _emitJoin(userId);
    } else {
      socketClient.on('connect', (_) {
        _emitJoin(userId);
      });
    }
  }

  void _emitJoin(String id) {
     socketClient.emit('join-driver', {
          'driverId': id,  // ei key ta backend expect korche
            });
    print('socket join with sender id To checkkkkkkkikk : from AppMain : $id');
  }


  final List<Widget> _pages = [
    HomeScreenDriver(),
    EarningsScreen(),
    RideHistoryPage(),
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
