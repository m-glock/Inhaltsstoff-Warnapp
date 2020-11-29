
/// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'pages/lists/main.dart';
import 'pages/comparison/main.dart';
import 'pages/analysis/main.dart';
import 'pages/scanning/main.dart';
import 'pages/history/main.dart';

import 'database/databaseHelper.dart';

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

void main() => runApp(MyApp());

/// This is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Inhaltsstoff Warnapp';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}


/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}


/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

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