// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/register.dart';
import 'screens/achieve_list.dart';
import 'widgets/bottom_nav.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Function> _pageOptions = [
    () => HomeScreen(key: UniqueKey()),
    () => const RegisterScreen(),
    () => const AchieveListScreen(),
    // Add other screens here
  ];
  
  Widget _selectedPage = HomeScreen(key: UniqueKey());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedPage,
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _selectedPage = _pageOptions[_selectedIndex]();
          });
        },
      ),
    );
  }
}
