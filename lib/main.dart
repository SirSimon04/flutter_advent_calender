import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advent_calender/screens/create_calendar/create_calendar.dart';
import 'package:flutter_advent_calender/screens/own_calendars/own_calendars.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const App()
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    OwnCalendars(),
    CreateCalendar(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_view_month_outlined,
            ),
            label: "Meine Kalender",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_rounded),
            label: "Kalender erstellen",
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
      body: _pages[_selectedIndex],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
