import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mis_bengkel/pages/customer/history_service_page.dart';
import 'package:mis_bengkel/pages/customer/home_page.dart';

import 'pages/customer/profile_page.dart';

class BottNavBar extends StatefulWidget {
  const BottNavBar({Key? key}) : super(key: key);

  @override
  State<BottNavBar> createState() => _BottNavBarState();
}

class _BottNavBarState extends State<BottNavBar> {
  int currentIndex = 0;
  final List<StatefulWidget> screens = [
    HomePage(),
    HistoryServicePage(),
    ProfilePage(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          //iconSize: 40,
          type: BottomNavigationBarType.shifting,
          currentIndex: currentIndex,
          unselectedItemColor: Colors.blue,
          selectedItemColor: Colors.blue,
          onTap: (index) {
            setState(() => currentIndex = index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
              activeIcon: Icon(Icons.home),
              //backgroundColor: Colors.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_repeat_outlined),
              label: 'History',
              activeIcon: Icon(Icons.event_repeat_rounded),
              //backgroundColor: Colors.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
              activeIcon: Icon(Icons.person),
              //backgroundColor: Colors.lightBlue,
            ),
          ],
        ),
      );
}
