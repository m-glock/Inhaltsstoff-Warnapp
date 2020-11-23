import 'package:flutter/material.dart';
import 'lists/main.dart';
import 'comparison/main.dart';
import 'analysis/main.dart';
import 'scanning/main.dart';
import 'history/main.dart';

class Destination {
  const Destination(this.title, this.icon, this.color, this.page);
  final String title;
  final IconData icon;
  final MaterialColor color;
  final StatefulWidget page;
}

const List<Destination> allDestinations = <Destination>[
  Destination('Favoriten', Icons.favorite, Colors.blue, FavouritesPage()),
  Destination('Verlauf', Icons.history, Colors.blue, HistoryPage()),
  Destination('Scannen', Icons.camera_alt, Colors.blue, ScanningPage()),
  Destination('Vergleich', Icons.compare_arrows, Colors.blue, ComparisonPage()),
  Destination('Analyse', Icons.bar_chart, Colors.blue, AnalysisPage())
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
        backgroundColor: Colors.blue,
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
            backgroundColor: destination.color,
            label: destination.title,
          );
        }).toList(),
      ),
    );
  }
}
