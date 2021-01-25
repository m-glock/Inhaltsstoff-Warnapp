import 'package:flutter/material.dart';

import './lists/main.dart';
import './comparison/main.dart';
import './analysis/main.dart';
import './scanning/main.dart';
import './history/main.dart';

class Destination {
  const Destination(this.title, this.icon, this.page);
  final String title;
  final IconData icon;
  final StatefulWidget page;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Favoriten', Icons.favorite, FavouritesPage()),
  Destination('Verlauf', Icons.history, HistoryPage()),
  Destination('Scannen', Icons.camera_alt, ScanningPage()),
  Destination('Vergleich', Icons.compare_arrows, ComparisonPage()),
  Destination('Analyse', Icons.bar_chart, AnalysisPage())
];

/// This is the stateful widget that the main application instantiates.
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/// This is the private State class that goes with HomePage.
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: allDestinations.map<Widget>((Destination destination) {
            return destination.page;
          }).toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.6),
        selectedFontSize: 12,
        unselectedFontSize: 10,
        unselectedIconTheme: IconThemeData(
          color: Colors.white,
          opacity: 0.6,
          size: 16,
        ),
        selectedIconTheme: IconThemeData(
          color: Colors.white,
          opacity: 1,
          size: 20,
        ),
        onTap: _onItemTapped,
        items: allDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            backgroundColor: Theme.of(context).primaryColor,
            label: destination.title,
          );
        }).toList(),
      ),
    );
  }
}
