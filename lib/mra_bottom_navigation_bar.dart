import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mis_bengkel/pages/mra/data_service_page.dart';
import 'package:mis_bengkel/pages/mra/form_promo_page.dart';
import 'package:mis_bengkel/pages/mra/status_service_customer_page.dart';

class MRABottNavBar extends StatefulWidget {
  const MRABottNavBar({Key? key}) : super(key: key);

  @override
  State<MRABottNavBar> createState() => _MRABottNavBarState();
}

class _MRABottNavBarState extends State<MRABottNavBar> {
  int currentIndex = 0;
  final List<StatefulWidget> screens = [
    StatusServiceCustomerPage(),
    FormPromoPage(),
    DataServicePage(),
  ];

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
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              label: 'Service Customer',
              activeIcon: Icon(Icons.event_note_rounded),
              //backgroundColor: Colors.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.discount_outlined),
              label: 'Form Promo',
              activeIcon: Icon(Icons.discount),
              //backgroundColor: Colors.lightBlue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.build_outlined),
              label: 'Data Service',
              activeIcon: Icon(Icons.build_rounded),
              //backgroundColor: Colors.lightBlue,
            ),
          ],
        ),
      );
}
